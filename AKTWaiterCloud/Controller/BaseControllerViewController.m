//
//  BaseControllerViewController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/19.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "BaseControllerViewController.h"
#import "SaveDocumentArray.h"

@interface BaseControllerViewController ()

@end

@implementation BaseControllerViewController
+ (instancetype)createViewControllerWithName:(NSString *)vcName createArgs:(id)args{
    BaseControllerViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.createArgs = args;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoffUser) name:@"logoffuser" object:nil];

    //默认view的背景色
    self.view.backgroundColor = RGB(226, 231, 237);
    
      // mj 下拉、上拉动画图片
        NSMutableArray * arr = [NSMutableArray array];
        for(int i=1; i<=32;i++){
            NSString * imagename = [NSString stringWithFormat:@"loading%d.png",i];
            UIImage * image = [UIImage imageNamed:imagename];
            [arr addObject:image];
        }
    
    self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeaderData:)];
       self.mj_header.lastUpdatedTimeLabel.hidden = YES;
       // 设置文字
       [self.mj_header setTitle:@"按住下拉" forState:MJRefreshStateIdle];
       [self.mj_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
       [self.mj_header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
       // 设置普通状态的动画图片 (idleImages 是图片)
       [self.mj_header setImages:arr forState:MJRefreshStateIdle];
       // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
       [self.mj_header setImages:arr forState:MJRefreshStatePulling];
       // 设置正在刷新状态的动画图片
       [self.mj_header setImages:arr forState:MJRefreshStateRefreshing];

       // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
      self.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterData:)];
       // 设置刷新图片
       [self.mj_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
       [self.mj_footer setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
       self.mj_footer.triggerAutomaticallyRefreshPercent = 50.0;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *className = NSStringFromClass([self class]);
    BOOL isHidden = ([className isEqualToString:@"LoginViewController"]);
    self.navigationController.navigationBarHidden = isHidden;
}
#pragma mark - mj
-(void)loadHeaderData:(MJRefreshGifHeader*)mj{
}
-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nav
-(void)setNavTitle:(NSString *)title{
    self.navigationItem.title = title;
}
-(void)initWithNavLeftImageName:(NSString *)leftimagename RightImageName:(NSString *)rightimagename{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:rightimagename] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(RightBarClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(0, 0, 60, 40)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:leftimagename] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(LeftBarClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 60, 40)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
}
// 导航栏  左边两个按钮
-(void)setLeftNavTilte:(NSString *)leftTitle RightNavTilte:(NSString *)title RightTitleTwo:(NSString *)twotitle{
    // 左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([leftTitle containsString:@".png"]) {
        [leftButton setImage:[UIImage imageNamed:leftTitle] forState:UIControlStateNormal];
    }else{
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    }
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10.5, 0, 0);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20.5, 0, 0);
    [leftButton addTarget:self action:@selector(LeftBarClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 60, 40)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([title containsString:@".png"]) {
        [rightBtn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    }else{
        [rightBtn setTitle:title forState:UIControlStateNormal];
    }
    [rightBtn setFrame:CGRectMake(0, 0, 25, 40)];
    [rightBtn addTarget:self action:@selector(RightBarClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightTar =  [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //
    UIButton *SearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([twotitle containsString:@".png"]) {
        [SearchBtn setImage:[UIImage imageNamed:twotitle] forState:UIControlStateNormal];
    }else{
        [SearchBtn setTitle:title forState:UIControlStateNormal];
    }
    [SearchBtn setFrame:CGRectMake(0, 0, 25, 40)];
    [SearchBtn addTarget:self action:@selector(SearchBarClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchTar =  [[UIBarButtonItem alloc] initWithCustomView:SearchBtn];
    //
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 2;
    
    self.navigationItem.rightBarButtonItems = @[searchTar,fixedSpaceBarButtonItem,rightTar];
}
// 默认导航栏  左边两个按钮
-(void)setNomalRightNavTilte:(NSString *)title RightTitleTwo:(NSString *)twotitle{
    // 左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(LeftBarClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 60, 40)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10.5, 0, 0);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20.5, 0, 0);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([title containsString:@".png"]) {
        [rightBtn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    }else{
        [rightBtn setTitleColor:kColor(@"C1") forState:UIControlStateNormal];
        [rightBtn setTitle:title forState:UIControlStateNormal];
    }
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn addTarget:self action:@selector(RightBarClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightTar =  [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //
    UIButton *SearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([twotitle containsString:@".png"]) {
        [SearchBtn setImage:[UIImage imageNamed:twotitle] forState:UIControlStateNormal];
    }else{
        [SearchBtn setTitleColor:kColor(@"C2") forState:UIControlStateNormal];
        [SearchBtn setTitle:twotitle forState:UIControlStateNormal];
    }
    [SearchBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [SearchBtn addTarget:self action:@selector(SearchBarClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchTar =  [[UIBarButtonItem alloc] initWithCustomView:SearchBtn];
    //
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 2;
    
    self.navigationItem.rightBarButtonItems = @[searchTar,fixedSpaceBarButtonItem,rightTar];
}

-(void)SearchBarClick{
    
}
-(void)RightBarClick{
    DDLogInfo(@"点击了导航栏右侧按钮");
}

-(void)LeftBarClick{
    DDLogInfo(@"点击了导航栏左侧按钮");
}
#pragma mark - alter
-(void)showOffLineAlertWithTime:(float)timing message:(NSString *)Message DoSomethingBlock:(void(^)(void))DoBlock{
    [[AppDelegate sharedDelegate] showTextOnly:Message];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timing * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(DoBlock){
            DoBlock();
        }
        [[AppDelegate sharedDelegate] hidHUD];
    });
}

-(void)showMessageAlertWithController:(UIViewController *)controller Message:(NSString *)message;
{
    _alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * canel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [_alertView addAction:canel];
    _alertView.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:_alertView animated:YES completion:nil];
}

-(void)showMessageAlertWithController:(UIViewController *)controller title:(NSString *)title Message:(NSString *)message canelBlock:(void(^)(void))canelblock{
    NSMutableAttributedString *msStr = [[NSMutableAttributedString alloc] initWithString:message];
    [msStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, message.length)];
    NSString * str = [msStr string];
    _alertView = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * canel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(canelblock){
            canelblock();
        }
    }];
    [_alertView addAction:canel];
    _alertView.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:_alertView animated:YES completion:nil];
}

//不同设备同时登陆 ---注销
-(void)logoffUser{
    [self showMessageAlertWithController:self title:@"" Message:@"当前账号已在其他设备登陆" canelBlock:^{
        NSLog(@"用户退出登录");
        //注销登录删除用户数据
        [[SaveDocumentArray sharedInstance] removefmdb];
        [[[UserFmdb alloc] init] deleteAllUserInfo];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AKTserviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:ChangeRootViewController object:nil];
    }];
}

#pragma mark -
-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end



