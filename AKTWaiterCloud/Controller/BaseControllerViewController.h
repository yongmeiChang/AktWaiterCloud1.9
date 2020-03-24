//
//  BaseControllerViewController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/19.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "PFViewHeader.h"

//快速注册多种cellnib
UIKIT_STATIC_INLINE void LRRegisterNibsQuick(UITableView * _Nullable tableView, NSArray * _Nullable names){
    for (NSString *name in names) {
        UINib *nib=[UINib nibWithNibName:name bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:name];
    }
}

@interface BaseControllerViewController : UIViewController
@property (strong) id _Nullable createArgs;
@property (nonatomic,strong) UIAlertController * _Nullable alertView;
@property(nonatomic,strong) MJRefreshAutoGifFooter * _Nullable mj_footer;
@property(nonatomic,strong) MJRefreshGifHeader * _Nullable mj_header;

+ (instancetype _Nullable )createViewControllerWithName:(NSString *_Nullable)vcName createArgs:(nullable id)args;

-(void)setNavTitle:(NSString *_Nullable)title;
-(void)initWithNavLeftImageName:(NSString *_Nullable)leftimagename RightImageName:(NSString *_Nullable)rightimagename;// 左右是图片
-(void)setLeftNavTilte:(NSString *_Nullable)leftTitle RightNavTilte:(NSString *_Nullable)title RightTitleTwo:(NSString *_Nullable)twotitle; // 导航栏左边两个按钮
-(void)setNomalRightNavTilte:(NSString *_Nullable)title RightTitleTwo:(NSString *_Nullable)twotitle;// 默认导航栏  左边两个按钮
-(void)LeftBarClick;
-(void)SearchBarClick; // 搜索按钮

-(void)showOffLineAlertWithTime:(float)timing message:(NSString *_Nullable)Message DoSomethingBlock:(void(^_Nullable)(void))DoBlock;

-(void)showMessageAlertWithController:(UIViewController *_Nullable)controller Message:(NSString *_Nullable)message;

-(void)showMessageAlertWithController:(UIViewController *_Nullable)controller title:(NSString *_Nullable)titile Message:(NSString *_Nullable)message canelBlock:(void(^_Nullable)(void))canelblock;

- (void)touchesBegan:(NSSet<UITouch *> *_Nullable)touches withEvent:(UIEvent *_Nullable)event;

-(void)backClick:(id _Nullable )sender;

@end
