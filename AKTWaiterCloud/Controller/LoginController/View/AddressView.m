//
//  AddressView.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/4/18.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import "AddressView.h"

@implementation AddressView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT-SCREEN_HEIGHT/2-165, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self selectRow:0 inComponent:0 animated:NO];

    }
    return self;
}

@end
