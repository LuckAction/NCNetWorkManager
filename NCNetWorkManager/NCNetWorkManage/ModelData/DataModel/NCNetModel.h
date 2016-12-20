
#import <Foundation/Foundation.h>
#import "MJFoundation.h"

@interface NCNetModel : MJFoundation
- (BOOL)unpack_nsdic:(NSDictionary *)dic;
- (id)wrap_pack;
- (id)getPrivateProperty:(NSString *)propertyName;

- (NSMutableArray*)getProArrayWith:(Class)class;//获取所有的属性名
- (NSMutableArray*)getAllPropertiesWith:(Class)class;//获取所有的属性类型
- (NSMutableDictionary*)getAllPropertiesAndValueWith:(Class)class;//获取class所有的属性类型和属性名
- (NSMutableDictionary*)getAllPropertiesAndValue;//获取自己和父类的成员和属性名

@end
