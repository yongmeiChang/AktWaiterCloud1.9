//
//  FindPswController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/9.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "FindPswController.h"
#import "LoginViewController.h"
#import "Vaildate.h"
@interface FindPswController ()<UITextFieldDelegate>{

}
@property (weak,nonatomic) IBOutlet UITextField * mobleField;
@property (weak,nonatomic) IBOutlet UITextField * waiterField;

@property (weak,nonatomic) IBOutlet UIButton * rightBtn;
@property (nonatomic,strong) LoginViewController * loginController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavConsraint;

@end

@implementation FindPswController

-(id)initWithFindPswController:(LoginViewController *)logincontoller{
    if (self = [super init]) {
        self.loginController = logincontoller;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topNavConsraint.constant = AktNavAndStatusHight;
    self.mobleField.keyboardType = UIKeyboardTypeNumberPad;
    self.waiterField.keyboardType = UIKeyboardTypeNumberPad;
    self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(-3, -(self.rightBtn.frame.size.width+6), 0, 0);

    [self setNavTitle:@"忘记密码"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
}
#pragma mark - click
-(void)LeftBarClick{
    [self.loginController.navigationController setNavigationBarHidden:YES animated:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickRightBtn:(id)sender{
    if(![Vaildate isMobileNumber:self.mobleField.text]){
        [self showMessageAlertWithController:self Message:@"手机格式不符合"];
        return;
    }
    if([self.waiterField.text isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"唯一码不能为空"];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"发送中..."];
    NSDictionary * dic = @{@"mobile":self.mobleField.text,@"waiterUkey":self.waiterField.text};
    [[AFNetWorkingRequest sharedTool] requestWithForgetPasswordParameters:dic type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue] == 1){
            self.waiterField.text = @"";
            self.mobleField.text = @"";
            [SVProgressHUD showWithStatus:@"发送成功!"];
        }else{
            [self showMessageAlertWithController:self Message:@"发送失败，请重新发送"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showMessageAlertWithController:self Message:@"发送失败，请重新发送"];
    }];
}

#pragma mark TextFieldDelgate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        [SVProgressHUD showErrorWithStatus:@"不支持表情符号"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
