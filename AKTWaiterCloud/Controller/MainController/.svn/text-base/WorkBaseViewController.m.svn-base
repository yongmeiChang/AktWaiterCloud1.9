//
//  WorkBaseViewController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/27.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "WorkBaseViewController.h"

@interface WorkBaseViewController ()
//没有网络的视图

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@end

@implementation WorkBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self initsNoDataView]];
    
    //下拉、上拉动画图片
    self.imageArrs = [NSArray array];
    NSMutableArray * arr = [NSMutableArray array];
    for(int i=1; i<=32;i++){
        NSString * imagename = [NSString stringWithFormat:@"loading%d.png",i];
        UIImage * image = [UIImage imageNamed:imagename];
        [arr addObject:image];
    }
    self.imageArrs = [NSArray arrayWithArray:arr];
}
//初始化网络错误页面
-(UIView *)initsNoDataView{
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
    self.netWorkErrorView = [[UIView alloc]initWithFrame:CGRectMake(0, appStatusBarFrame.size.height+44, SCREEN_WIDTH, SCREEN_HEIGHT-tabBarHeight)];
    [self.netWorkErrorView setBackgroundColor:[UIColor colorWithRed:226/255.0 green:232/255.0 blue:239/255.0 alpha:1]];
    
    self.netWorkErrorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nohave.png"]];
    [self.netWorkErrorView addSubview:self.netWorkErrorImageView];
    [ self.netWorkErrorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.netWorkErrorView).offset(-self.netWorkErrorImageView.frame.size.height/2-30);
        make.centerX.equalTo(self.netWorkErrorView);
    }];
    
    self.netWorkErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.netWorkErrorLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:103/255.0 alpha:1]];
    self.netWorkErrorLabel.textAlignment = NSTextAlignmentCenter;
    self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
    self.netWorkErrorLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.netWorkErrorView addSubview:self.netWorkErrorLabel];
    [self.netWorkErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.netWorkErrorImageView.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.equalTo(self.netWorkErrorView);
    }];
    
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.netWorkErrorView addGestureRecognizer:tapGesture];
    self.netWorkErrorView.userInteractionEnabled = YES;
    
    self.constraintTop.constant=appStatusBarFrame.size.height+44.0f;
    
    return self.netWorkErrorView;
}

-(void)labelClick{
    
}
@end
