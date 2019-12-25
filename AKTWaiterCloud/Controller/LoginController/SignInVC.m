//
//  SignInVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/16.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "SignInVC.h"
#import ""

@interface SignInVC ()
{
   
}
@property (weak, nonatomic) IBOutlet UIView *checkZuhu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavH;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfID;
@property (weak, nonatomic) IBOutlet UITextField *TFcode;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfSurePwd;
@property (weak, nonatomic) IBOutlet UITextField *tfzuhu;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (nonatomic, assign) int second; // 倒计时
@property (nonatomic, strong) NSTimer *coldTimer; // 定时器
@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    self.topNavH.constant = AktNavAndStatusHight;
    self.btnCode.layer.masksToBounds = YES;
    self.btnCode.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tapZuhu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkZuhuList:)];
    [_checkZuhu addGestureRecognizer:tapZuhu];
}

#pragma mark - timer
- (void)doTimer{
    self.second --;
    if (self.second == 0) {
        [self.btnCode setTitleColor:kColor(@"C3") forState:UIControlStateNormal];
        [self.btnCode setBackgroundColor:kColor(@"C8")];
        [self.coldTimer invalidate];
        self.coldTimer = nil;
        
        [self.btnCode setEnabled:YES];
        [self.btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    }else{
        [self.btnCode setTitle:[NSString stringWithFormat:@"%d",self.second] forState:UIControlStateNormal];
    }
}
#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeClick:(UIButton *)sender {
    NSDictionary *param =@{@"mobile":kString(self.tfPhone.text),@"tenantsId":@"fe75fd1473264e43be4a8a32eba98537"};
    NSString * url = @"appService/getCheckCode";
    [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:param type:HttpRequestTypePost success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            self.second = 60;
            [self.btnCode setTitle:@"60秒后重发" forState:UIControlStateNormal];
            [self.btnCode setTitleColor:kColor(@"C3") forState:UIControlStateNormal];
            [self.btnCode setBackgroundColor:kColor(@"C5")];
            
            [self.btnCode setEnabled:NO];
            self.coldTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:YES];
        }
        
        [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
    
}

- (IBAction)getShowPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.tfPwd.text;
        self.tfPwd.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.tfPwd.secureTextEntry = NO;
        self.tfPwd.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.tfPwd.text;
        self.tfPwd.text = @"";
        self.tfPwd.secureTextEntry = YES;
        self.tfPwd.text = tempPwdStr;
    }
}
- (IBAction)getNewShowPwd:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.tfSurePwd.text;
        self.tfSurePwd.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.tfSurePwd.secureTextEntry = NO;
        self.tfSurePwd.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.tfSurePwd.text;
        self.tfSurePwd.text = @"";
        self.tfSurePwd.secureTextEntry = YES;
        self.tfSurePwd.text = tempPwdStr;
    }
}
- (IBAction)setSignIn:(UIButton *)sender { // 注册
    if (kString(self.tfUserName.text).length == 0) {
        [[AppDelegate sharedDelegate] showTextOnly:@"请填写姓名！"];
        return;
    }
    if (kString(self.tfPhone.text).length == 0) {
          [[AppDelegate sharedDelegate] showTextOnly:@"请填写手机号！"];
          return;
      }
    if (kString(self.tfID.text).length == 0) {
          [[AppDelegate sharedDelegate] showTextOnly:@"请填写身份证！"];
          return;
      }
    if (kString(self.TFcode.text).length == 0) {
          [[AppDelegate sharedDelegate] showTextOnly:@"请填写验证码！"];
          return;
      }
    if (kString(self.tfSurePwd.text).length == 0 || kString(self.tfPwd.text).length == 0) {
          [[AppDelegate sharedDelegate] showTextOnly:@"请填写密码！"];
          return;
      }
    if ([kString(self.tfSurePwd.text) isEqualToString:@"self.tfPwd.text"] ) {
             [[AppDelegate sharedDelegate] showTextOnly:@"两次密码不一致"];
             return;
         }
    if (kString(self.tfzuhu.text).length == 0) {
            [[AppDelegate sharedDelegate] showTextOnly:@"请选择租户！！"];
            return;
        }
    
    NSDictionary *param =@{@"mobile":kString(self.tfPhone.text),@"tenantsId":@"fe75fd1473264e43be4a8a32eba98537",@"name":kString(self.tfUserName.text),@"identifyNo":kString(self.tfID.text),@"password":kString(self.tfSurePwd.text),@"checkCode":self.TFcode.text};
       NSString * url = @"appService/waiterRegister";
       [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:param type:HttpRequestTypePost success:^(id responseObject) {
           [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
       } failure:^(NSError *error) {
           [[AppDelegate sharedDelegate] showTextOnly:error.domain];
       }];
    
    
}

#pragma mark - tap
-(void)checkZuhuList:(UITapGestureRecognizer *)tap{ // 选择租户
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
