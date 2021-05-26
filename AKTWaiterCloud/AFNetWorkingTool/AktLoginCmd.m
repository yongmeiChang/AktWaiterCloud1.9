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
         NSDictionary * result = responseObject;
        // 目前后台没有存储开启离线模式字段 手动添加默认关闭
                    NSNumber * code = [result objectForKey:ResponseCode];
                    if([code intValue] == 1){
                        NSDictionary * userdic = [result objectForKey:ResponseData];
                        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userdic];
                        LoginModel *model = [[LoginModel alloc] initWithDictionary:dic error:nil];
                        model.uuid = model.id;
                        [model save];
                        // 登录成功@"waiterUkey":name,@"password":pwd
                        [[NSUserDefaults standardUserDefaults] setObject:kString(model.token) forKey:Token];
                        [[NSUserDefaults standardUserDefaults] setObject:[param objectForKey:@"waiterUkey"] forKey:AKTName];
                        [[NSUserDefaults standardUserDefaults] setObject:[param objectForKey:@"password"] forKey:AKTPwd];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        // 个人信息
                        NSDictionary *parma = @{@"tenantsId":kString(model.tenantId),@"id":kString(model.uuid)};
                        [[[AktVipCmd alloc] init] requestUserInfo:parma type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
                            NSDictionary *dic = [responseObject objectForKey:ResponseData];
                            
                            UserInfo * user = [[UserInfo alloc] initWithDictionary:dic error:nil];
                            user.uuid = user.id;
                            [user saveUser];
                        } failure:^(NSError * _Nonnull error) {
                            [[AppDelegate sharedDelegate] showTextOnly:error.domain];
                        }];
                    }
           success(responseObject);
       } failure:^(NSError *error) {
           failure(error);
       }];
}
@end
