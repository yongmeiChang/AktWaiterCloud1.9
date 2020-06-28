//
//  LoginViewController.m
//  SunjbDemo1
//
//  Created by 孙嘉斌 on 2017/9/29.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//
#import <JPUSHService.h>
#import "LoginViewController.h"
#import "FindPswController.h"
#import "QRCodeViewController.h"
#import "SignInVC.h" // 注册
#import "AktAgreementVC.h"
#import "ZHAttributeTextView.h" //

@interface LoginViewController ()<UITextFieldDelegate>{
    NSString * testUserName ;
    NSString * testPassWord ;
    BOOL isAgreement;
}
@property (weak, nonatomic) IBOutlet UIView *userviewBg;
@property (weak, nonatomic) IBOutlet UIView *pwdViewbg;

@property(weak,nonatomic) IBOutlet UIButton * loginBtn;
@property(weak,nonatomic) IBOutlet UIButton * findPswBtn;
@property(weak,nonatomic) IBOutlet UITextField * unameText;
@property(weak,nonatomic) IBOutlet UITextField * upswText;
@property(weak,nonatomic) IBOutlet UIButton * qrBtn;
// 页面控件需要做适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LabTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameViewTop;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSubname;

@property (weak, nonatomic) IBOutlet UIView *viewBgAgreement;

@property(nonatomic,strong) NSString * registerid;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"C13");
    [self setConstraint];
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
    // 隐私
    isAgreement = YES;
      [self initAgreementView];
    // 获取缓存
    if([UserInfo getsUser]){
        self.unameText.text = [UserInfo getsUser].waiterUkey;
        self.upswText.text = [UserInfo getsUser].password;
    }
    self.cqCodeUserName = @"";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![self.cqCodeUserName isEqualToString:@""]){
        self.unameText.text = self.cqCodeUserName;
    }
}
#pragma mark - 隐私
-(void)initAgreementView{
     ZHAttributeTextView *myTextView = [[ZHAttributeTextView alloc]initWithFrame:CGRectMake(0, 0, self.viewBgAgreement.bounds.size.width - 20, 35)];
     myTextView.numClickEvent = 1;                        // 有几个点击事件(这里只能设为1个或2个)
     myTextView.oneClickLeftBeginNum = 5;                 // 第一个点击的起始坐标数字是几
     myTextView.oneTitleLength = 6;                      // 第一个点击的文本长度是几
     myTextView.fontSize = 13;                            // 可点击的字体大小
     myTextView.titleTapColor = kColor(@"C8");    // 可点击富文本字体颜色
     // 设置了上面后要在最后设置内容
     myTextView.content = @"阅读并同意《隐私政策》";
     myTextView.agreeBtnClick = ^(UIButton *btn) {
          btn.selected = !btn.selected;
         if(btn.selected == YES){
             NSLog(@"左侧按钮选中状态为YES");
             isAgreement = YES;
         }else{
             NSLog(@"左侧按钮选中状态为NO");
             isAgreement = NO;
         }
     };
     myTextView.eventblock = ^(NSAttributedString *contentStr) {
         AktAgreementVC *Agreementvc = [[AktAgreementVC alloc] init];
         [self.navigationController pushViewController:Agreementvc animated:YES];
     };
     [self.viewBgAgreement addSubview:myTextView];
     [myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_equalTo(self.viewBgAgreement.mas_width);
         make.height.mas_equalTo(35);
         make.centerX.mas_equalTo(self.viewBgAgreement.mas_centerX);
         make.centerY.mas_equalTo(self.viewBgAgreement.mas_centerY);
     }];
}
#pragma mark - 适配
-(void)setConstraint{
    if (SCREEN_WIDTH>375) {
        self.LabTop.constant = 70;
        self.labTitle.font = [UIFont systemFontOfSize:25];
        self.labSubname.font = [UIFont systemFontOfSize:18];
        self.userNameViewTop.constant = 35;
    }else{
        self.LabTop.constant = 60;
        self.labTitle.font = [UIFont systemFontOfSize:22];
              self.labSubname.font = [UIFont systemFontOfSize:16];
        self.userNameViewTop.constant = 25;
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
//扫码登录
-(IBAction)qrCodeBtnClick:(id)sender{
    QRCodeViewController * qrcodeController = [[QRCodeViewController alloc]initWithQRCode:self Type:@"logincontoller"];
    [self.navigationController pushViewController:qrcodeController animated:nil];
}
/**登陆按钮*/
-(IBAction)loginBtnClick:(id)sender{
    NSString * netWorkType = [ReachbilityTool internetStatus];
    if([netWorkType isEqualToString:@"notReachable"]){
        [self showMessageAlertWithController:self Message:NetWorkMessage];
    }
    if (isAgreement) {
        [self Userlogin];
    }else{
        [[AppDelegate sharedDelegate] showTextOnly:@"请同意用户协议"];
    }
}
/**忘记密码按钮*/
-(IBAction)findPswBtn:(id)sender{
    FindPswController * findPswController = [[FindPswController alloc]init];
    [self.navigationController pushViewController:findPswController animated:YES];
}
// 注册
- (IBAction)sigInClickBtn:(UIButton *)sender {
    SignInVC *signvc = [[SignInVC alloc] init];
    [self.navigationController pushViewController:signvc animated:YES];
}
#pragma mark - user Info
-(void)reauestUserInfoTenantsid:(NSString *)tenantsId UserId:(NSString *)userid{
    NSDictionary *parma = @{@"tenantsId":kString(tenantsId),@"id":kString(userid)};
    [[[AktVipCmd alloc] init] requestUserInfo:parma type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"object"];
        
        UserInfo * user = [[UserInfo alloc] initWithDictionary:dic error:nil];
        user.uuid = user.id;
        [user saveUser];
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
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
        NSLog(@"registrationID获取：%@",registrationID);
        if(resCode == 0){
            appDelegate.Registration_ID = registrationID;
        }
        NSDictionary * dic =@{@"waiterUkey":self.unameText.text,@"password":self.upswText.text,@"registrationId":appDelegate.Registration_ID,@"channel":@"2"};
        [[AktLoginCmd sharedTool] requestLoginParameters:dic type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary * result = responseObject;
           // 目前后台没有存储开启离线模式字段 手动添加默认关闭
            NSNumber * code = [result objectForKey:@"code"];
            NSString * messageDic = [responseObject objectForKey:@"message"];
            if([code intValue] == 1){
                NSDictionary * userdic = [result objectForKey:@"object"];
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userdic];
                LoginModel *model = [[LoginModel alloc] initWithDictionary:dic error:nil];
                model.uuid = model.id;
                [model save];
                [self reauestUserInfoTenantsid:kString(model.tenantsId) UserId:kString(model.uuid)]; // 获取个人信息
                // 登录成功
                [[NSUserDefaults standardUserDefaults] setObject:model.uuid forKey:@"AKTserviceToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:ChangeRootViewController object:nil];
                
                //获取各类工单数量
                NSDictionary * params = @{@"waiterId":model.uuid,@"tenantsId":model.tenantsId};
                [[AktVipCmd sharedTool] requestfindToBeHandleCount:params type:HttpRequestTypePost success:^(id responseObject) {} failure:^(NSError *error) {}];
            }else{
                [self showMessageAlertWithController:self Message:messageDic];
            }
             [[AppDelegate sharedDelegate] hidHUD];
        } failure:^(NSError *error) {
             [[AppDelegate sharedDelegate] hidHUD];
            [self showMessageAlertWithController:self Message:error.domain];
        }];
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

@end
