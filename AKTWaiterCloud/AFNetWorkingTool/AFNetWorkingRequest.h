//
//  AFNetWorkingRequest.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorkingTool.h"

#define AKTGetSignInInfoMethod @"getSignInPosition" // 获取签入信息
#define AKTGetSignOutInfoMethod @"getSignOutPosition" // 获取签出信息
#define AKTScanWorkOrderMethod @"scanWorkOrder" // 扫描二维码
#define AKTStartOrderMethod @"startOrderForm" // 扫描二维码(工单扫码)
#define AKTGetServiceTypeMethod @"getServiceType" // 获取服务项目
#define AKTWaiterOrderMethod @"waiterOrder" // 下单提交
#define AKTTimeAndLocationMethod @"timeAndLocationStatement" // 是否可以签入签出
#define AKTSigninMethod @"signIn" // 签入
#define AKTSignOutMethod @"signOut" // 签出
#define AKTHistoryNoHandledMethod @"historyNoHandled" // 任务
#define AKTMyOrderWorkListMethod @"getWorkByStatus" // 我的工单
#define AKTPlanOrderListMethod @"toBeHandle" // 计划工单
#define AKTOrderImageMethod @"getWorkOrderImages" // 获取签入 签出图片
#define AKTUploadLocationInfoMethod @"uploadLocateInformation" // 上传连续定位信息
#define AKTUploadWorkNodeMethod @"uploadWorkNode" // 上传工单节点
//#define AKTOrderDetailsMethod @"" // 工单详情 目前还没有使用
#define AKTFindAdvancedMethod @"findAdvanced" //


@interface AFNetWorkingRequest : NSObject
+ (instancetype)sharedTool;
/*获取签入信息*/
-(void)requestWithSignInPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
/*获取签出信息*/
-(void)requestWithSignOutPositionParameters:(NSMutableDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;
/* 扫描二维码(下单页面,工单)*/
-(void)requestWithScanWorkOrderParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;
/* 扫描二维码(工单扫码)*/
-(void)requestWithStartOrderFormParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
/*获取服务项目*/
-(void)requestWithGetServicePojCustomerUkeyParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
/*下单提交*/
-(void)requestsubmitOrder:(NSDictionary *)param  type:(HttpRequestType)type
                                                                success:(void (^)(id responseObject))success
                                                                    failure:(void (^)(NSError *error))failure;
/**是否可以签入 签出
 * 检查工单是否需要验证时长和定位
 * 时长不足是否允许结单：1，可以结单，0，不可以结单，为null时可以结单   workId
 */
-(void)requesttimeAndLocationStatement:(NSDictionary *)param  type:(HttpRequestType)type
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
/*工单签入*/
-(void)requestsignIn:(NSDictionary *)param  type:(HttpRequestType)type
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
/*工单签出*/
-(void)requestsignOut:(NSDictionary *)param  type:(HttpRequestType)type
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
#pragma mark - 工单列表
/* 任务*/
-(void)requesthistoryNoHandled:(NSDictionary *)param  type:(HttpRequestType)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

/*我的工单*/
-(void)requestgetWorkByStatus:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

/*请求计划工单*/
-(void)requesttoBeHandle:(NSDictionary *)param  type:(HttpRequestType)type
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
/* 获取签入签出图片 101：签入 102：签出*/
-(void)requestgetWorkOrderImages:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

/*上传连续定位信息*/
-(void)uploadLocateInformation:(NSDictionary *)param type:(HttpRequestType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/*上传工单节点*/
-(void)uploadWorkNode:(NSDictionary *)param type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/*工单详情页面*/
/*新增接口 */
-(void)requestFindAdvantage:(NSDictionary *)param type:(HttpRequestType)type
success:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;



@end


