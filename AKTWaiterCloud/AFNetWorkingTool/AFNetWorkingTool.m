//
//  AFNetWorkingTool.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "AFNetWorkingTool.h"

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
    NSString *url = [NSString stringWithFormat:@"%@/%@",SERVICEURL,URLString];

    NSLog(@"requst:%@\n参数:%@",url,parameters);
    switch (type) {
            
        case HttpRequestTypeGet:
        {
            [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (success) {
                    id jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
                    NSLog(@"response:%@",jsons);
                    success(jsons);
                }
                [[AppDelegate sharedDelegate] hidHUD];
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
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (success) {
                    id jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
                     NSLog(@"response:%@",jsons);
                    success(jsons);
                }
                [[AppDelegate sharedDelegate] hidHUD];
                
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
