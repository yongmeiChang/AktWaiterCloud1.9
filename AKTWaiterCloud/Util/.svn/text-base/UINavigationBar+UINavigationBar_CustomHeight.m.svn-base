//
//  UINavigationBar+UINavigationBar_CustomHeight.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/24.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "UINavigationBar+UINavigationBar_CustomHeight.h"
#import "objc/runtime.h"

@implementation UINavigationBar (UINavigationBar_CustomHeight)
static char const *const heightKey = "Height";

- (void)setHeight:(CGFloat)height
{
    objc_setAssociatedObject(self, heightKey, @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)height
{
    return objc_getAssociatedObject(self, heightKey);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize;
    
    if (self.height) {
        newSize = CGSizeMake(self.superview.bounds.size.width, [self.height floatValue]);
    } else {
        newSize = [super sizeThatFits:size];
    }
    
    return newSize;
}

@end
