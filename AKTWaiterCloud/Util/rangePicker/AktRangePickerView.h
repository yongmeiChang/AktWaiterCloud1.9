//
//  AktRangePickerView.h
//  DateAndTimePicker
//
//  Created by 常永梅 on 2019/12/25.
//  Copyright © 2019 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AktRangePickerView;
@protocol AktRangePickerViewDelegate <NSObject>

- (void)AktRangePickerViewFirstDate:(NSString *)firstdate LastDate:(NSString *)lastdate;

@end

@interface AktRangePickerView : UIView

@property (nonatomic, assign) id<AktRangePickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
