//
//  CheckInJudge.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/3/13.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInJudge : NSObject
//保存当前签入的工单
-(void)setCheckInObject:(id)checkInOrderInfo;

//检测能否签入工单
-(Boolean)checkUpCheckInOrder;
@end
