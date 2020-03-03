//
//  AktAgreementVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/2/24.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktAgreementVC.h"
#import "LoginViewController.h"

@interface AktAgreementVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webBaseView;

@property (nonatomic,strong) LoginViewController * loginController;

@end

@implementation AktAgreementVC
-(id)initWithSigninWController:(LoginViewController *)logincontoller{
    if (self = [super init]) {
        self.loginController = logincontoller;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kColor(@"C3");
    self.title = @"隐私政策";
    [self initWithNavLeftImageName:@"close_range" RightImageName:@""];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webBaseView.scrollView.bounces = NO;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"AktAgreement" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webBaseView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}
#pragma mark - click
-(void)LeftBarClick{
    [self.loginController.navigationController setNavigationBarHidden:YES animated:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
