//
//  DateUtil.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+(NSDate *)StringtoDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-mm-dd hh:mm:ss";
    NSDate * date = [dateFormatter dateFromString:dateStr];
    return date;
}
@end
