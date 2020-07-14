//
//  EditPassWordController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "EditPassWordController.h"
#import "SettingsController.h"
#import "LoginViewController.h"
#import "SaveDocumentArray.h"
#import "AktSuccseView.h"

@interface EditPassWordController ()<UITextFieldDelegate,AktSuccseDelegate>
{
    AktSuccseView *succseView;
}
@property (weak,nonatomic) IBOutlet UITextField * oldPswField;
@property (weak,nonatomic) IBOutlet UITextField * nPswField;
@property (weak,nonatomic) IBOutlet UITextField * nPswAgainField;
@property (weak,nonatomic) IBOutlet UIButton * rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldViewTop;

@end

@implementation EditPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B1");
    [self setNavTitle:@"修改密码"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    
    self.oldPswField.delegate = self;
    self.nPswField.delegate = self;
    self.nPswAgainField.delegate = self;
    
    //成功
    succseView=[[AktSuccseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_HEIGHT)];
    succseView.tag = 101;
    succseView.delegate = self;
}

#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)editPswClick:(id)sender{
    DDLogInfo(@"点击了修改密码");
    if(self.oldPswField.text == nil || self.oldPswField.text.length == 0){
        [[AppDelegate sharedDelegate] showTextOnly:@"请输入原始密码!"];
        return;
    }
    if(self.oldPswField.text.length < 6 || self.oldPswField.text.length > 12){
        [[AppDelegate sharedDelegate] showTextOnly:@"原始密码长度不符合要求!"];
        return;
    }
    
    if(self.nPswField.text == nil || self.nPswField.text.length ==0 ){
        [[AppDelegate sharedDelegate] showTextOnly:@"请输入新密码!"];
        return;
    }
    
    if(self.nPswField.text.length < 6 || self.nPswField.text.length > 12 ){
        [[AppDelegate sharedDelegate] showTextOnly:@"新密码长度不符合要求!"];
        return;
    }
    
    if(self.nPswAgainField.text == nil || self.nPswAgainField.text.length == 0){
        [[AppDelegate sharedDelegate] showTextOnly:@"请输入新密码!"];
        return;
    }
    
    if(self.nPswAgainField.text.length < 6 || self.nPswAgainField.text.length > 12){
        [[AppDelegate sharedDelegate] showTextOnly:@"新密码长度不符合要求!"];
        return;
    }
    NSString * oldPsw = self.oldPswField.text;
    NSString * nPsw = self.nPswField.text;
    NSString * nPswAgain = self.nPswAgainField.text;
    if(![nPsw isEqualToString:nPswAgain]){
        [[AppDelegate sharedDelegate] showTextOnly:@"新密码输入不一致!"];
        return;
    }
    
    NSString * netWorkType = [ReachbilityTool internetStatus];
    if([netWorkType isEqualToString:@"notReachable"]){
        [self showMessageAlertWithController:self  Message:NetWorkMessage];
        return;
    }
    
    NSDictionary * param = @{@"waiterId":[LoginModel gets].uuid,@"oldPass":oldPsw,@"newPass":nPsw,@"tenantsId":[LoginModel gets].tenantId};
    
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"操作中"];
    [[AktVipCmd sharedTool] requesteditPassword:param type:HttpRequestTypePut success:^(id responseObject) {
    
        NSDictionary * result = responseObject;
        NSNumber * code = [result objectForKey:@"code"];
        if([code intValue] == 1){
            [[UIApplication sharedApplication].keyWindow addSubview:succseView];
        }else if([code intValue]== 2){
            NSString * message = [result objectForKey:@"message"];
            [self showMessageAlertWithController:self Message:message];
        }

        [[AppDelegate sharedDelegate] hidHUD];
       
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        NSLog(@"请求错误，code==%lu",error.code);
    }];
}

#pragma mark - delegate
-(void)didSelectClose{
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:101] removeFromSuperview];
    
    //注销登录删除用户数据
    [[SaveDocumentArray sharedInstance] removefmdb];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AKTserviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:ChangeRootViewController object:nil];
}

#pragma mark - TextFieldDelgate
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
    if ([self.oldPswField isFirstResponder]) {
        [self.nPswField becomeFirstResponder];
        return YES;
    }
    if ([self.nPswField isFirstResponder]) {
        [self.nPswAgainField becomeFirstResponder];
        return YES;
    }
    if ([self.nPswAgainField isFirstResponder]) {
        // 隐藏键盘.
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}

@end
