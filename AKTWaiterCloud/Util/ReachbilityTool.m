//
//  ReachbilityTool.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "ReachbilityTool.h"

@implementation ReachbilityTool
+(NSString *)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"wifi";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"wifi";
            break;
            
        case ReachableViaWWAN:
            net = @"wwan";
            break;
            
        case NotReachable:
            net = @"notReachable";
            
        default:
            break;
    }
    
    return net;
}
@end
