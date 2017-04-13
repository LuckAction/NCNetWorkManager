//
//  NSObject+NCKVO.m
//  NSOperationDemo
//
//  Created by luck chen on 2017/4/5.
//  Copyright © 2017年 luck chen. All rights reserved.
//

#import "NSObject+NCKVO.h"
#import <Objc/runtime.h>
#import <objc/message.h>
NSString *const NCKVOClassPrefix = @"NCKVOClassPrefix_";
NSString *const NCKVOAssociatedObservers = @"NCKVOAssociatedObservers";

@interface NCObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NCObservingBlock block;

@end

@implementation NCObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(NCObservingBlock)block
{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

@end


@implementation NSObject (NCKVO)

#pragma mark - Helpers
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

//
static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}
//

#pragma mark - Overridden Methods
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    // look up observers and call the blocks
    
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(NCKVOAssociatedObservers));
    for (NCObservationInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (each.block) {
                    each.block(each.observer, getterName, oldValue, newValue);
                }
//            });
        }
    }
}



static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}

- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}



- (void)addNCObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath withBlock:(NCObservingBlock)block
{
    SEL setterSelector = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, keyPath];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    // if not an KVO class yet
    if (![clazzName hasPrefix:NCKVOClassPrefix]) {
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        object_setClass(self, clazz);
    }
    
    // add our kvo setter if this class (not superclasses) doesn't implement the setter?
    if (![self hasSelector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    
    NCObservationInfo *info = [[NCObservationInfo alloc]initWithObserver:observer Key:keyPath block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(NCKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(NCKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    [observers addObject:info];
    
}

- (void)removeNCObserver:(NSObject *)observer forKey:(NSString *)key
{
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(NCKVOAssociatedObservers));
    NCObservationInfo *infoRemove ;
    for (NCObservationInfo *info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoRemove = info;
            break;
        }
    }
    [observers removeObject:infoRemove];
}


- (Class)makeKvoClassWithOriginalClassName:(NSString *)className
{
    NSString *kvoClazzName = [NCKVOClassPrefix stringByAppendingString:className];
    Class clazz = NSClassFromString(kvoClazzName);
    
    if (clazz) {
        return clazz;
    }
    
    // class doesn't exist yet, make it
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;

    
}

@end
