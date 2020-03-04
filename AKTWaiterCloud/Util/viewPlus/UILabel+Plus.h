//
//  UILabel+Plus.h
//  FRMicroClass
//
//  Created by K.E. on 2019/3/13.
//  Copyright © 2019 Amy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Plus)

+ (UILabel *)initWithText:(NSString *)_text fName:(nullable NSString *)_fName fSize:(NSInteger)_fSize tColor:(UIColor *) _tColor;
+ (UILabel *)initWithAttributText:(NSMutableAttributedString *)_text;
@end

NS_ASSUME_NONNULL_END
