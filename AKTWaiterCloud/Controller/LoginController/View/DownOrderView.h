//
//  DownOrderView.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HandDelegate <NSObject>
- (void)pushHandView; //声明协议方法
@end
@protocol SearchDelegate <NSObject>
- (void)pushSearchView; //声明协议方法
@end
@interface DownOrderView : UIView
@property (nonatomic,strong) UIButton * handCodeBtn;
@property (nonatomic,strong) UIButton * sreachBtn;

@property (nonatomic, weak)id<HandDelegate> hdelegate; //声明协议变量
@property (nonatomic, weak)id<SearchDelegate> sdelegate; //声明协议变量
@end
