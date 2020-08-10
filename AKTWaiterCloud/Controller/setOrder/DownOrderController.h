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
//@property(nonatomic,strong) DownOrderUserInfo * dofInfo; // 添加工单信息
@property(nonatomic,strong) ServicePojInfo * servicepojInfo;// 选中的服务项目信息
@property(nonatomic,strong) ServiceStationInfo * stationInfo;// 选中的服务站点信息

@property(nonatomic,strong) NSString * customerUkey;

-(id)initDownOrderControllerWithCustomerUkey:(DowOrderData *)oldman customerUkey:(NSString *)customerUkey;
@end
