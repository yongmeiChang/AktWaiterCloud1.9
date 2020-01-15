//
//  LoginViewController.m
//  SunjbDemo1
//
//  Created by 孙嘉斌 on 2017/9/29.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//
#import <JPUSHService.h>
#import "LoginViewController.h"
#import "MainController.h"
#import "FindPswController.h"
#import "QRCodeViewController.h"
#import "SignInVC.h" // 注册
#import "UserFmdb.h"
#import "AktResetAppView.h" // 更新提示view

@interface LoginViewController ()<UITextFieldDelegate,AktResetAppDelegate>{
    NSString * testUserName ;
    NSString * testPassWord ;
    NSString *trackViewUrl; // appst网址
    AktResetAppView *resetView;
}
@property (weak, nonatomic) IBOutlet UIView *userviewBg;
@property (weak, nonatomic) IBOutlet UIView *pwdViewbg;

@property(weak,nonatomic) IBOutlet UIButton * loginBtn;
@property(weak,nonatomic) IBOutlet UIButton * findPswBtn;
@property(weak,nonatomic) IBOutlet UITextField * unameText;
@property(weak,nonatomic) IBOutlet UITextField * upswText;
@property(weak,nonatomic) IBOutlet UIButton * qrBtn;

@property(nonatomic,strong) NSString * registerid;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"C13");
    self.unameText.delegate = self;
    self.upswText.delegate = self;
    // 样式
    self.userviewBg.layer.masksToBounds = YES;
    self.userviewBg.layer.borderColor = RGB(210, 210, 210).CGColor;
    self.userviewBg.layer.borderWidth = 1;
    self.userviewBg.layer.cornerRadius = self.userviewBg.frame.size.height/2;
    
    self.pwdViewbg.layer.masksToBounds = YES;
    self.pwdViewbg.layer.borderColor = RGB(210, 210, 210).CGColor;
    self.pwdViewbg.layer.borderWidth = 1;
    self.pwdViewbg.layer.cornerRadius = self.pwdViewbg.frame.size.height/2;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    // 获取缓存
    if(appDelegate.userinfo){
        self.unameText.text = appDelegate.userinfo.waiterUkey;
        self.upswText.text = appDelegate.userinfo.password;
    }
    //检查更新
    [self getTheCurrentVersion];
    self.cqCodeUserName = @"";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启定时器
    if(![self.cqCodeUserName isEqualToString:@""]){
        self.unameText.text = self.cqCodeUserName;
    }
}

#pragma mark - click
- (IBAction)pwdBtn:(UIButton *)sender {
     sender.selected = !sender.selected;
       
       if (sender.selected) { // 按下去了就是明文
           
           NSString *tempPwdStr = self.upswText.text;
           self.upswText.text = @""; // 这句代码可以防止切换的时候光标偏移
           self.upswText.secureTextEntry = NO;
           self.upswText.text = tempPwdStr;
           
       } else { // 暗文
           
           NSString *tempPwdStr = self.upswText.text;
           self.upswText.text = @"";
           self.upswText.secureTextEntry = YES;
           self.upswText.text = tempPwdStr;
       }
}
-(IBAction)qrCodeBtnClick:(id)sender{
    DDLogInfo(@"点击了扫描按钮");
    QRCodeViewController * qrcodeController = [[QRCodeViewController alloc]initWithQRCode:self Type:@"logincontoller"];
    [self.navigationController pushViewController:qrcodeController animated:nil];
}

/**登陆按钮*/
-(IBAction)loginBtnClick:(id)sender{
    DDLogInfo(@"点击了登陆按钮");
    NSString * netWorkType = [ReachbilityTool internetStatus];
    if([netWorkType isEqualToString:@"notReachable"]){
        [self showMessageAlertWithController:self Message:NetWorkMessage];
        appDelegate.netWorkType = On_line;
    }
    [self Userlogin];
}

/**忘记密码按钮*/
-(IBAction)findPswBtn:(id)sender{
    DDLogInfo(@"点击忘记密码按钮");
    FindPswController * findPswController = [[FindPswController alloc]initWithFindPswController:self];
    [self.navigationController pushViewController:findPswController animated:YES];
}
- (IBAction)sigInClickBtn:(UIButton *)sender {
    SignInVC *signvc = [[SignInVC alloc] initWithSigninWController:self];
    [self.navigationController pushViewController:signvc animated:YES];
}

#pragma mark - login
-(void)Userlogin{
    [self.view endEditing:YES];
    
    if(self.unameText.text == nil || self.unameText.text.length == 0){

        [[AppDelegate sharedDelegate] showTextOnly:@"请输账号!"];
        return;
    }
    if(self.unameText.text == nil || self.unameText.text.length < 3){
       
         [[AppDelegate sharedDelegate] showTextOnly:@"账号长度不符合规定!"];
        return;
    }
    if(self.upswText.text == nil || self.upswText.text.length == 0){

         [[AppDelegate sharedDelegate] showTextOnly:@"请输入密码!"];
        return;
    }
    [self RequestLogin];
}

-(void)RequestLogin{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    //返回极光的id
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            appDelegate.Registration_ID = registrationID;

            NSDictionary * dic =@{@"waiterUkey":self.unameText.text,@"password":self.upswText.text,@"registrationId":appDelegate.Registration_ID,@"channel":@"2"};
            NSString * url = @"waiterLogin";
            
            [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:dic type:HttpRequestTypePost success:^(id responseObject) {
                NSDictionary * result = responseObject;
               // 目前后台没有存储开启离线模式字段 手动添加默认关闭
                NSNumber * code = [result objectForKey:@"code"];
                if([code intValue] == 1){
                    NSDictionary * userdic = [result objectForKey:@"object"];
                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userdic];
                    [dic setObject:@"1" forKey:@"isclickOff_line"];
                    UserInfo * user = [[UserInfo alloc] initWithDictionary:dic error:nil];
                    user.uuid = user.id;
                    appDelegate.userinfo = user;
                    appDelegate.mainController = [[MainController alloc]init];
                    UserFmdb * userdb = [[UserFmdb alloc] init];
                    UserInfo * useroldinfo = [[UserInfo alloc] init];
                    useroldinfo = [userdb findByrow:0];
                    if(useroldinfo.uuid){
                        [userdb updateObject:appDelegate.userinfo];
                    }else{
                        [userdb saveUserInfo:appDelegate.userinfo];
                    }
                    appDelegate.mainController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController: appDelegate.mainController  animated:YES completion:nil];
            
                    //获取各类工单数量
                    NSDictionary * params = @{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId};
                    [[AFNetWorkingRequest sharedTool] requestfindToBeHandleCount:params type:HttpRequestTypePost success:^(id responseObject) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    if(appDelegate.userinfo.icon&&![appDelegate.userinfo.icon isEqualToString:@""]&&appDelegate.userinfo.icon != nil){
                        NSURL *imageUrl = [NSURL URLWithString:appDelegate.userinfo.icon];
                        appDelegate.userheadimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                    }
                }else{
                    NSString * messageDic = [responseObject objectForKey:@"message"];
                    [self showMessageAlertWithController:self Message:messageDic];
                }
               
                 [[AppDelegate sharedDelegate] hidHUD];
            } failure:^(NSError *error) {
                 [[AppDelegate sharedDelegate] hidHUD];
                NSLog(@"请求错误，code==%lu",error.code);
                [self showMessageAlertWithController:self Message:@"登录失败，请稍后再试"];
            }];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
            // 测试登陆接口
            NSDictionary * dic =@{@"waiterUkey":self.unameText.text,@"password":self.upswText.text,@"registrationId":appDelegate.Registration_ID,@"channel":@"2"};
            NSString * url = @"waiterLogin";
            
            [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:dic type:HttpRequestTypePost success:^(id responseObject) {
                NSDictionary * result = responseObject;
                // 目前后台没有存储开启离线模式字段 手动添加默认关闭
                NSNumber * code = [result objectForKey:@"code"];
                if([code intValue] == 1){
                    NSDictionary * userdic = [result objectForKey:@"object"];
                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userdic];
                    [dic setObject:@"1" forKey:@"isclickOff_line"];
                    UserInfo * user = [[UserInfo alloc] initWithDictionary:dic error:nil];
                    user.uuid = user.id;
                    appDelegate.userinfo = user;
                    appDelegate.mainController = [[MainController alloc]init];
                    UserFmdb * userdb = [[UserFmdb alloc] init];
                    UserInfo * useroldinfo = [[UserInfo alloc] init];
                    useroldinfo = [userdb findByrow:0];
                    if(useroldinfo.uuid){
                        [userdb updateObject:appDelegate.userinfo];
                    }else{
                        [userdb saveUserInfo:appDelegate.userinfo];
                    }
                   appDelegate.mainController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController: appDelegate.mainController  animated:YES completion:nil];
                    //获取各类工单数量
                    NSDictionary * params = @{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId};
                    [[AFNetWorkingRequest sharedTool] requestfindToBeHandleCount:params type:HttpRequestTypePost success:^(id responseObject) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    if(appDelegate.userinfo.icon&&![appDelegate.userinfo.icon isEqualToString:@""]&&appDelegate.userinfo.icon != nil){
                        NSURL *imageUrl = [NSURL URLWithString:appDelegate.userinfo.icon];
                        appDelegate.userheadimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                    }
                }else{
                    NSString * messageDic = [responseObject objectForKey:@"message"];
                    [self showMessageAlertWithController:self Message:messageDic];
                }
                 [[AppDelegate sharedDelegate] hidHUD];
            } failure:^(NSError *error) {
                 [[AppDelegate sharedDelegate] hidHUD];
                NSLog(@"请求错误，code==%lu",error.code);
                [self showMessageAlertWithController:self Message:@"登陆失败，请稍后再试"];
            }];
        }
    }];
   
}

#pragma mark TextFieldDelgate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        [[AppDelegate sharedDelegate] showTextOnly:@"不支持表情符号"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.unameText isFirstResponder]) {
        [self.upswText becomeFirstResponder];
        return YES;
    }
    if ([self.upswText isFirstResponder]) {
        // 隐藏键盘.
        [textField resignFirstResponder];
        // 触发登陆按钮的点击事件.
        [self.loginBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        return YES;
    }
    return YES;
}

#pragma mark 检查更新
-(void)getTheCurrentVersion{
    //获取版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getAppVersion" parameters:@{@"appKind":@"1",@"appType":@"2"} type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject[@"object"];
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            // 最新版本号
            NSString *iTunesVersion = dic[@"versions"];
            // 应用程序介绍网址(用户升级跳转URL)
            trackViewUrl = [NSString stringWithFormat:@"%@",dic[@"downloadUrl"]];
            
            if ([AktUtil serviceOldCode:iTunesVersion serviceNewCode:versionValueStringForSystemNow]) {
                NSLog(@"不是最新版本,需要更新");
                resetView=[[AktResetAppView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_HEIGHT)];
                 resetView.tag = 102;
                 resetView.delegate = self;
                resetView.strContent = dic[@"updateContent"];
                [[UIApplication sharedApplication].keyWindow addSubview:resetView];
            } else {
                NSLog(@"已是最新版本,不需要更新!");
                if(appDelegate.userinfo){
                    self.unameText.text = appDelegate.userinfo.waiterUkey;
                    self.upswText.text = appDelegate.userinfo.password;
                    if(appDelegate.IsAutoLogin){
                        [self loginBtnClick:nil];
                    }
                    //账号默认关闭离线模式
                    appDelegate.userinfo.isclickOff_line = @"1";
                }
            }
        }
    } failure:^(NSError *error) {
        if(appDelegate.userinfo){
            if(appDelegate.IsAutoLogin){
                [self loginBtnClick:nil];
            }
            //账号默认关闭离线模式
            appDelegate.userinfo.isclickOff_line = @"1";
        }
    }];
}

#pragma mark - delegate
-(void)didNoResetAppClose:(NSInteger)type{
     [[[UIApplication sharedApplication].keyWindow  viewWithTag:102] removeFromSuperview];
    if (type ==0) {
        if(appDelegate.userinfo){
           if(appDelegate.IsAutoLogin){
            [self loginBtnClick:nil];
           }
            //账号默认关闭离线模式
            appDelegate.userinfo.isclickOff_line = @"1";
        }
    }else{
        // 内容包含中文，需要转码之后才能跳转  否则无法跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[trackViewUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]] options:@{} completionHandler:nil];
    }
}

@end
