//
//  WSPlaceholderTextView.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/7/23.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
