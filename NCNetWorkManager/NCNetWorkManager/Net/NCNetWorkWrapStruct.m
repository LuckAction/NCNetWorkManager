
#import "NCNetWorkWrapStruct.h"
#import "MJExtension.h"


@implementation BaseSendInfoGJM
@synthesize mode = _mode,parameterStr = _parameterStr;


- (instancetype)initWith:(NSInteger)model
{
    self = [super init];
    self->_mode = model;
    return self;

}
-(NSData *)pack_to_nsdata
{
    return [[self description] dataUsingEncoding:NSUTF8StringEncoding];
}
-(NSString *)CodeName
{
    return nil;
}
-(id)return_unpack_wrap:(NSDictionary *)dic
{
    return nil;
}
-(NSURL *)connect_url
{
    if ([NCNetWorkNetManager shareNCNetWorkNetManager].openLogin) NSLog(@"%@",self.url);

    return URL(self.url);//传进来的url
}
- (NSString *)parameterStr
{
    return _parameterStr;
}
- (NSMutableDictionary*)wrap_pack:(NSMutableDictionary*)dic{ return dic; }

-(NSString *)description
{
    NSMutableDictionary *dic = [self getParameters];
    if ([NCNetWorkNetManager shareNCNetWorkNetManager].openLogin) NSLog(@"%@",dic);
    return (dic == nil || dic.count<=0)?@"" : [dic mj_JSONString];
}

- (NSMutableDictionary*)getParameters
{
    return [self wrap_pack:[self mj_keyValuesWithIgnoredKeys:[self getIgnoredArray]]];
}

- (NSMutableArray*)getIgnoredArray
{
    Class fatherClass = self.class;
    @autoreleasepool {
        while ([fatherClass.superclass isSubclassOfClass:[BaseSendInfoGJM class]]) {
            fatherClass = fatherClass.superclass;
        }
    }
    return [self getProArrayWith:fatherClass];
}

@end

@implementation GetSend

- (id)init
{
    self = [super initWith:0];
    return self;
}
@end

@implementation PostSend
- (id)init
{
    self = [super initWith:1];
    return self;
}
@end


@implementation PutSend

- (id)init
{
    self = [super initWith:2];
    return self;
}
@end

@implementation DeleteSend

- (id)init
{
    self = [super initWith:3];
    return self;
}

@end


@implementation RecvStruct


#define PARING()\
{\
NSMutableDictionary *properDic = [self getAllPropertiesAndValue];\
for (NSString *key in [properDic allKeys]) {\
    Class objclass = NSClassFromString([properDic objectForKey:key]);\
    if ([objclass isSubclassOfClass:[NCNetModel class]]) {\
        WRAP_UNPACK_DIC(key, objclass)\
    }else if((objclass == [NSArray class]) || (objclass == [NSMutableArray class]) ){\
        NSMutableArray *modelArray = [self valueForKey:key];\
        if (modelArray.childClass) {\
            WRAP_UNPACK_NCARRAY(key,modelArray.childClass)\
        }else{\
            WRAP_UNPACK_ARRAY(key, objclass)\
        }\
    }else if((objclass == [NSDictionary class]) || (objclass == [NSMutableDictionary class])){\
        [self setValue:dic[key] forKey:key];\
    }else {\
        if (dic[key]) {\
            [self setValue:dic[key] forKey:key];\
        }\
    }\
}\
}

+(instancetype)wrap_unpack:(NSDictionary *)dic{ return nil; }
-(BOOL)unpack_nsdic:(NSDictionary *)dic{
    if(dic == nil || dic.count == 0) return false;
    if([NCNetWorkNetManager shareNCNetWorkNetManager].openLogin) NSLog(@"%@",dic);
        [self paring:dic];//解析数据
    return true;
}
-(void)update_info:(id)send_struct{ return; }

- (void)paring:(NSDictionary *)dic
{
    PARING()
    /*特殊情况的处理*/
    if (self.code == 401 | self.code == 400) {
    }else if (self.code == 1001){
    }
}

@end


@implementation ErrorLogUpdate

RETURN_MODEL(Re_ErrorLogUpdate)
@end

@implementation Re_ErrorLogUpdate
RETURN_MODEL_FUNC(Re_ErrorLogUpdate)
@end
