//
//  FindPswController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/9.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "FindPswController.h"

@interface FindPswController ()<UITextFieldDelegate>{

}
@property (weak,nonatomic) IBOutlet UITextField * mobleField;
@property (weak,nonatomic) IBOutlet UITextField * waiterField;

@property (weak,nonatomic) IBOutlet UIButton * rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavConsraint;

@end

@implementation FindPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mobleField.keyboardType = UIKeyboardTypeNumberPad;
    self.waiterField.keyboardType = UIKeyboardTypeNumberPad;

    [self setNavTitle:@"忘记密码"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
}
#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickRightBtn:(id)sender{
    if(![AktUtil isMobileNumber:self.mobleField.text]){
        [self showMessageAlertWithController:self Message:@"手机格式不符合"];
        return;
    }
    if([self.waiterField.text isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"唯一码不能为空"];
        return;
    }
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    NSDictionary * dic = @{@"mobile":self.mobleField.text,@"waiterUkey":self.waiterField.text};
    [[AktVipCmd sharedTool] requestWithForgetPasswordParameters:dic type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue] == 1){
            self.waiterField.text = @"";
            self.mobleField.text = @"";
        }
        [self showMessageAlertWithController:self Message:[dic objectForKey:ResponseMsg]];
        
    } failure:^(NSError *error) {
        [self showMessageAlertWithController:self Message:error.domain];
    }];
    [[AppDelegate sharedDelegate] hidHUD];
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

@end
