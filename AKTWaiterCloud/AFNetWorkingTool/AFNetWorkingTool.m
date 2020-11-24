//
//  AFNetWorkingTool.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "AFNetWorkingTool.h"
#import "NSString+JSONToDictionary.h"
#import "SaveDocumentArray.h"

@interface AFNetWorkingTool()
@property (nonatomic,strong) NSString * baseurl;
@end

@implementation AFNetWorkingTool
static AFNetWorkingTool * a_instance = nil;

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        a_instance = [[self alloc] initWithBaseURL:nil];
        [a_instance initialize];
    });
    return a_instance;
}

- (void)initialize{
    _baseurl = SERVICEURL;
}


#pragma mark 封装的请求方法
- (void)doOptionResponse:(id)responseObj Url:(NSString *)url parameters:(NSString *)p success:(void (^)(id))success failure:(void (^)(NSError *error))failure{
    //code msg permission data
    NSError *err = nil;
    NSData *retData = responseObj;
    NSString *result =  [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
    NSDictionary *retDict = [result toDictionaryWithError:&err];
    NSLog(@" requst:%@ \n 参数:%@ \n response:%@",url,p,result);
    
    if (err) {
        failure(err);
        return;
    }else if ([[retDict objectForKey:ResponseCode] integerValue] == 3){
        [[AppDelegate sharedDelegate] showAlertView:@"温馨提示" des:@"您的账户登录过期，请重新登录!" cancel:@"3" action:@"重新登录" acHandle:^(UIAlertAction *action) {
            //注销登录删除用户数据
            [[SaveDocumentArray sharedInstance] removefmdb];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:Token];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:AKTName];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:AKTPwd];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:ChangeRootViewController object:nil];
        }];
        return;
        
    }else{
        [[AppDelegate sharedDelegate] hidHUD];
        id jsons = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers  error:nil];
        success(jsons);
       return;
    }
}

- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if([URLString isEqualToString:@"getWorkOrderImages"]){
        manager.requestSerializer.timeoutInterval = 300.f;
    }else{
        manager.requestSerializer.timeoutInterval = 20.0f;
    }
    //将token封装入请求头
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:Token];
    // 登录、获取验证码、找回密码、注册、租户列表  中间连接修改
    NSString *url;//getCheckCode  getPassword waiterRegister getTenantsTree  appToken  getAppVersion
    if ([URLString isEqualToString:@"appToken"] || [URLString isEqualToString:@"getCheckCode"] || [URLString isEqualToString:@"getPassword"] || [URLString isEqualToString:@"getTenantsTree"] || [URLString isEqualToString:@"getAppVersion"] || [URLString isEqualToString:@"waiterRegister"]) {
        url = [NSString stringWithFormat:@"%@/api/auth/jwt/%@",SERVICEURL,URLString];
    }else{
        url = [NSString stringWithFormat:@"%@/api/app/appService/%@",SERVICEURL,URLString];
    }

    switch (type) {
            
        case HttpRequestTypeGet:
        {
            [manager GET:url parameters:parameters headers:@{@"Authorization":kString(token),@"Client-Type":@"2"} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self doOptionResponse:responseObject Url:url parameters:parameters success:success failure:failure];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
                [[AppDelegate sharedDelegate] hidHUD];
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [manager POST:url parameters:parameters headers:@{@"Authorization":kString(token),@"Client-Type":@"2"} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self doOptionResponse:responseObject Url:url parameters:parameters success:success failure:failure];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    failure(error);
                }
                [[AppDelegate sharedDelegate] hidHUD];
            }];
        }
            break;
        case HttpRequestTypePut:
        {
            [manager PUT:url parameters:parameters headers:@{@"Authorization":kString(token),@"Client-Type":@"2"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self doOptionResponse:responseObject Url:url parameters:parameters success:success failure:failure];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               if (failure) {
                    failure(error);
                }
                [[AppDelegate sharedDelegate] hidHUD];
            }];
        }
            break;
        default:
            break;
    }
}


@end
