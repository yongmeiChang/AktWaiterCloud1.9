//
//  RangeUtil.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/3/28.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface RangeUtil : NSObject<AMapSearchDelegate, AMapLocationManagerDelegate>
@property (nonatomic,strong) AMapLocationManager * locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic,strong) NSString * locaitony;
@property (nonatomic,strong) NSString * locaitonx;
@property (nonatomic,strong) NSString * servicelocaitony;
@property (nonatomic,strong) NSString * servicelocaitonx;
- (void)locAction;
-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lon1 :(double) lon2;
@end
