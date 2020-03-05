//
//  LoginRequest.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/26.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "LoginRequest.h"
#import "UserFmdb.h"
@implementation LoginRequest

//离线模式切换在线模式时，重新登陆时调用
+(void)RequestLoginName:(NSString *)waiterNo PassWord:(NSString *)password registrationId:(NSString *)rid successBlock:(void(^)(void))successWorking errorBlock:(void(^)(void))errorWorking ohterErrorBlock:(void(^)(void))ohtererrorBlock{
    NSDictionary * dic =@{@"waiterUkey":waiterNo,@"password":password,@"registrationId":rid};
    NSString * url = @"waiterLogin";
    
    [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:dic type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * result = responseObject;
        NSDictionary * userdic = [result objectForKey:@"object"];
        NSNumber * code = [result objectForKey:@"code"];
        if([code intValue] == 1){
            UserInfo * user = [[UserInfo alloc] initWithDictionary:userdic error:nil];
            user.uuid = user.id;
            appDelegate.userinfo = user;
            UserFmdb * userdb = [[UserFmdb alloc] init];
            UserInfo * useroldinfo = [[UserInfo alloc] init];
            useroldinfo = [userdb findByrow:0];
            if(useroldinfo.uuid){
                [userdb updateObject:appDelegate.userinfo];
            }else{
                [userdb saveUserInfo:appDelegate.userinfo];
            }
            if(successWorking){
                successWorking();
            }
        }else{
            if(ohtererrorBlock){
                ohtererrorBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changerootview" object:nil];
            });
        }
        
    } failure:^(NSError *error) {
        if(errorWorking){
            errorWorking();
        }
    }];
}
@end
