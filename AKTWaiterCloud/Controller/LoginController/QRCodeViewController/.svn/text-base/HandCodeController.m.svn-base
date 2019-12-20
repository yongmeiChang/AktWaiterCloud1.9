//
//  HandCodeController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/7.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "HandCodeController.h"
#import "QRCodeService.h"
#import "QRCodeViewController.h"

#import "LoginViewController.h"
@interface HandCodeController ()
@property(nonatomic,weak) IBOutlet UILabel * titleLabel;
@property(nonatomic,weak) IBOutlet UIButton * submitBtn;
@property(nonatomic,weak) IBOutlet UITextField * textfield;
@end

@implementation HandCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B1");
   [self setNavTitle:@"手动输入"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
}

-(void)viewDidLayoutSubviews{
    self.netWorkErrorView.hidden = YES;
    CGRect cg = self.textfield.frame;
    cg.size.height = 50;
    self.textfield.frame = cg;
    
}
#pragma mark - back click
-(void)LeftBarClick{
    if(![self.type isEqualToString:@"logincontoller"]){

        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for(UIViewController * vc in self.navigationController.viewControllers){
            if([vc isKindOfClass: [LoginViewController class]]){
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}

#pragma mark - click
-(IBAction)clickSubmit:(id)sender{
    if([self.type isEqualToString:@"logincontoller"]){
        if(!_textfield.text||[_textfield.text isEqualToString:@""]){
            [self showMessageAlertWithController:self Message:@"服务唯一码不能为空"];
            return;
        }
        [self backClick:nil];
    }else{
        if(!_textfield.text||[_textfield.text isEqualToString:@""]){
            [self showMessageAlertWithController:self Message:@"用户唯一码不能为空"];
            return;
        }
        self.tabBarController.tabBar.hidden = YES;
        QRCodeService * qrservice = [[QRCodeService alloc] init];
        qrservice.type=2;
        [qrservice QRorderRequest:self Code:_textfield.text];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if([self.type isEqualToString:@"logincontoller"]){
        self.titleLabel.text = @"输入服务人员唯一码";
    }
}
@end
