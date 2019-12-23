//
//  DatePickerView.h
//  YTDatePickerDemo
//
//  Created by 常永梅 on 2019/12/20.
//  Copyright © 2019年 TonyAng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerView;
@protocol DatePickerViewDelegate <NSObject>

- (void)DatePickerView:(NSString *)year withMonth:(NSString *)month withDay:(NSString *)day withDate:(NSString *)date withTag:(NSInteger) tag;

@end
typedef NS_ENUM(NSInteger,DateShowMode){
    /**
     * 只显示今天之前的时间
     */
    ShowDateBeforeToday = 1,
    /**
     * 显示今天之后的时间
     */
    ShowDateAfterToday,
    /**
     * 不限制时间
     */
    ShowAllDate,
    
};
@interface DatePickerView : UIView
- (instancetype)initWithFrame:(CGRect)frame withDateShowMode:(DateShowMode)dateMode withIsShowTodayDate:(BOOL)isShowToday;
@property (nonatomic, assign) id<DatePickerViewDelegate> delegate;

@end
