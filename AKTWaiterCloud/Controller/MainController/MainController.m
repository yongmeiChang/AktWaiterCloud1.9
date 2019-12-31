//
//  MainController.m
//  SunjbDemo1
//
//  Created by 孙嘉斌 on 2017/9/27.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MainController.h"
#import "DownOrdersController.h"
#import "UnfinishOrderTaskController.h"
#import "PlanTaskController.h"
#import "MineController.h"
#import "BaseNavController.h"
#import "QRCodeViewController.h"
@interface MainController ()<UITabBarControllerDelegate>
@property(nonatomic,strong) NSMutableArray<UIViewController *> * viewControllers1;
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    [self initTabBar];
    self.delegate = self;
    NSUserDefaults * ns = [[NSUserDefaults alloc]init];
    [ns removeObjectForKey:@"isAutologin"];
    appDelegate.mainController = self ;
}

- (void)initTabBar{
    self.viewControllers1 = [NSMutableArray arrayWithCapacity:5];
    //下单item
    DownOrdersController * downOrderController = [[DownOrdersController alloc]init];
    BaseNavController * downNav = [[BaseNavController alloc]initWithRootViewController:downOrderController];
    downNav.tabBarItem.image = [UIImage imageNamed:@"downorders_item"];
    downNav.tabBarItem.selectedImage = [UIImage imageNamed:@"select-downorders_item"];
    downNav.tabBarItem.title=@"下单";
    [self.viewControllers1 addObject:downNav];
    
    //待办工单item
    UnfinishOrderTaskController * unfinshedTaskController = [[UnfinishOrderTaskController alloc]init];
    BaseNavController * unfinshNav = [[BaseNavController alloc]initWithRootViewController:unfinshedTaskController];
    unfinshNav.tabBarItem.image = [UIImage imageNamed:@"unfinish_item"];
    unfinshNav.tabBarItem.selectedImage = [UIImage imageNamed:@"select_unfinish_item"];
    unfinshNav.tabBarItem.title=@"任务";
    [self.viewControllers1 addObject:unfinshNav];
    
    //计划任务item
    PlanTaskController * planTaskController = [[PlanTaskController alloc]init];
    BaseNavController * planTaskNav = [[BaseNavController alloc]initWithRootViewController:planTaskController];
    planTaskNav.tabBarItem.image = [UIImage imageNamed:@"task_item"];
    planTaskNav.tabBarItem.selectedImage = [UIImage imageNamed:@"select-task_item"];
    planTaskNav.tabBarItem.title=@"计划";
    [self.viewControllers1 addObject:planTaskNav];
    
    //我的item
    MineController * mineController = [[MineController alloc]init];
    BaseNavController * mineNav = [[BaseNavController alloc]initWithRootViewController:mineController];
    mineNav.tabBarItem.image = [UIImage imageNamed:@"mine_item"];
    mineNav.tabBarItem.selectedImage = [UIImage imageNamed:@"select_mine_item"];
    mineNav.tabBarItem.title=@"我的";
    [self.viewControllers1 addObject:mineNav];
    
    self.viewControllers = [self.viewControllers1 copy];
    //默认显示的item
    self.selectedViewController = unfinshNav;
}

//每次点击下单item 重新创建视图防止扫码页面卡死
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}
@end
