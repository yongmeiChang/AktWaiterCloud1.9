//
//  AktOrderDetailsCheckImageVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/18.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AktOrderDetailsCheckImageVC : BaseControllerViewController
@property(nonatomic,copy) NSString *orderId; // 工单ID
@property(nonatomic,copy) NSString *imgtype; // 图片类型 1签入  2签出
@end

NS_ASSUME_NONNULL_END
