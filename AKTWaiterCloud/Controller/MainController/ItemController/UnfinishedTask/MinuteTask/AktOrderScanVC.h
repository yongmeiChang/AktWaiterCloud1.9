//
//  AktOrderScanVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/17.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseViewController.h"
#import "AktOrderDetailsModel.h"
#import <AVFoundation/AVFoundation.h> // 扫码

NS_ASSUME_NONNULL_BEGIN
@class OrderInfo;

@interface AktOrderScanVC : WorkBaseViewController
@property(nonatomic,strong)NSString *ordertype; // 1签入  2签出

@property (nonatomic,strong) OrderInfo * orderinfo;
@property (nonatomic,strong) AktFindAdvanceModel * detailsModel;

@property (nonatomic,strong)AVCaptureSession *session; // 扫码
/*新增逻辑*/
@property (nonatomic)BOOL isnewlate; // 迟到弹框
@property (nonatomic)BOOL isnewLation; // 定位弹框
@property (nonatomic)BOOL isnewearly; // 早退弹框
@property (nonatomic)BOOL isnewserviceTimeLess; // 最低服务时长弹框
@property (nonatomic)BOOL isnewserviceTime; // 服务时长弹框

@end

NS_ASSUME_NONNULL_END
