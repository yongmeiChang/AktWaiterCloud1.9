//
//  SigninController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/2.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseViewController.h"
@class OrderInfo;
@interface SignoutController : WorkBaseViewController
@property (nonatomic,assign) int type;// 0签入 1签出 (签出有录音,照片一张)
@property (nonatomic,strong) OrderInfo * orderinfo;
-(id)initSignoutControllerWithOrderInfo:(OrderInfo *)orderinfo;
@end
