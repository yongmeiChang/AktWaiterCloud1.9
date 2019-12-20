//
//  BaseControllerViewController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/19.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

//快速注册多种cellnib
UIKIT_STATIC_INLINE void LRRegisterNibsQuick(UITableView * tableView, NSArray * names){
    for (NSString *name in names) {
        UINib *nib=[UINib nibWithNibName:name bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:name];
    }
}

@interface BaseControllerViewController : UIViewController
@property (nonatomic,strong) UIAlertController * alertView;
@property(nonatomic,strong) MJRefreshAutoGifFooter *mj_footer;
@property(nonatomic,strong) MJRefreshGifHeader * mj_header;

-(void)setNavTitle:(NSString *)title;
-(void)initWithNavLeftImageName:(NSString *)leftimagename RightImageName:(NSString *)rightimagename;// 左右是图片
-(void)setLeftNavTilte:(NSString *)leftTitle RightNavTilte:(NSString *)title RightTitleTwo:(NSString *)twotitle; // 导航栏左边两个按钮
-(void)setNomalRightNavTilte:(NSString *)title RightTitleTwo:(NSString *)twotitle;// 默认导航栏  左边两个按钮
-(void)LeftBarClick;
-(void)SearchBarClick; // 搜索按钮

-(void)switchMode:(UIViewController *)viewController DoWorkBlock:(void(^)(void))okblock canelBlock:(void(^)(void))canelblock;
-(void)showOffLineAlertWithTime:(float)timing message:(NSString *)Message DoSomethingBlock:(void(^)(void))DoBlock;

-(void)showMessageAlertWithController:(UIViewController *)controller Message:(NSString *)message;

-(void)showMessageAlertWithController:(UIViewController *)controller title:(NSString *)titile Message:(NSString *)message canelBlock:(void(^)(void))canelblock;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

-(void)backClick:(id)sender;

@end
