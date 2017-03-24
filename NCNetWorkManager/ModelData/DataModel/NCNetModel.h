
#import <Foundation/Foundation.h>
#import "MJFoundation.h"

@interface NCNetModel : MJFoundation

+ (id)nc_objectWithKeyValuesWith:(Class)modelClass value:(id)value;

- (BOOL)unpack_nsdic:(NSDictionary *)dic;
- (id)wrap_pack;
- (id)getPrivateProperty:(NSString *)propertyName;

- (NSMutableArray*)getProArrayWith:(Class)_class;//获取所有的属性名
- (NSMutableArray*)getAllPropertiesWith:(Class)_class;//获取所有的属性类型
- (NSMutableDictionary*)getAllPropertiesAndValueWith:(Class)_class;//获取class所有的属性类型和属性名
- (NSMutableDictionary*)getAllPropertiesAndValue;//获取自己和父类的成员和属性名
- (void)setIvarValue:(id)value forkey:(NSString*)key;//修改属性的值
- (NSString *)setpeopelName:(NSString*)name age:(NSString*)age sex:(NSString*)sex;
@end
