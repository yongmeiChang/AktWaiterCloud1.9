//
//  ButtonUtil.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/10.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "ButtonUtil.h"

@implementation ButtonUtil

/**
 *图片文字分上下显示
 */
+(void)initButtonStyle:(UIButton*)btn{
    float  spacing = 10;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
