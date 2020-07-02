//
//  Vaildate.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/19.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "Vaildate.h"

@implementation Vaildate
+ (BOOL)dx_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}


#pragma mark - 正则相关
+(BOOL)isValidateByRegex:(NSString *)regex Param:(NSString *)param{
     NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:param];
}
//手机号分服务商
+(BOOL)isMobileNumberClassification:(NSString *)param{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
    */
//    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186,1709
     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,1700
     */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([self isValidateByRegex:CM Param:param])
        || ([self isValidateByRegex:CU Param:param])
        || ([self isValidateByRegex:CT Param:param])
        || ([self isValidateByRegex:PHS Param:param])){
           return YES;
        }
    else{
        return NO;
    }
}

//手机号有效性
+(BOOL)isMobileNumber:(NSString *)mobile{
    NSString *regex = @"^((1[0-9][0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    BOOL isMatch = [self isValidateByRegex:regex Param:mobile];
    return isMatch;
}


@end
