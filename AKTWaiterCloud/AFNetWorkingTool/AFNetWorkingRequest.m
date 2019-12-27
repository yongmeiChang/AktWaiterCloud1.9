//
//  AFNetWorkingRequest.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "AFNetWorkingRequest.h"
#import "AFNetWorkingTool.h"
@implementation AFNetWorkingRequest
static AFNetWorkingRequest * aq_instance = nil;

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aq_instance = [[self alloc]init];
    });
    return aq_instance;
}

//#pragma mark 签入
//-(void)requestWithSignInParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
//              success:(void (^)(id responseObject))success
//              failure:(void (^)(NSError *error))failure{
//    [[AFNetWorkingTool sharedTool] requestWithURLString:@"signIn" parameters:param type:type success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        failure(error);
//    }];
//}

#pragma mark 获取签入信息
-(void)requestWithSignInPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getSignInPosition" parameters:param type:type success:^(id responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

#pragma mark 获取签出信息
-(void)requestWithSignOutPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getSignOutPosition" parameters:param type:type success:^(id responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

//#pragma mark 忘记密码
//-(void)requestWithFindPassWordParameters:(NSDictionary *)param  type:(HttpRequestType)type
//                                 success:(void (^)(id responseObject))success
//                                 failure:(void (^)(NSError *error))failure{
//    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getCode" parameters:param type:type success:^(id responseObject) {
//        if(success){
//            NSDictionary * dic = responseObject;
//            NSString * code = [dic objectForKey:@"code"];
//            success(code);
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        failure(error);
//    }];
//}

#pragma mark 获取用户余额
-(void)requestWithGetCustomerBalanceParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getCustomerBalance" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

#pragma mark 忘记密码
-(void)requestWithForgetPasswordParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getPassword" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

#pragma mark 扫描二维码(待办页面)
-(void)requestWithScanWorkOrderParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"scanWorkOrder" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

#pragma mark 扫描二维码(添加工单)
-(void)requestWithStartOrderFormParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                  success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"startOrderForm" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

#pragma mark 获取服务项目
-(void)requestWithGetServicePojCustomerUkeyParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                              success:(void (^)(id responseObject))success
                                              failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getServiceType" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

#pragma mark 下单提交
-(void)requestsubmitOrder:(NSDictionary *)param  type:(HttpRequestType)type
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"waiterOrder" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark - 是否可以签入 签出
-(void)requesttimeAndLocationStatement:(NSDictionary *)param  type:(HttpRequestType)type
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"timeAndLocationStatement" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 工单签入
-(void)requestsignIn:(NSDictionary *)param  type:(HttpRequestType)type
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"signIn" parameters:param type:type success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = dic[@"message"];
        NSLog(@"%@",message);
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 工单签出
-(void)requestsignOut:(NSDictionary *)param  type:(HttpRequestType)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"signOut" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 请求待办工单
-(void)requesthistoryNoHandled:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"historyNoHandled" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 请求未完成工单
-(void)requestgetWorkByStatus:(NSDictionary *)param  type:(HttpRequestType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getWorkByStatus" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 请求计划工单
-(void)requesttoBeHandle:(NSDictionary *)param  type:(HttpRequestType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"toBeHandle" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 请求各类工单数量
-(void)requestfindToBeHandleCount:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"findToBeHandleCount" parameters:param type:type success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSDictionary * map = dic[@"map"];
        NSNumber * code = dic[@"code"];
        if([code longValue]==1){
            appDelegate.unfinish = map[@"count1"];
//            [appDelegate.unfinish stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            appDelegate.doing =map[@"count2"];
//            [appDelegate.doing stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            appDelegate.finish = map[@"count3"];
//            [appDelegate.finish stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }else{
            appDelegate.unfinish = 0;
            appDelegate.finish = 0;
            appDelegate.doing = 0;
        }
    } failure:^(NSError *error) {
        appDelegate.unfinish = 0;
        appDelegate.finish = 0;
        appDelegate.doing = 0;
    }];
}

#pragma mark 编辑个人资料(头像)
-(void)requestupdateWaiterInfo:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"updateWaiterInfo" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 获取抢单列表
-(void)requestgetGrapWorkList:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getGrapWorkList" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 获取签入签出图片 101：签入 102：签出
-(void)requestgetWorkOrderImages:(NSDictionary *)param  type:(HttpRequestType)type
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getWorkOrderImages" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 变更工单
-(void)requestaskForWorkChange:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"askForWorkChange" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 通知
-(void)requestgetPushRecordService:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getPushRecordService" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 根据工单id获取工单详情
-(void)requestgetWorkOrder:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getWorkOrder" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 抢单按钮
-(void)requestUpdateGrabWorkOrder:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"updateGrabWorkOrder" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 按月查看某天工单
-(void)requestgetWorkByDay:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getWorkByDay" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 按月时间段工单
/*-(void)requestgetWorkListByDay:(NSDictionary *)param  type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getWorkListByDay" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
*/
#pragma mark 修改密码
-(void)requesteditPassword:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"editPassword" parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 获取appstore上app版本信息
-(void)requestgetversion:(NSDictionary *)param Url:(NSString*)url  type:(HttpRequestType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{

    [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 上传连续定位信息
-(void)uploadLocateInformation:(NSDictionary *)param Url:(NSString*)url  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark 上传工单节点
-(void)uploadWorkNode:(NSDictionary *)param Url:(NSString*)url  type:(HttpRequestType)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
