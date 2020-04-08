//
//  AktLoginCmd.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/17.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktLoginCmd.h"

@implementation AktLoginCmd
static AktLoginCmd * aq_instance = nil;

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aq_instance = [[self alloc]init];
    });
    return aq_instance;
}
/*获取版本号*/
-(void)requestAppVersionParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetAppVersionMethod parameters:param type:type success:^(id responseObject) {
           success(responseObject);
       } failure:^(NSError *error) {
           failure(error);
       }];
}
/*租户列表*/
-(void)requestTenantsListParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetTenantsTreeMethod parameters:param type:type success:^(id responseObject) {
              success(responseObject);
          } failure:^(NSError *error) {
              failure(error);
          }];
}
/*获取验证码*/
-(void)requestCheckCodeParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetCheckCodeMethod parameters:param type:type success:^(id responseObject) {
                success(responseObject);
            } failure:^(NSError *error) {
                failure(error);
            }];
}
/*注册*/
-(void)requestRegisterParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTWaiterRegisterMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*登录*/
-(void)requestLoginParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTLoginMethod parameters:param type:type success:^(id responseObject) {
           success(responseObject);
       } failure:^(NSError *error) {
           failure(error);
       }];
}
@end
