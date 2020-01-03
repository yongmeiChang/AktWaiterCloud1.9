//
//  AFNetWorkingRequest.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AFNetWorkingRequest : NSObject
+ (instancetype)sharedTool;

//#pragma mark 签入
//-(void)requestWithSignInParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
//                     success:(void (^)(id responseObject))success
//                     failure:(void (^)(NSError *error))failure;

#pragma mark 获取签入信息
-(void)requestWithSignInPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

#pragma mark 获取签出信息
-(void)requestWithSignOutPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

//#pragma mark 忘记密码
//-(void)requestWithFindPassWordParameters:(NSDictionary *)param  type:(HttpRequestType)type
//                                    success:(void (^)(id responseObject))success
//                                    failure:(void (^)(NSError *error))failure;

#pragma mark 获取用户余额
-(void)requestWithGetCustomerBalanceParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

#pragma mark 忘记密码
-(void)requestWithForgetPasswordParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;

#pragma mark 扫描二维码(下单页面,工单)
-(void)requestWithScanWorkOrderParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

#pragma mark 扫描二维码(工单扫码)
-(void)requestWithStartOrderFormParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;


#pragma mark 获取服务项目
-(void)requestWithGetServicePojCustomerUkeyParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;

#pragma mark 下单提交
-(void)requestsubmitOrder:(NSDictionary *)param  type:(HttpRequestType)type
                                                                success:(void (^)(id responseObject))success
                                                                    failure:(void (^)(NSError *error))failure;
/**
 * 检查工单是否需要验证时长和定位
 * 时长不足是否允许结单：1，可以结单，0，不可以结单，为null时可以结单
 *
 * @param workId
 */
#pragma mark - 是否可以签入 签出
-(void)requesttimeAndLocationStatement:(NSDictionary *)param  type:(HttpRequestType)type
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
#pragma mark 工单签入
-(void)requestsignIn:(NSDictionary *)param  type:(HttpRequestType)type
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

#pragma mark 工单签出
-(void)requestsignOut:(NSDictionary *)param  type:(HttpRequestType)type
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

#pragma mark 请求待办工单
-(void)requesthistoryNoHandled:(NSDictionary *)param  type:(HttpRequestType)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

#pragma mark 请求未完成工单
-(void)requestgetWorkByStatus:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark 请求计划工单
-(void)requesttoBeHandle:(NSDictionary *)param  type:(HttpRequestType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark 请求各类工单数量
-(void)requestfindToBeHandleCount:(NSDictionary *)param  type:(HttpRequestType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark 编辑个人资料(头像)
-(void)requestupdateWaiterInfo:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark 获取抢单列表
-(void)requestgetGrapWorkList:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


#pragma mark 获取签入签出图片 101：签入 102：签出
-(void)requestgetWorkOrderImages:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark 变更工单
-(void)requestaskForWorkChange:(NSDictionary *)param  type:(HttpRequestType)type
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

#pragma mark 通知
-(void)requestgetPushRecordService:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark 根据工单id获取工单详情
-(void)requestgetWorkOrder:(NSDictionary *)param  type:(HttpRequestType)type
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

#pragma mark 抢单按钮
-(void)requestUpdateGrabWorkOrder:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

#pragma mark 按月查看某天工单
-(void)requestgetWorkByDay:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;
/*
#pragma mark 按月时间段工单
-(void)requestgetWorkListByDay:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
*/
#pragma mark 修改密码
-(void)requesteditPassword:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

#pragma mark 获取appstore上app版本信息
-(void)requestgetversion:(NSDictionary *)param Url:(NSString*)url  type:(HttpRequestType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark 上传连续定位信息
-(void)uploadLocateInformation:(NSDictionary *)param Url:(NSString*)url  type:(HttpRequestType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;


#pragma mark 上传工单节点
-(void)uploadWorkNode:(NSDictionary *)param Url:(NSString*)url  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
@end


