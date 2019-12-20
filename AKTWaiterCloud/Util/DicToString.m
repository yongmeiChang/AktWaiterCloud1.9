//
//  DicToString.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "DicToString.h"

@implementation DicToString
/**
 *NSDictionary转NSString
 **/
+ (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary{
    //系统自带
    //    NSError * error;
    //    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error]；
    //    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //自定义
    NSString *jsonStr = @"{";
    NSArray * keys = [dictionary allKeys];
    for (NSString * key in keys) {
        jsonStr = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
    }
    
    jsonStr = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];
    
    return jsonStr;
}
@end
