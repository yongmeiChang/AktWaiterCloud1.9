//
//  AktLoginCmd.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/17.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorkingTool.h"

#define AKTGetAppVersionMethod @"getAppVersion" // 获取版本号
#define AKTGetTenantsTreeMethod @"getTenantsTree" // 租户列表
#define AKTGetCheckCodeMethod @"getCheckCode" // 获取验证码
#define AKTWaiterRegisterMethod @"waiterRegister" // 注册
#define AKTLoginMethod @"waiterLogin" // 登录

NS_ASSUME_NONNULL_BEGIN

@interface AktLoginCmd : NSObject
+ (instancetype)sharedTool;

/*获取版本号*/
-(void)requestAppVersionParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
/*租户列表*/
-(void)requestTenantsListParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
/*获取验证码*/
-(void)requestCheckCodeParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
/*注册*/
-(void)requestRegisterParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
/*登录*/
-(void)requestLoginParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
