//
//  CheckObject.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/18.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "CheckObject.h"

@implementation CheckObject

+(Boolean)CheckArrayIsOk:(NSArray *)arr{
    if(arr!=nil&&![arr isKindOfClass:[NSNull class]] && arr.count!=0){
        return true;
    }else{
        return false;
    }
}

@end
