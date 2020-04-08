//
//  UILabel+Plus.m
//  FRMicroClass
//
//  Created by K.E. on 2019/3/13.
//  Copyright © 2019 Amy. All rights reserved.
//

#import "UILabel+Plus.h"

@implementation UILabel (Plus)
+ (UILabel *)initWithText:(NSString *)_text fName:(nullable NSString *)_fName fSize:(NSInteger)_fSize tColor:(UIColor *) _tColor{
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setText:_text];
    [lbl setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:_fSize]];
    if (_fName) [lbl setFont:[UIFont fontWithName:_fName size:_fSize]];
    [lbl setTextColor:_tColor];
    return lbl;
}

+ (UILabel *)initWithAttributText:(NSMutableAttributedString *)_text{
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setAttributedText:_text];
    return lbl;
}
@end
