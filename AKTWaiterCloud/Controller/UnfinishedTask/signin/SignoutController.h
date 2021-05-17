//
//  SigninController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/2.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseViewController.h"
#import "AktOrderDetailsModel.h"

@class OrderInfo;
@interface SignoutController : WorkBaseViewController
@property (nonatomic,assign) int type;// 0签入 1签出 (签出有录音,照片一张  ------ 该逻辑在4.0中废弃)
@property (nonatomic,strong) OrderListModel * orderinfo;
@property (nonatomic, strong) AktFindAdvanceModel *findAdmodel;

/*新增逻辑*/
@property (nonatomic)BOOL isnewlate; // 迟到弹框
@property (nonatomic)BOOL isnewLation; // 定位弹框
@property (nonatomic)BOOL isnewearly; // 早退弹框
@property (nonatomic)BOOL isnewserviceTimeLess; // 最低服务时长弹框
@property (nonatomic)BOOL isnewserviceTime; // 服务时长弹框

-(id)initSignoutControllerWithOrderInfo:(OrderListModel *)orderinfo;
@end
