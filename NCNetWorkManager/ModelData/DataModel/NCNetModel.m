

#import "NCNetModel.h"
#import "MJExtension.h"

@interface NCNetModel ()
@property (nonatomic,strong) NSMutableArray *allProperties;
@end

@implementation NCNetModel

- (id)init
{
    self = [super init];
    if (self) {
//        SuppressPerformSelectorLeakWarning(
                                           class_addMethod(self.class, NSSelectorFromString(@"method:::"), (IMP)myAddingFunction, "i@:i@:i@");
//        );//新增方法
        class_replaceMethod(self.class, @selector(setpeopelName:age:sex:), (IMP)myAddingFunction, "i@:i@:i@");//替换方法
    }
    return self;
}

- (NSString *)setpeopelName:(NSString*)name age:(NSString*)age sex:(NSString*)sex
{
    return [NSString stringWithFormat:@"%@=%@=%@",name,age,sex];
}
NSString* myAddingFunction(id self, SEL _cmd, NSString* var1, NSString *name,NSString * sex)
{
    NSLog(@"\n %@ = %@ \n",name,var1);
    return [NSString stringWithFormat:@"%@=%@=%@",name,var1,sex];
}

+ (id)nc_objectWithKeyValuesWith:(Class)modelClass value:(id)value
{
    if (value && modelClass) {
        NCNetModel *modelObj = [modelClass mj_objectWithKeyValues:value];
        [modelObj unpack_nsdic:value];
        return modelObj;
    }
    return value;
}
/* 根据属性名，获取属性值 */
- (id)getPrivateProperty:(NSString *)propertyName
{
    Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
    
    if (iVar == nil) {
        iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",propertyName] UTF8String]);
    }
    id propertyVal = object_getIvar(self, iVar);
    return propertyVal;
}

-(BOOL)unpack_nsdic:(NSDictionary *)dic
{
    return  true;
}
-(id)wrap_pack
{
    NSMutableDictionary *dic = [self mj_keyValues];
    return dic;
}

- (NSMutableArray*)getProArrayWith:(Class)_class
{
    unsigned int count  = 0;
    // 获取class里所有的成员属性
    NSMutableArray *array = [[NSMutableArray alloc]init];
    Ivar *ivars = class_copyIvarList(_class, &count);
    for (int i = 0; i < count; i++) {
        // 获取成员属性
        Ivar ivar =  ivars[i];
        // 获取成员属性的属性名
        NSString *name =   @(ivar_getName(ivar));
        NSMutableString *nameString = [[NSMutableString alloc]initWithString:name];
        if ([name hasPrefix:@"_"]) {
            [nameString deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        [array addObject:nameString];
    }
    free(ivars);
    return array;
    
}
/* 获取对象的所有属性，不包括属性值 */
- (NSMutableArray*)getAllPropertiesWith:(Class)_class
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(_class, &count);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [array addObject:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return array;
}
//获取类和父类的成员和属性名
- (NSMutableDictionary*)getAllPropertiesAndValueWith:(Class)_class
{
    u_int count;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    Ivar *ivars = class_copyIvarList(_class, &count);
    
    for (int i = 0; i<count; i++)
    {
        Ivar ivar =  ivars[i];
        // 获取成员属性的属性名
        NSMutableString *nameString = [[NSMutableString alloc]initWithString:@(ivar_getName(ivar))];
        if ([nameString hasPrefix:@"_"]) {
            [nameString deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        NSMutableString *valueString = [[NSMutableString alloc]initWithString:@(ivar_getTypeEncoding(ivar))];
        if ([valueString hasPrefix:@"@"]) {
            [valueString deleteCharactersInRange:NSMakeRange(0, 2)];
            [valueString deleteCharactersInRange:NSMakeRange(valueString.length -1, 1)];
        }
        [dic setValue:valueString forKey:nameString];
    }
    free(ivars);
    return dic;
}
//获取自己和父类的成员和属性名
- (NSMutableDictionary*)getAllPropertiesAndValue
{
    NSMutableDictionary *properDic = [[NSMutableDictionary alloc]init];
    Class fatherClass = self.class;
    @autoreleasepool {
        while ([fatherClass.superclass isSubclassOfClass:[NSObject class]]) {
            NSDictionary *superDic = [self getAllPropertiesAndValueWith:fatherClass];
            [properDic addEntriesFromDictionary:superDic];
            fatherClass = fatherClass.superclass;
        }
    }
    
    return properDic;
}
//修改属性的值
- (void)setIvarValue:(id)value forkey:(NSString*)key
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for (NSInteger i =0 ; i <count; i++) {
        Ivar var = ivars[i];
        NSString *type = [NSString stringWithUTF8String:ivar_getName(var)];
        if ([type isEqualToString:[NSString stringWithFormat:@"_%@",key]]) {
            object_setIvar(self, var, value);
            i = count;
        }
    }
    free(ivars);
}

//获取类中所有的所有私有方法
- (NSMutableArray*)tryMemberFunc
{
    unsigned int count = 0;
    Method *memberFuncs = class_copyMethodList([self class], &count);//所有在.m文件显式实现的方法都会被找到
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < count; i++) {
        Method method = memberFuncs[i];
        SEL name = method_getName(method);
        
        NSString *methodName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [array addObject:methodName];
        NSLog(@"member method:%@", methodName);

    }
    return array;
}

@end
