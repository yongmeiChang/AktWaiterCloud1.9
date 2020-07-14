//
//  SignInVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/16.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "SignInVC.h"
#import "AktWSigninListVC.h"
#import "AktAgreementVC.h"
#import "ZHAttributeTextView.h" // 

@interface SignInVC ()
{
    BOOL isAgreement; //
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

@property (weak, nonatomic) IBOutlet UIView *viewBgAgreement;

@property (nonatomic, assign) int second; // 倒计时
@property (nonatomic, strong) NSTimer *coldTimer; // 定时器
@property(nonatomic,copy) SigninDetailsInfo * selectZuhuDetailsInfo; // 选择的租户详情

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    self.btnCode.layer.masksToBounds = YES;
    self.btnCode.layer.cornerRadius = 5;
    UITapGestureRecognizer *tapZuhu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkZuhuList:)];
    [_checkZuhu addGestureRecognizer:tapZuhu];
    // 隐私
    isAgreement = YES;
    [self initAgreementView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectZuhuInfoDetails:) name:@"selectZuhu" object:nil];
}
#pragma mark - notice
-(void)selectZuhuInfoDetails:(NSNotification *)info{
    if (info) {
        _selectZuhuDetailsInfo = [info object];
        self.tfzuhu.text = kString(_selectZuhuDetailsInfo.name);
       }
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
    if (kString(self.tfPhone.text).length == 0) {
          [[AppDelegate sharedDelegate] showTextOnly:@"请填写手机号！"];
          return;
      }
    //原始数据  手机号前三位+手机号后四位+&毫秒
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
      if (!self.tfSurePwd || ![self.tfPwd.text isEqualToString:self.tfSurePwd.text]) {
            [[AppDelegate sharedDelegate] showTextOnly:@"两次密码不一致"];
            return;
        }
    if (kString(self.tfzuhu.text).length == 0) {
            [[AppDelegate sharedDelegate] showTextOnly:@"请选择租户！！"];
            return;
        }
    
    if (isAgreement) {
          [self requestSigninInfo];
      }else{
          [[AppDelegate sharedDelegate] showTextOnly:@"请同意用户协议"];
      }
}
-(void)requestSigninInfo{ // orgId
    NSDictionary *param =@{@"mobile":kString(self.tfPhone.text),@"tenantsId":self.selectZuhuDetailsInfo.tenantId,@"name":kString(self.tfUserName.text),@"identifyNo":kString(self.tfID.text),@"password":kString(self.tfSurePwd.text),@"checkCode":self.TFcode.text,@"orgId":self.selectZuhuDetailsInfo.orgId};
    [[AktLoginCmd sharedTool] requestRegisterParameters:param type:HttpRequestTypePost success:^(id responseObject) {
        
        if ([[responseObject objectForKey:ResponseCode] isEqualToString:@"1"]) {
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@ 请耐心等待审核，审核成功之后将会以短信的形式通知您！",[responseObject objectForKey:@"message"]]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
        
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
}
#pragma mark - tap
-(void)checkZuhuList:(UITapGestureRecognizer *)tap{ // 选择租户
    AktWSigninListVC *listvc = [[AktWSigninListVC alloc] init];
    listvc.selectZuhuInfo = self.selectZuhuDetailsInfo;
    [self.navigationController pushViewController:listvc animated:YES];
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
     [self.view addSubview:myTextView];
     [myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_equalTo(self.viewBgAgreement.mas_width);
         make.height.mas_equalTo(35);
         make.centerX.mas_equalTo(self.viewBgAgreement.mas_centerX);
         make.centerY.mas_equalTo(self.viewBgAgreement.mas_centerY);
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
