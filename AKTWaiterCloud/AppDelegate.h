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
//#import "MainController.h"
typedef NS_ENUM (NSInteger,LoginType)
{
    Off_line = 0,//离线
    On_line = 1//在线
};

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>{

}
@property(nonatomic,strong) NSString * Registration_ID;//极光ID
@property(nonatomic,assign) BOOL isclean;//是否清除过缓存
@property(nonatomic,strong) UserInfo * userinfo;
@property(nonatomic,assign) BOOL IsAutoLogin;//是否自动登陆
@property(nonatomic) int netWorkType;//当前网络状态
@property(nonatomic,strong) NSMutableArray * OrderTypeCountArr;
//@property(nonatomic,strong) MainController * maincontroller;
@property(nonatomic,strong) NSString * unfinish;//未开始数量
@property(nonatomic,strong) NSString * doing;//进行中数量
@property(nonatomic,strong) NSString * finish;//已完成数量
@property(nonatomic,strong) NSString * unsubmit;//未提交数量
//@property(nonatomic,strong) UIImage * userheadimage;//用户头像
@property(nonatomic,assign) int isrx; //是否刷新rootview 0不刷新 1刷新
@property(strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) dispatch_semaphore_t sema;
@property(strong,nonatomic) RangeUtil* Rutil;
@property(strong, nonatomic) NSMutableArray * minuteArray;//工单详情数据（需要仔细想想是否有必要存在）
//@property(strong, nonatomic) UITabBarController * mainController;
@property (strong, nonatomic) UITabBarController *rootViewController;

+ (AppDelegate *)sharedDelegate; // 单例
+ (UIViewController *)getCurrentVC;
// 风火轮封装
- (void)showLoadingHUD:(UIView *)vi msg:(NSString *)msg;
- (void)showTextOnly:(NSString *)msg;
- (void)hidHUD;
- (void)showAlertView:(NSString *)title des:(NSString *)des cancel:(NSString *)cl action:(NSString *)ac acHandle:(void (^)(UIAlertAction *action))handler;

@end

