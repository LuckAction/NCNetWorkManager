//
//  NCNetTest.m
//  NCNetWorkManager
//
//  Created by luck chen on 2016/12/17.
//  Copyright © 2016年 luck chen. All rights reserved.
//

#import "NCNetTest.h"

@implementation NCNetTest
+ (id)UpdateServer
{
    NSDictionary *testDic = @{
                              @"success": @1,           //返回结果    成功 0   失败 -1  1已是好友
                              @"error_code": @0,
                              @"name": @"陈贺年",
                              @"age": @18,
                              @"sex": @1,
                              @"userList":@[
                                      @{
                                          @"customer_id":@001,
                                          @"name":@"aaa",
                                          @"sex":@"15",
                                          @"userList":@[
                                                  @{
                                                      @"customer_id":@001,
                                                      @"name":@"aaa",
                                                      @"sex":@"15"
                                                      },
                                                  @{
                                                      @"customer_id":@002,
                                                      @"name":@"bbb",
                                                      @"sex":@"16"
                                                      },
                                                  @{
                                                      @"customer_id":@003,
                                                      @"name":@"ccc",
                                                      @"sex":@"17"
                                                      },
                                                  @{
                                                      @"customer_id":@004,
                                                      @"name":@"ddd",
                                                      @"sex":@"18"
                                                      },
                                                  ]
                                          },
                                      @{
                                          @"customer_id":@002,
                                          @"name":@"bbb",
                                          @"sex":@"16"
                                          },
                                      @{
                                          @"customer_id":@003,
                                          @"name":@"ccc",
                                          @"sex":@"17"
                                          },
                                      @{
                                          @"customer_id":@004,
                                          @"name":@"ddd",
                                          @"sex":@"18"
                                          },
                                      ],
                              @"data":@{
                                      @"api_host":@"api/resest",
                                      @"img_host":@"img/resest",
                                      @"upgrade_link":@"kewiamiao.com",
                                      @"maintenance_message":@"正确",
                                      @"maintenance_mode":@"1",
                                      @"isShowQuestionAnswer":@1,
                                      @"user":@{
                                              @"customer_id":@668,
                                              @"name":@"chenhenian"
                                              },
                                      @"userList":@[
                                              @{
                                                  @"customer_id":@669,
                                                  @"name":@"陈恩爱",
                                                  @"userList":@[
                                                          @{
                                                              @"customer_id":@001,
                                                              @"name":@"aaa",
                                                              @"sex":@"15"
                                                              },
                                                          @{
                                                              @"customer_id":@002,
                                                              @"name":@"bbb",
                                                              @"sex":@"16"
                                                              },
                                                          @{
                                                              @"customer_id":@003,
                                                              @"name":@"ccc",
                                                              @"sex":@"17"
                                                              },
                                                          @{
                                                              @"customer_id":@004,
                                                              @"name":@"ddd",
                                                              @"sex":@"18"
                                                              },
                                                          ]
                                                  
                                                  },
                                              @{
                                                  @"customer_id":@690,
                                                  @"name":@"陈贺年",
                                                  @"carList":@[@{
                                                                   @"color":@006,
                                                                   @"name":@"BMW",
                                                                   @"userList":@[
                                                                           @{
                                                                               @"customer_id":@001,
                                                                               @"name":@"aaa",
                                                                               @"sex":@"15"
                                                                               },
                                                                           @{
                                                                               @"customer_id":@002,
                                                                               @"name":@"bbb",
                                                                               @"sex":@"16"
                                                                               },
                                                                           @{
                                                                               @"customer_id":@003,
                                                                               @"name":@"ccc",
                                                                               @"sex":@"17"
                                                                               },
                                                                           @{
                                                                               @"customer_id":@004,
                                                                               @"name":@"ddd",
                                                                               @"sex":@"18"
                                                                               },
                                                                           ]
                                                                   },
                                                               @{
                                                                   @"color":@007,
                                                                   @"name":@"BYD",
                                                                   @"userList":@[
                                                                           @{
                                                                               @"customer_id":@001,
                                                                               @"name":@"aaa",
                                                                               @"sex":@"15"
                                                                               },
                                                                           @{
                                                                               @"customer_id":@002,
                                                                               @"name":@"bbb",
                                                                               @"sex":@"16"
                                                                               },
                                                                           @{
                                                                               @"customer_id":@003,
                                                                               @"name":@"ccc",
                                                                               @"sex":@"17"
                                                                               },
                                                                           ]
                                                                   }
                                                               ]
                                                  
                                                  
                                                  },
                                              @{
                                                  @"customer_id":@678,
                                                  @"name":@"李李李"
                                                  },
                                              @{
                                                  @"customer_id":@666,
                                                  @"name":@"中中中"
                                                  },
                                              ]
                                      }
                              };
    return testDic;
}

@end
