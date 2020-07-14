//
//  AppDelegate.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/9/29.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import <UserNotifications/UserNotifications.h>
#import "RangeUtil.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>{

}
@property(nonatomic,strong) NSString * Registration_ID;//极光ID
@property(nonatomic,strong) NSString * unfinish;//未开始数量
@property(nonatomic,strong) NSString * doing;//进行中数量
@property(nonatomic,strong) NSString * finish;//已完成数量
//@property(nonatomic,strong) NSString * unsubmit;//未提交数量
@property(nonatomic,assign) int isrx; //是否刷新rootview 0不刷新 1刷新
@property(strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) dispatch_semaphore_t sema;
@property(strong,nonatomic) RangeUtil* Rutil;
@property (strong, nonatomic) UITabBarController *rootViewController;

-(void)getTheCurrentVersion; // 更新提示

+ (AppDelegate *)sharedDelegate; // 单例
+ (UIViewController *)getCurrentVC;
// 风火轮封装
- (void)showLoadingHUD:(UIView *)vi msg:(NSString *)msg;
- (void)showTextOnly:(NSString *)msg;
- (void)hidHUD;
- (void)showAlertView:(NSString *)title des:(NSString *)des cancel:(NSString *)cl action:(NSString *)ac acHandle:(void (^)(UIAlertAction *action))handler;

@end

