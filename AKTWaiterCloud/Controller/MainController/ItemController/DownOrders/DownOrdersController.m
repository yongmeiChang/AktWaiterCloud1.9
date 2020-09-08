//
//  DownOrdersController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/9.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "DownOrdersController.h"
#import "QRCodeViewController.h"
#import "HandCodeController.h"

@interface DownOrdersController ()
@property (weak,nonatomic) IBOutlet UIButton * QRCodeBtn;
@property (weak,nonatomic) IBOutlet UIButton * HandCodeBtn;
@end

@implementation DownOrdersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B1");
    [self.netWorkErrorView setHidden:YES];
    [self initview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)initview{
    self.netWorkErrorView.hidden = YES;
    self.navigationItem.title = @"下单";
    [self.QRCodeBtn addTarget:self action:@selector(QRCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.HandCodeBtn addTarget:self action:@selector(pushHandView) forControlEvents:UIControlEventTouchUpInside];
    self.HandCodeBtn.layer.masksToBounds = YES;
    self.HandCodeBtn.layer.cornerRadius = self.HandCodeBtn.frame.size.height/2;

}

#pragma mark - click
-(void)QRCodeBtnClick{
    DDLogInfo(@"点击了扫码功能");
    QRCodeViewController * qrcodeController = [[QRCodeViewController alloc]initWithQRCode:self Type:@"DownOrdersController"];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:qrcodeController animated:nil];
}

- (void)pushHandView{
    HandCodeController * hcController = [[HandCodeController alloc] init];
    hcController.type = @"1";
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:hcController animated:YES];
}
#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
