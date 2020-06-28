//
//  UserFmdb.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/25.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
//本地缓存用户数据
@interface UserFmdb : NSObject
-(void)saveUserInfo:(UserInfo *)userinfo;
-(void)deleteAllUserInfo;
//-(UserInfo *)findByrow:(NSInteger)row;
-(void)updateObject:(UserInfo *)userinfo;
-(int)size;

@end
