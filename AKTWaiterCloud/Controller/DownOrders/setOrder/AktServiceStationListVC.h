//
//  AktServiceStationListVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/8/7.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class DownOrderController;
@interface AktServiceStationListVC : BaseControllerViewController

@property(nonatomic,strong) DownOrderController * DoContoller;
@property(nonatomic,strong) ServiceStationInfo * stationInfo;
@property(nonatomic,strong) NSArray *aryStation; // 服务站点列表

@end

NS_ASSUME_NONNULL_END
