//
//  AppDelegate.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/9/29.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UnfinishOrderTaskController.h"
#import "AktResetAppView.h" // 更新提示view

//注意，关于 iOS10 系统版本的判断，可以用下面这个宏来判断。不能再用截取字符的方法。
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<JPUSHRegisterDelegate,MBProgressHUDDelegate,AktResetAppDelegate>{
    MBProgressHUD *HUD;
    NSString *trackViewUrl; // appst网址
    UserInfo *modeluser;
}
@property (nonatomic,assign) BOOL isShoPush;//抢单推送距离是否显示通知栏
@end

@implementation AppDelegate
+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//app启动方法 程序被杀死，点击通知后调用此程序
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //UIApplicationLaunchOptionsLocalNotificationKey表示用户点击本地通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击本地通知而被启动，可能为直接点击icon被启动或其他。
    // 本地通知内容获取：NSDictionary *localNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey]

    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    /**极光推送初始化*/
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:JgPushAppKey
                          channel:@"appstore"
                 apsForProduction:YES];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1.0];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //注册通知 获取自定义消息内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewController:) name:ChangeRootViewController object:nil]; // 根视图通知
    //定位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judegeRange:) name:@"localaction" object:nil];
    // 注册bugly
    [Bugly startWithAppId:Bugly_AppId];
    self.Registration_ID=@"";

    //注册高德地图
    [AMapServices sharedServices].apiKey = GAODEAPPKEY;
    
    //日志初始化
    [self initCocoaLumberjack];
    //查找本地缓存用户数据
    modeluser = [UserInfo getsUser];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isUpadateVersion"]) {// 第一次版本更新提示框
         [self getTheCurrentVersion];//版本提示
    }
    // 模式 强制白色
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
    [self.window makeKeyAndVisible];
    /*新版APP基础架构*/
    [self showLoginPage];
    [self setTabBarAndNavigationBarStyle];
    

    return YES;
}
#pragma mark - show login
- (void)showLoginPage{
    NSLog(@"token：%@",[[NSUserDefaults standardUserDefaults] objectForKey:Token]);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:Token]) {
        BaseControllerViewController *login = [BaseControllerViewController createViewControllerWithName:@"LoginViewController" createArgs:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = nav;
    }else{
        //获取各类工单数量
        LoginModel *model = [LoginModel gets];
        NSDictionary * params = @{@"waiterId":kString(model.uuid),@"tenantsId":kString(model.tenantId)};
        [[AktVipCmd sharedTool] requestfindToBeHandleCount:params type:HttpRequestTypeGet success:^(id responseObject) {} failure:^(NSError *error) {}];
        // 重新设置根视图
        self.rootViewController = [self getRootTabVBarAction];
        self.window.rootViewController = self.rootViewController;
    }
}
#pragma mark - jpush
-(void)initJpush{
    // 注册apns通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
}
#pragma mark -
//拖下通知中心/双击Home键使App界面上移
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


//按Home键使App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进入后台时要进行的处理
    //sendNotification(@"end");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

//点击App图标，使App从后台恢复至前台  点击通知中心里面的远程推送，使App从后台进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //sendNotification(@"begin");
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
//拖上通知中心/使App界面恢复原位 点击通知中心里面的远程推送，使App从后台进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//按住减号图标杀死App进程
- (void)applicationWillTerminate:(UIApplication *)application {
}


//日志初始化
-(void)initCocoaLumberjack{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    //保存周期
    fileLogger.rollingFrequency = 660 * 660 * 24; // 24 hour rolling
    //最大的日志文件数量
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
}


#pragma mark - 注册推送回调获取 DeviceToken
#pragma mark -- 成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册成功
    // 极光: Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark -- 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // 注册失败
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - 极光代理方法 通知展示前进行处理
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"推送成功");
    //功能：可设置是否在应用内弹出通知
    if (@available(iOS 10.0, *)) {
        NSDictionary * userInfo = notification.request.content.userInfo;
        UNNotificationRequest *request = notification.request; // 收到推送的请求
        UNNotificationContent *content = request.content; // 收到推送的消息内容
        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题
        
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
            self.isShoPush = true;
            // 创建队列组
            dispatch_group_t group = dispatch_group_create();
            // 创建信号量，并且设置值为0
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_async(group, queue, ^{
                self.sema = dispatch_semaphore_create(0);
                [self didReceiveJPushNotification:userInfo];
                dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
            });
            
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                // 任务全部完成处理
                if(self.isShoPush){
                    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
                }else{
                    return;
                }
            });
        }
        else {
            // 判断为本地通知
            NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
            //[self didReceiveJPushNotification:userInfo];
            completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
        }
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 极光代理方法 点击通知栏
//点击通知栏时的事件
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"推送成功");
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        if(modeluser){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"grabSingle" object:nil userInfo:nil];
        }else{
            return;
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
         completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    }
    completionHandler();
     // 系统要求执行这个方法
}

//统一处理通知
-(void)didReceiveJPushNotification:(NSDictionary *)notiDict{
    //在这里统一处理接收通知的处理，notiDict为接收到的所有数据
    self.isShoPush = false;
    if([[notiDict allKeys] containsObject:@"locationX"]){
        NSString * workid = notiDict[@"id"];
        NSString * locationX = notiDict[@"locationX"];
        NSString * locationy = notiDict[@"locationY"];
        self.Rutil = [[RangeUtil alloc] init];
        self.Rutil.servicelocaitony = locationy;
        self.Rutil.servicelocaitonx = locationX;
        [self.Rutil locAction];
    }
}

//自定义消息事件
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    if([content isEqualToString:@"message"]){//有新的抢单通知
        
    }else if([content isEqualToString:@"login_channel_change"]){//当前账号被其他人登录
         [[NSNotificationCenter defaultCenter] postNotificationName:@"logoffuser" object:nil userInfo:nil];
    }
}

//判断距离
- (void)judegeRange:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"range"];
    if([content isEqualToString:@"1"]){
        self.isShoPush= false;
    }else if([content isEqualToString:@"2"]){
        self.isShoPush= true;
    }else{
        self.isShoPush= false;
    }
    dispatch_semaphore_signal(appDelegate.sema);
    appDelegate.sema = nil;
    //dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
}

#pragma mark - 检查更新
-(void)getTheCurrentVersion{
    //获取版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
    [[AktLoginCmd sharedTool] requestAppVersionParameters:@{@"appKind":@"1",@"appType":@"2"} type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = [responseObject objectForKey:ResponseData];
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            // 最新版本号
            NSString *iTunesVersion = dic[@"versions"];
            // 应用程序介绍网址(用户升级跳转URL)
            trackViewUrl = [NSString stringWithFormat:@"%@",dic[@"downloadUrl"]];
            
            if ([AktUtil serviceOldCode:iTunesVersion serviceNewCode:versionValueStringForSystemNow]) {
                NSLog(@"不是最新版本,需要更新");
                // 第一次更新
               [[NSUserDefaults standardUserDefaults] setObject:@"isUpadateVersion" forKey:@"isUpadateVersion"];
               [[NSUserDefaults standardUserDefaults] synchronize];
                AktResetAppView *resetView=[[AktResetAppView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_HEIGHT)];
                 resetView.tag = 102;
                 resetView.delegate = self;
                resetView.strContent = dic[@"updateContent"];
                [[UIApplication sharedApplication].keyWindow addSubview:resetView];
            } else {
                NSLog(@"已是最新版本,不需要更新!");
            }
        }
    } failure:^(NSError *error) {
    }];
}

-(void)didNoResetAppClose:(NSInteger)type{
     [[[UIApplication sharedApplication].keyWindow  viewWithTag:102] removeFromSuperview];
    if (type ==0) {
    }else{
        // 内容包含中文，需要转码之后才能跳转  否则无法跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[trackViewUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] options:@{} completionHandler:nil];
    }
}
#pragma mark - notice
- (void)changeRootViewController:(NSNotification*)notiInfo
{
    [self showLoginPage];
}
#pragma mark -
- (void)setTabBarAndNavigationBarStyle{
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColor(@"T2"), NSForegroundColorAttributeName,  nil] forState:UIControlStateNormal]; //tab 正常字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColor(@"T1"), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected]; //tab 选中字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColor(@"N1"),NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFang SC" size:17], NSFontAttributeName, nil]];// nav 标题的 颜色 字号
    [[UINavigationBar appearance] setTranslucent:NO]; // 是否透明
}

- (UITabBarController *)getRootTabVBarAction{
    NSArray *ary = @[@{@"name":@"DownOrdersController",@"itmeName":@"下单",@"nicom":@"downorders_item",@"sicom":@"select-downorders_item"},
                     @{@"name":@"UnfinishOrderTaskController",@"itmeName":@"任务",@"nicom":@"unfinish_item",@"sicom":@"select_unfinish_item"},
                     @{@"name":@"PlanTaskController",@"itmeName":@"计划",@"nicom":@"task_item",@"sicom":@"select-task_item"},
                     @{@"name":@"MineController",@"itmeName":@"我的",@"nicom":@"mine_item",@"sicom":@"select_mine_item"}
    ];
    NSMutableArray *navs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [ary count]; i++)
        [navs addObject:[self getViewControllerWithNav:ary[i]]];
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = navs;
//    UIView *tabBackgroundView = [[UIView alloc] init];
//    [tabBackgroundView setBackgroundColor:kColor(@"C3")];
//    [tabbar.tabBar insertSubview:tabBackgroundView atIndex:0];
    tabbar.selectedIndex = 1;
    //默认显示的item
    return tabbar;
}

- (UINavigationController *)getViewControllerWithNav:(NSDictionary *)dict{
    BaseControllerViewController *vc = [BaseControllerViewController createViewControllerWithName:dict[@"name"] createArgs:nil];
    UINavigationController *vcNav = [[UINavigationController alloc] initWithRootViewController:vc];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:dict[@"itmeName"] image:[UIImage imageNamedWithoutSelected:dict[@"nicom"]] selectedImage:[UIImage imageNamedWithoutSelected:dict[@"sicom"]]];
    vc.tabBarItem = item;
    return vcNav;
}

#pragma mark - get current viewcontroller
+ (UIViewController *)getCurrentVC{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [AppDelegate getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) rootVC = [rootVC presentedViewController]; // 视图是被presented出来的
    if ([rootVC isKindOfClass:[UITabBarController class]]) currentVC = [AppDelegate getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];// 根视图为UITabBarController
    else if ([rootVC isKindOfClass:[UINavigationController class]]) currentVC = [AppDelegate getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    else currentVC = rootVC;// 根视图为非导航类
    return currentVC;
}
#pragma mark - loading and message hud
- (void)showLoadingHUD:(UIView *)vi msg:(NSString *)msg{
    HUD = [MBProgressHUD showHUDAddedTo:(vi == nil ? self.window : vi) animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    if (msg && msg.length > 0) HUD.label.text = msg;
    [HUD showAnimated:YES];
}

- (void)showTextOnly:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hidHUD{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self->HUD hideAnimated:YES];
    }];
}

#pragma mark - hud delegate
- (void)hudWasHidden:(MBProgressHUD *)_hud {
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)showAlertView:(NSString *)title des:(NSString *)des cancel:(NSString *)cl action:(NSString *)ac acHandle:(void (^)(UIAlertAction *action))handler{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:des preferredStyle:UIAlertControllerStyleAlert];
    if (handler) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:(ac==nil?@"确定":ac) style:UIAlertActionStyleDefault handler:handler];
        [actionSheet addAction:action];
    }
    if ([cl isEqualToString:@"取消"] || cl == nil) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:(cl==nil?@"取消":cl) style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cancel];
    }
   
    [[AppDelegate getCurrentVC] presentViewController:actionSheet animated:YES completion:nil];
}
@end
