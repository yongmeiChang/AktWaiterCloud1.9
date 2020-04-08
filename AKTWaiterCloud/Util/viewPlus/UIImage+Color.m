//
//  UIImage+Color.m
//  FRMicroClass
//
//  Created by K.E. on 2019/3/13.
//  Copyright © 2019 Amy. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 去掉默认的选中蓝光
+ (UIImage *)imageNamedWithoutSelected:(NSString *)_name{
    UIImage *image;
    if ([_name containsString:@"http"]) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_name]]];
    }else{
        image = [UIImage imageNamed:_name];
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
