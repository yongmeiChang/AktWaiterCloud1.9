//
//  UIImage+Color.h
//  FRMicroClass
//
//  Created by K.E. on 2019/3/13.
//  Copyright © 2019 Amy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageNamedWithoutSelected:(NSString *)_name;
@end

NS_ASSUME_NONNULL_END
