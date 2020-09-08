//
//  AppInfoDefult.m
//  AnKangTong
//
//  Created by admin on 16/1/25.
//  Copyright (c) 2016年 www.3ti.us. All rights reserved.
//

#import "AppInfoDefult.h"
#import <AFNetworking.h>

@implementation AppInfoDefult

static AppInfoDefult *app_instance = nil;

+(AppInfoDefult *)sharedClict {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        app_instance = [[AppInfoDefult alloc]init];
        
    });
    
    return app_instance;
}

/**
 *  在defualt中设置key和value值
 *
 *  @param value 值
 *  @param key   关键字
 *
 */
-(void)setValueInDefault:(id)value withKey:(NSString *)key
{
    NSData *object = [NSKeyedArchiver archivedDataWithRootObject:value];
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  根据key获取对应的defualt中的value值
 *
 *  @param key
 *
 *  @return
 */
-(id)getValueFromDefaultWithKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    id value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return value;
}

-(void)removeObjectWithKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

- (void)getnetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                self.networkingStatus = NO;
//                return YES;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
               self.networkingStatus = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                
               self.networkingStatus = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                
               self.networkingStatus = YES;
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}


-(Boolean)isLogin{
    if([LoginModel gets]){
        return YES;
    }else{
        return NO;
    }
}

-(Boolean)isNaTali{
    NSString * userid = [[UserInfo getsUser].uniqueKey substringWithRange:NSMakeRange(0,3)];
    if([userid isEqualToString:@"888"]){
        return YES;
    }else{
        return NO;
    }

}
@end
