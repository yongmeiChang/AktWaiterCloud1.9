//
//  AKTChangePhoneVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/4/7.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AKTChangePhoneVC.h"

@interface AKTChangePhoneVC ()
{
    NSString *encryptStr;
}
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNotice;
@property (weak, nonatomic) IBOutlet UILabel *labNotice;

@property (nonatomic, assign) int second; // 倒计时
@property (nonatomic, strong) NSTimer *coldTimer; // 定时器

@end

@implementation AKTChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kColor(@"C3");
    self.labNotice.text = [NSString stringWithFormat:@"更换手机号后，下次可使用新的手机号登录。当前手机号:%@",self.strPhone];
    self.title = @"更换手机号";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    self.btnCode.layer.masksToBounds = YES;
    self.btnCode.layer.cornerRadius = 5;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topNotice.constant = 30; // 距离顶部高度
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
#pragma mark - request
-(void)postDataToService{
    NSDictionary *parma = @{@"tenantsId":kString([LoginModel gets].tenantId),@"mobile":kString(self.tfPhone.text),@"checkCode":self.tfCode.text};
    [[[AktVipCmd alloc] init] requestChangePhone:parma type:HttpRequestTypePut success:^(id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]]];
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
}
-(void)postDataToServiceCode{
    //原始数据
    NSString *phoneAndDataStr = [NSString stringWithFormat:@"%@%@&%@",[self.tfPhone.text substringToIndex:3],[self.tfPhone.text substringFromIndex:7],[AktUtil getNowTimes]];
    //使用字符串格式的公钥加密
    NSString *encryptStr = [RSAEncryptor encryptString:phoneAndDataStr publicKey:RSA_Public_KEY];
    NSDictionary *param =@{@"mobile":kString(self.tfPhone.text),@"tenantsId":encryptStr};
   [[AktLoginCmd sharedTool] requestCheckCodeParameters:param type:HttpRequestTypeGet success:^(id responseObject) {
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
#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getPhoneCodeClick:(id)sender {
    [self postDataToServiceCode]; // 获取验证码
}
- (IBAction)PostSureNewPhoneClick:(UIButton *)sender {
    
    if (![AktUtil checkTelNumberAndPhone:self.tfPhone.text]) {
        [[AppDelegate sharedDelegate] showTextOnly:@"请填写正确的手机号!"];
        return;
    }
    if (self.tfCode.text.length<3) {
        [[AppDelegate sharedDelegate] showTextOnly:@"请填写验证码"];
        return;
    }
    [self postDataToService];
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
