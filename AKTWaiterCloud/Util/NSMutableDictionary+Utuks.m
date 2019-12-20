//
//  NSMutableDictionary.m
//  AnKangTong
//
//  Created by admin on 16/1/20.
//  Copyright (c) 2016年 www.3ti.us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMacro.h"
@implementation NSMutableDictionary (Utils)

- (void)addUnEmptyString:(NSString *)stringObject forKey:(NSString *)key{
    
    if (ICIsStringEmpty(stringObject)) {
        [self setObject:@"" forKey:key];
    }else{
        [self setObject:stringObject forKey:key];
    }
}

@end
