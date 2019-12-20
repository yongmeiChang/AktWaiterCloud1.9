//
//  Vaildate.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/19.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  Vaildate : NSObject
/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)dx_isNullOrNilWithObject:(id)object;


#pragma mark - 正则相关
+(BOOL)isValidateByRegex:(NSString *)regex Param:(NSString *)param;
//手机号分服务商
+(BOOL)isMobileNumberClassification:(NSString *)param;
//手机号有效性
+(BOOL)isMobileNumber:(NSString *)mobile;
@end
