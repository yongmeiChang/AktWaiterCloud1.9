//
//  DownOrderController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/8.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//  扫码租户信息下单页面
//
#import <UIKit/UIKit.h>
#import "WorkBaseViewController.h"

@interface DownOrderController : WorkBaseViewController
@property(nonatomic,strong) DownOrderFirstInfo * dofInfo;
@property(nonatomic,strong) ServicePojInfo * servicepojInfo;
@property(nonatomic,strong) NSString * customerUkey;

-(id)initDownOrderControllerWithCustomerUkey:(DownOrderFirstInfo *)oldman customerUkey:(NSString *)customerUkey;
@end
