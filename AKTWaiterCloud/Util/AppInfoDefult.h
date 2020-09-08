//
//  AppInfoDefult.h
//  AnKangTong
//
//  Created by admin on 16/1/25.
//  Copyright (c) 2016年 www.3ti.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultKey_Userinfo  @"DefaultKey_Userinfo"  // 用户信息
#define CheckIn_Order @"CheckIn_Order"//签入的工单
@interface AppInfoDefult : NSObject

@property (nonatomic,assign)int islogined;

@property (nonatomic,assign)int isBindOld;

@property (nonatomic,assign)int isTapZan;

@property (nonatomic,strong)NSString *jumpFlag;

@property (nonatomic,assign)BOOL displaySVP;

@property (nonatomic,strong)NSString *isHaveOrderID;

@property (nonatomic,strong)NSString *JumpOrderOrList;

@property (nonatomic,assign)BOOL networkingStatus;

//@property (nonatomic,assign)int islongLocation;//0没有定位 1有连续定位
//@property (nonatomic,strong)NSString* orderinfoId;//正在持续定位的id
+ (AppInfoDefult *)sharedClict;
- (void)getnetwork;
-(void)setValueInDefault:(id)value withKey:(NSString *)key;
-(id)getValueFromDefaultWithKey:(NSString *)key;
-(void)removeObjectWithKey:(NSString *)key;
-(Boolean)isLogin;
-(Boolean)isNaTali;
@end
