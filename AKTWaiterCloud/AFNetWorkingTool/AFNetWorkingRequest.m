//
//  AFNetWorkingRequest.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "AFNetWorkingRequest.h"
@implementation AFNetWorkingRequest
static AFNetWorkingRequest * aq_instance = nil;

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aq_instance = [[self alloc]init];
    });
    return aq_instance;
}

/* 获取签入信息*/
-(void)requestWithSignInPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetSignInInfoMethod parameters:param type:type success:^(id responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*获取签出信息*/
-(void)requestWithSignOutPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetSignOutInfoMethod parameters:param type:type success:^(id responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*扫描二维码(下单 待办页面)*/
-(void)requestWithScanWorkOrderParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTScanWorkOrderMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*扫描二维码(添加工单)*/
-(void)requestWithStartOrderFormParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                  success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTStartOrderMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        failure(error);
    }];
}
/*获取服务项目*/
-(void)requestWithGetServicePojCustomerUkeyParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                              success:(void (^)(id responseObject))success
                                              failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetServiceTypeMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        failure(error);
    }];
}
/*下单提交*/
-(void)requestsubmitOrder:(NSDictionary *)param  type:(HttpRequestType)type
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTWaiterOrderMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*是否可以签入 签出*/
-(void)requesttimeAndLocationStatement:(NSDictionary *)param  type:(HttpRequestType)type
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTTimeAndLocationMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*工单签入*/
-(void)requestsignIn:(NSDictionary *)param  type:(HttpRequestType)type
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTSigninMethod parameters:param type:type success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = dic[@"message"];
        NSLog(@"%@",message);
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*工单签出*/
-(void)requestsignOut:(NSDictionary *)param  type:(HttpRequestType)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTSignOutMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark - 工单列表
/*任务*/
-(void)requesthistoryNoHandled:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTHistoryNoHandledMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/* 我的工单*/
-(void)requestgetWorkByStatus:(NSDictionary *)param  type:(HttpRequestType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTMyOrderWorkListMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*请求计划工单*/
-(void)requesttoBeHandle:(NSDictionary *)param  type:(HttpRequestType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTPlanOrderListMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*获取签入签出图片 101：签入 102：签出*/
-(void)requestgetWorkOrderImages:(NSDictionary *)param  type:(HttpRequestType)type
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTOrderImageMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/*上传连续定位信息*/
-(void)uploadLocateInformation:(NSDictionary *)param type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTUploadLocationInfoMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*上传工单节点*/
-(void)uploadWorkNode:(NSDictionary *)param type:(HttpRequestType)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTUploadWorkNodeMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/*新增接口 */
-(void)requestFindAdvantage:(NSDictionary *)param type:(HttpRequestType)type
success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTFindAdvancedMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/*新增接口 工单签入 签出 配置*/
-(void)requestOrderStop:(NSDictionary *)param
                       type:(HttpRequestType)type
                    success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTOrderStopMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*新增接口 判断是否有 工单签入 */
-(void)requestCheckSignInStatus:(NSDictionary *)param
   type:(HttpRequestType)type
success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTCheckSignInStatusMethod parameters:param type:type success:^(id responseObject) {
          success(responseObject);
      } failure:^(NSError *error) {
          failure(error);
      }];
}
@end
