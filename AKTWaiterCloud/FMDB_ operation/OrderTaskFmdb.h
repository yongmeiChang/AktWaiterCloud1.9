//
//  OrderTaskFmdb.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/30.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

//本地缓存工单数据
@interface OrderTaskFmdb : NSObject
-(void)saveOrderTask:(OrderInfo *)orderinfo;
-(void)deleteAllOrderTask;
-(OrderInfo *)findByrow:(NSInteger)row;
-(NSMutableArray *)findAllOrderInfo;
-(void)updateObject:(OrderInfo *)orderinfo;
-(void)deleteOrderTaskByWorkNo:(NSString *)WorkNo;
-(OrderInfo *)findByWorkNo:(NSString *)WorkNo;
-(int)size;
@end
