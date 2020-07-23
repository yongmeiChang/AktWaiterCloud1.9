//
//  AktOrderDetailsVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/16.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGaodeMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface AktOrderDetailsVC : MyGaodeMap

@property(nonatomic,strong) NSString * type; //0为待办任务跳转  1为我的页面中跳转（不能操作 2为计划任务跳转）所有工单列表点击详情统一跳入此页面
-(id)initMinuteTaskControllerwithOrderInfo:(OrderInfo *)orderinfo;

@end

NS_ASSUME_NONNULL_END
