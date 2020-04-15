//
//  AKTChangePhoneVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/4/7.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AKTChangePhoneVC.h"

@interface AKTChangePhoneVC ()
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
#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getPhoneCodeClick:(id)sender {
     NSDictionary *param =@{@"mobile":kString(self.tfPhone.text),@"tenantsId":@"fe75fd1473264e43be4a8a32eba98537"};
    [[AktLoginCmd sharedTool] requestCheckCodeParameters:param type:HttpRequestTypePost success:^(id responseObject) {
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
- (IBAction)PostSureNewPhoneClick:(UIButton *)sender {
    if (self.tfPhone.text.length<11) {
        [[AppDelegate sharedDelegate] showTextOnly:@"请填写正确的手机号！"];
        return;
    }
    if (self.tfCode.text.length<3) {
        [[AppDelegate sharedDelegate] showTextOnly:@"请填写验证码"];
        return;
    }
    NSDictionary *parma = @{@"tenantsId":kString([LoginModel gets].tenantsId),@"mobile":kString(self.tfPhone.text),@"checkCode":self.tfCode.text};
    [[[AktVipCmd alloc] init] requestChangePhone:parma type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]]];
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
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
