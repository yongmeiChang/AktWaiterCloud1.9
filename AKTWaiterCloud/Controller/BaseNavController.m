//
//  BaseNavController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/10.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES; // 手势有效设置为YES  无效为NO

        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault; // 状态栏黑色
    self.navigationBar.barTintColor = RGB(250, 249, 251); // 导航栏 背景颜色
    //导航栏字体大小、颜色
       [self.navigationController.navigationBar setTitleTextAttributes:
        @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:RGB(34, 34, 34)}];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
}
- (void)return
{
    // 最低控制器无需返回
    if (self.viewControllers.count <= 1) return;
    
    // pop返回上一级
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
