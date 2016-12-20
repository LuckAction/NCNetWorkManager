

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
    }
    return self;
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

- (NSMutableArray*)getProArrayWith:(Class)class
{
    unsigned int count  = 0;
    // 获取fatherClass里所有的成员属性
    NSMutableArray *array = [[NSMutableArray alloc]init];
    Ivar *ivars = class_copyIvarList(class, &count);
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
- (NSMutableArray*)getAllPropertiesWith:(Class)class
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(class, &count);
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
- (NSMutableDictionary*)getAllPropertiesAndValueWith:(Class)class
{
    u_int count;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    Ivar *ivars = class_copyIvarList(class, &count);
    
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

@end
