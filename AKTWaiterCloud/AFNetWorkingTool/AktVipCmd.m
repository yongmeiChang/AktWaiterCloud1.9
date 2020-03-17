//
//  AktVipCmd.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/16.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktVipCmd.h"

@implementation AktVipCmd
static AktVipCmd * aq_instance = nil;

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aq_instance = [[self alloc]init];
    });
    return aq_instance;
}

/*忘记密码*/
-(void)requestWithForgetPasswordParameters:(NSDictionary *)param  type:(HttpRequestType)type
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetPwdMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*修改密码*/
-(void)requesteditPassword:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTEditPwdMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*通知*/
-(void)requestgetPushRecordService:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTGetNoticeListMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*通知详情*/
-(void)requestgetWorkOrder:(NSDictionary *)param  type:(HttpRequestType)type
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTNoticeDetailsMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/* 请求各类工单数量*/
-(void)requestfindToBeHandleCount:(NSDictionary *)param  type:(HttpRequestType)type
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTOrderTypeNumberMethod parameters:param type:type success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSDictionary * map = dic[@"map"];
        NSNumber * code = dic[@"code"];
        if([code longValue]==1){
            appDelegate.unfinish = map[@"count1"];
            appDelegate.doing =map[@"count2"];
            appDelegate.finish = map[@"count3"];
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

/*保存个人信息*/
-(void)requestedSaveUserInfo:(NSDictionary *)param type:(HttpRequestType)type success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure{
    [[AFNetWorkingTool sharedTool] requestWithURLString:AKTSaveUserinfoMethod parameters:param type:type success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
