//
//  CheckInJudge.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/3/13.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import "CheckInJudge.h"
#import "AppInfoDefult.h"
@implementation CheckInJudge

-(void)setCheckInObject:(id)checkInOrderInfo{
    [[AppInfoDefult sharedClict]setValueInDefault:checkInOrderInfo withKey:CheckIn_Order];
}

-(Boolean)checkUpCheckInOrder{
    OrderInfo * order = [[AppInfoDefult sharedClict]getValueFromDefaultWithKey:CheckIn_Order];
    if([Vaildate dx_isNullOrNilWithObject:order]){
        //NSOrderedAscending的意思是：左边的操作对象小于右边的对象。
        //NSOrderedDescending的意思是：左边的操作对象大于右边的对象。
        NSDate * date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        // 截止时间data格式
        NSDate *expireDate = [formatter dateFromString:order.serviceEnd];
        // 当前日历
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // 需要对比的时间数据
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
        | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        // 对比时间差
        NSDateComponents *dateCom = [calendar components:unit fromDate:expireDate toDate:date options:0];
    if(dateCom.year==0&&dateCom.month==0&&dateCom.day==0&&dateCom.hour==0&&dateCom.minute==0&&dateCom.second==0){
            return true;
        }else{
            return false;
        }
        
    }else{
        return true;
    }
}
@end
