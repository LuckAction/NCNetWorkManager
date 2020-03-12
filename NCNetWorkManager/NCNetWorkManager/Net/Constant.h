//
//  Constant.h
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define RETURN_MODEL_FUNC(recv_struct) +(instancetype)wrap_unpack:(id)in_data \
{ \
if(in_data == nil || ![in_data isKindOfClass:[NSDictionary class]]) return nil;\
NSDictionary *dic = (NSDictionary *)in_data;\
if(dic.count == 0) return nil;\
recv_struct *re_value = [[recv_struct alloc]init]; \
return ([re_value unpack_nsdic:dic])?re_value:nil; \
}

#define SEND_PATH(send_struct) -(NSString *)CodeName{ return @#send_struct; }

#define RETURN_MODEL(type) -(id)return_unpack_wrap:(NSDictionary *)dic\
{\
return [type wrap_unpack:dic];\
}

#define WRAP_UNPACK_ARRAY(value,NS_TYPE)\
{\
NSArray *child_array = dic[value];\
NSMutableArray *objArray = [[NSMutableArray alloc]init];\
if (child_array != NULL && [child_array isKindOfClass:[NSArray class]] && child_array.count > 0)\
{\
unsigned num = 0;\
for (id child_dic in child_array)\
{\
NCNetModel *child_value = [NS_TYPE mj_objectWithKeyValues:child_dic]; \
if(![child_value unpack_nsdic:child_dic]) continue; \
[objArray addObject:child_value];\
num++;\
}\
}\
if(objArray) [self setValue:objArray forKey:key];\
}

#define WRAP_UNPACK_NCARRAY(value,NS_TYPE)\
{\
NSArray *child_array = dic[value];\
NSMutableArray *objArray = [[NSMutableArray alloc]init];\
if (child_array != NULL && [child_array isKindOfClass:[NSArray class]] && child_array.count > 0)\
{\
unsigned num = 0;\
for (id child_dic in child_array)\
{\
NCNetModel *child_value = [NS_TYPE mj_objectWithKeyValues:child_dic]; \
if(![child_value unpack_nsdic:child_dic]) continue; \
[objArray addObject:child_value];\
num++;\
}\
}\
[modelArray addObjectsFromArray:objArray];\
if (modelArray) [self setValue:modelArray forKey:key];\
}

#define WRAP_UNPACK_DIC(value,NS_TYPE)\
{\
if (dic != NULL && [dic isKindOfClass:[NSDictionary class]] && dic.count > 0)\
{\
[self setValue:[NS_TYPE mj_objectWithKeyValues:dic[value]] forKey:value];\
NCNetModel *model = [self valueForKey:value];\
[model unpack_nsdic:dic];\
}\
}

#define URL(string) [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]

#if _DEBUG_LOCAL_RETURN_
#define LOCAL_RETURN_TEST(value) \
{\
value.local_return_dic = [value local_return];\
}

#else
#define LOCAL_RETURN_TEST(value)
#endif

#endif /* Constant_h */
