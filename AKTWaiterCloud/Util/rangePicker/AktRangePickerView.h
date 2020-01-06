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

@property (nonatomic, strong) NSString *minimumDate; // 最小时间点  1986-01-01

@property (nonatomic, strong) NSString *maximumDate; // 最大时间点  50

@end

NS_ASSUME_NONNULL_END
