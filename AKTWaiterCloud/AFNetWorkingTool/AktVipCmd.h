//
//  AktVipCmd.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/16.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorkingTool.h"

#define AKTGetBalanceMethod @"getCustomerBalance" // 获取余额
#define AKTGetPwdMethod @"getPassword" // 忘记密码
#define AKTEditPwdMethod @"editPassword" // 修改密码
#define AKTGetNoticeListMethod @"getPushRecordService" // 通知
#define AKTNoticeDetailsMethod @"getWorkOrder" // 通知详情
#define AKTOrderTypeNumberMethod @"findToBeHandleCount" // 工单数量
#define AKTSaveUserinfoMethod @"waiterEdit" // 保存个人信息
#define AKTFeedBackMethod @"submitFeedBack" // 意见反馈

NS_ASSUME_NONNULL_BEGIN

@interface AktVipCmd : NSObject
+ (instancetype)sharedTool;

/*忘记密码*/
-(void)requestWithForgetPasswordParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure;
/*修改密码*/
-(void)requesteditPassword:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/*通知*/
-(void)requestgetPushRecordService:(NSDictionary *)param  type:(HttpRequestType)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
/*通知详情*/
-(void)requestgetWorkOrder:(NSDictionary *)param  type:(HttpRequestType)type
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/*请求各类工单数量*/
-(void)requestfindToBeHandleCount:(NSDictionary *)param  type:(HttpRequestType)type
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
/*保存个人信息*/
-(void)requestedSaveUserInfo:(NSDictionary *)param type:(HttpRequestType)type success:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

/*意见反馈*/
-(void)requestPushFeedbackInfo:(NSDictionary *)param type:(HttpRequestType)type success:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
