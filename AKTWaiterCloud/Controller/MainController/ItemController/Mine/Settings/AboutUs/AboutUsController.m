//
//  AboutUsController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "AboutUsController.h"
#import "AktAgreementVC.h"

@interface AboutUsController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.s
    self.view.backgroundColor = [UIColor whiteColor];
    self.topConstraint.constant = AktNavAndStatusHight+27.5;
    [self setNavTitle:@"关于我们"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
}
#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreementClick:(UIButton *)sender {
    AktAgreementVC *signvc = [[AktAgreementVC alloc] init];
    [self.navigationController pushViewController:signvc animated:YES];
}
#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
