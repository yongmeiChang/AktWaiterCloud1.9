//
//  DatePickerView.m
//  YTDatePickerDemo
//
//  Created by 常永梅 on 2019/12/20.
//  Copyright © 2019年 TonyAng. All rights reserved.
//

#import "DatePickerView.h"
#import <Masonry.h>

@interface DatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
/**
 * 数组装年份
 */
@property (nonatomic, strong) NSMutableArray *yearArray;
/**
 * 本年剩下的月份
 */
@property (nonatomic, strong) NSMutableArray *monthRemainingArray;

@property (nonatomic, strong) NSMutableArray *dayRemainingArray;

/**
 * 不是闰年 装一个月多少天
 */
@property (nonatomic, strong) NSArray *NotLeapYearArray;
/**
 * 闰年 装一个月多少天
 */
@property (nonatomic, strong) NSArray *leapYearArray;

/**
 * 是否显示今天的日期 YES 显示 NO 不显示
 */
@property (nonatomic, assign) BOOL isShowTodayDate;

@end

@implementation DatePickerView
{
    UIView *viewDateBg; // 日期选择背景
    UIView *viewTimeBg; // 时间选择背景
    UILabel *labEnddata; // 头部日期显示
    NSString *yearStr;
    NSString *monthStr;
    NSString *dayStr;
    
    /**
     * 用三个的原因UIPickerView,而不直接用component这个直接返回3个,由于我们需要的时间选择器年月日都有两条横下,如果没这个要求,可以直接用component这儿属性,不用创建3次
     */
    UIPickerView *yearPicker;/**<年>*/
    UIPickerView *monthPicker;/**<月份>*/
    UIPickerView *dayPicker;/**<天>*/
    
    UIButton *cancelButton;/**<取消按钮>*/
    UIButton *sureButton;/**<确定按钮>*/
    DateShowMode dateShowMode;/**<时间显示模式>*/
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentDay;
    
    NSDate *date;/**<获得日期>*/
}
- (instancetype)initWithFrame:(CGRect)frame withDateShowMode:(DateShowMode)dateMode withIsShowTodayDate:(BOOL)isShowToday{
    if ([super initWithFrame:frame]) {
        
        _isShowTodayDate = isShowToday;
        dateShowMode = dateMode;
        self.yearArray = [NSMutableArray array];
        self.monthRemainingArray = [NSMutableArray array];
        self.dayRemainingArray = [NSMutableArray array];
        [self initData];
        [self setViews];
    }
    return self;
}

- (void)initData{
    //非闰年
    self.NotLeapYearArray = @[@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    //闰年
    self.leapYearArray = @[@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    /**
     * 判断时间显示模式
     *
     */
    if (dateShowMode == ShowDateBeforeToday){
        
        if (self.isShowTodayDate) {
            //显示今天的时间
            date = [NSDate date];
        }else{
            //不显示今天的时间
            date = [NSDate dateWithTimeIntervalSinceNow:-(24 * 3600)];
        }
    }else if (dateShowMode == ShowDateAfterToday){
        
        if (self.isShowTodayDate) {
            //显示今天的时间
            date = [NSDate date];
        }else{
            //不显示今天的时间
            date = [NSDate dateWithTimeIntervalSinceNow:+(24 * 3600)];
        }
    }else if (dateShowMode == ShowAllDate){
        //显示今天的时间
        date = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    currentYear = [[dateFormatter stringFromDate:date] integerValue];
    [dateFormatter setDateFormat:@"MM"];
    currentMonth = [[dateFormatter stringFromDate:date] integerValue];
    [dateFormatter setDateFormat:@"dd"];
    currentDay = [[dateFormatter stringFromDate:date] integerValue];
    
    //判断时间显示模式
    if (dateShowMode == ShowDateBeforeToday){
        
        for (NSInteger i = 0; i < 100; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%ld",(long)currentYear - i]];
        }
        for (NSInteger i = 0; i < currentMonth; i++) {
            [self.monthRemainingArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        for (NSInteger i = 0; i < currentDay; i++) {
            [self.dayRemainingArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }else if (dateShowMode == ShowDateAfterToday){
        for (NSInteger i = 0; i < 100; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%ld",(long)currentYear + i]];
        }
        for (NSInteger i = currentMonth - 1; i < 12; i++) {
            [self.monthRemainingArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        NSInteger lastDay = [self LeapYearCompare:currentYear withMonth:currentMonth];
        for (NSInteger i = currentDay - 1; i < lastDay; i++) {
            [self.dayRemainingArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }else{
        for (NSInteger i = 50; i > 0; i--) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%ld",(long)currentYear - i]];
        }
        for (NSInteger i = 0; i < 50; i++) {
            [self.yearArray addObject:[NSString stringWithFormat:@"%ld",(long)currentYear + i]];
        }
    }
}

#pragma mark - 判断是否是闰年(返回的的值,天数)
- (NSInteger)LeapYearCompare:(NSInteger)year withMonth:(NSInteger)month{
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return [self.leapYearArray[month - 1] integerValue];
    }else{
        return [self.NotLeapYearArray[month - 1] integerValue];
    }
}

- (void)setViews{
    viewDateBg = [[UIView alloc] init];
    viewDateBg.backgroundColor = [UIColor clearColor];
    [self addSubview:viewDateBg];
    [viewDateBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    
    labEnddata = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 58.5)];
    labEnddata.font = [UIFont systemFontOfSize:16];
    labEnddata.textColor = [UIColor blackColor];
    labEnddata.textAlignment = NSTextAlignmentCenter;
    [viewDateBg addSubview:labEnddata];
    
    UILabel *labI = [[UILabel alloc] init];
    labI.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [viewDateBg addSubview:labI];
    [labI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labEnddata.mas_bottom);
        make.left.width.mas_equalTo(viewDateBg);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *labDataTitle = [[UILabel alloc] init];
    labDataTitle.text = @"选择日期";
    labDataTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    labDataTitle.font = [UIFont systemFontOfSize:14];
    [viewDateBg addSubview:labDataTitle];
    [labDataTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.top.mas_equalTo(labI.mas_bottom).offset(24);
        make.height.mas_equalTo(14);
    }];
    //年
    //时间选择器
    yearPicker = [[UIPickerView alloc]init];
    yearPicker.delegate = self;
    yearPicker.dataSource = self;
    [viewDateBg addSubview:yearPicker];
    [yearPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDataTitle.mas_bottom);
        make.left.offset(20.5);
        make.width.offset(63);
        make.height.offset(110);
    }];
    
    //月
    monthPicker = [[UIPickerView alloc]init];
    monthPicker.delegate = self;
    monthPicker.dataSource = self;
    [viewDateBg addSubview:monthPicker];
    [monthPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDataTitle.mas_bottom);
        make.left.equalTo(yearPicker.mas_right).offset(20);
        make.width.offset(63);
        make.height.offset(110);
    }];
    
    //日
    dayPicker = [[UIPickerView alloc]init];
    dayPicker.delegate = self;
    dayPicker.dataSource = self;
    [viewDateBg addSubview:dayPicker];
    [dayPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDataTitle.mas_bottom);
       make.left.equalTo(monthPicker.mas_right).offset(20);
        make.width.offset(63);
        make.height.offset(110);
    }];
    
    UILabel *labLine = [[UILabel alloc] init];
    labLine.textColor = [UIColor blackColor];
    labLine.textAlignment = NSTextAlignmentCenter;
    labLine.text = @"-";
    [viewDateBg addSubview:labLine];
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yearPicker.mas_right).offset(5);
        make.top.mas_equalTo(labDataTitle.mas_bottom);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(110);
    }];
    
    UILabel *labLine2 = [[UILabel alloc] init];
    labLine2.textColor = [UIColor blackColor];
    labLine2.textAlignment = NSTextAlignmentCenter;
    labLine2.text = @"-";
    [viewDateBg addSubview:labLine2];
    [labLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(monthPicker.mas_right).offset(5);
        make.top.mas_equalTo(labDataTitle.mas_bottom);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(110);
    }];

    //取消
    cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [viewDateBg addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.offset(0);
        make.width.offset(96);
        make.height.offset(49);
    }];

    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureButton setTitle:@"设置" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundColor:[UIColor colorWithRed:94/255.0 green:133/255.0 blue:211/255.0 alpha:1.0]];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [viewDateBg addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.offset(0);
        make.width.offset(173.5);
        make.height.offset(49);
    }];

    //默认选中某个row
    switch (dateShowMode) {
            
        case ShowDateBeforeToday:
            [yearPicker selectRow:0 inComponent:0 animated:YES];
            [monthPicker selectRow:currentMonth - 1 inComponent:0 animated:YES];
            [dayPicker selectRow:currentDay - 1 inComponent:0 animated:YES];
            break;
            
        case ShowDateAfterToday:
            [yearPicker selectRow:0 inComponent:0 animated:YES];
            [monthPicker selectRow:0 inComponent:0 animated:YES];
            [dayPicker selectRow:0 inComponent:0 animated:YES];

            break;
        case ShowAllDate:
            
            [yearPicker selectRow:50 inComponent:0 animated:YES];
            [monthPicker selectRow:currentMonth - 1 inComponent:0 animated:YES];
            [dayPicker selectRow:currentDay - 1 inComponent:0 animated:YES];
            
            break;
        default:
            break;
    }
}

#pragma mark - pickerView的delegate方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  
    if (pickerView == yearPicker) {
        [monthPicker reloadAllComponents];
        [dayPicker reloadAllComponents];
        yearStr = [NSString stringWithFormat:@"%@",self.yearArray[row]];
    }else if (pickerView == monthPicker){
        [dayPicker reloadAllComponents];
        
        monthStr = [NSString stringWithFormat:@"%ld",(long)row % 12 + 1];
    }else if(pickerView == dayPicker){
        
        NSInteger yearRow = [yearPicker selectedRowInComponent:0] % self.yearArray.count;
        NSInteger monthRow = [monthPicker selectedRowInComponent:0] % 12;
        NSInteger monthDays = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:(monthRow + 1)];
        dayStr = [NSString stringWithFormat:@"%ld",(long)row % monthDays + 1];
    }
//        else if (pickerView == hPicker){
//        [mPicker reloadAllComponents];
//        houceStr = [NSString stringWithFormat:@"%@",self.houceRemainingArray[row]];
//    }else if (pickerView == mPicker){
//        minuceStr = [NSString stringWithFormat:@"%@",self.minuceRemainingArray[row]];
//    }

    NSLog(@"%@年%@月%@日",yearStr,monthStr,dayStr);
    labEnddata.text = [NSString stringWithFormat:@"%@年%@月%@日",yearStr,monthStr,dayStr];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == yearPicker) {
        
        return self.yearArray.count;
        
    }else if (pickerView == monthPicker){
        switch (dateShowMode) {
            case ShowDateBeforeToday:
                
                return [self MonthInSelectYear];
                
                break;
                
            case ShowDateAfterToday:
                
                return [self MonthInSelectYear];
                break;
                
            case ShowAllDate:
                return 12;
                break;
        }
    }else if(pickerView == dayPicker){
        
        switch (dateShowMode) {
                
            case ShowDateBeforeToday:
                
                return [self daysInSelectMonth:ShowDateBeforeToday];
                
                break;
                
            case ShowDateAfterToday:
                
                return [self daysInSelectMonth:ShowDateAfterToday];
                
                break;
                
            case ShowAllDate:
                
                return [self daysInSelectMonth:ShowAllDate];
                
                break;
                
        }
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 48;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return 64 ;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *rowLabel = [[UILabel alloc]init];
    rowLabel.textAlignment = NSTextAlignmentCenter;
    rowLabel.backgroundColor = [UIColor clearColor];
    rowLabel.frame = CGRectMake(0, 0, 39,self.frame.size.width);
    rowLabel.textAlignment = NSTextAlignmentCenter;
    rowLabel.font = [UIFont systemFontOfSize:17];
    rowLabel.textColor = [UIColor grayColor];
 
//    [pickerView.subviews[1] setBackgroundColor:[UIColor whiteColor]];
//    [pickerView.subviews[2] setBackgroundColor:[UIColor whiteColor]];

    [rowLabel sizeToFit];
    if (pickerView == yearPicker) {
        NSArray *subviews = yearPicker.subviews;
        NSArray *coloms = subviews.firstObject;
        if (coloms) {
            NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
            if (subviewCache.count > 0) {
                UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                if (middleContainerView) {
                    middleContainerView.backgroundColor = [UIColor colorWithRed:170/255.0 green:192/255.0 blue:234/255.0 alpha:1.0];
                    middleContainerView.layer.masksToBounds = YES;
                    middleContainerView.layer.cornerRadius = 5;
                }
            }
        }
        rowLabel.text = self.yearArray[row];
        yearStr = rowLabel.text;
        return rowLabel;
        
    }else if(pickerView == monthPicker){
        NSArray *subviews = monthPicker.subviews;
               NSArray *coloms = subviews.firstObject;
               if (coloms) {
                   NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
                   if (subviewCache.count > 0) {
                       UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                       if (middleContainerView) {
                           middleContainerView.backgroundColor = [UIColor colorWithRed:170/255.0 green:192/255.0 blue:234/255.0 alpha:1.0];
                           middleContainerView.layer.masksToBounds = YES;
                           middleContainerView.layer.cornerRadius = 5;
                       }
                   }
               }
        
        NSInteger yearRow = [yearPicker selectedRowInComponent:0] % self.yearArray.count;
        
        switch (dateShowMode) {
            case ShowDateBeforeToday :
                if ([self.yearArray[yearRow] integerValue] == currentYear) {
                    
                    rowLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.monthRemainingArray[row] integerValue] + 1];
                    
                }else{
                    
                    rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % 12 + 1];
                    
                }
                
                break;
                
            case ShowDateAfterToday:
                if ([self.yearArray[yearRow] integerValue] == currentYear) {
                    
                    rowLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.monthRemainingArray[row] integerValue] + 1];
                    
                }else{
                    
                    rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % 12 + 1];
                }
                
                break;
                
            case ShowAllDate:
                
                rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % 12 + 1];
                
                break;
            default:
                break;
        }
        monthStr = rowLabel.text;
        
        return rowLabel;
        
        
    }else{
        NSArray *subviews = dayPicker.subviews;
               NSArray *coloms = subviews.firstObject;
               if (coloms) {
                   NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
                   if (subviewCache.count > 0) {
                       UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                       if (middleContainerView) {
                           middleContainerView.backgroundColor = [UIColor colorWithRed:170/255.0 green:192/255.0 blue:234/255.0 alpha:1.0];
                           middleContainerView.layer.masksToBounds = YES;
                           middleContainerView.layer.cornerRadius = 5;
                       }
                   }
               }
        /**********/
        NSInteger yearRow = [yearPicker selectedRowInComponent:0] % self.yearArray.count;
        NSInteger monthRow = [monthPicker selectedRowInComponent:0] % 12;
        NSInteger monthDays = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:(monthRow + 1)];
        
        switch (dateShowMode) {
            case ShowDateBeforeToday:
                
                if ([self.yearArray[yearRow] integerValue] == currentYear) {
                    
                    if ([self.monthRemainingArray[monthRow] integerValue] + 1 == currentMonth) {
                        
                        
                        rowLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.dayRemainingArray[row] integerValue] + 1];
                        
                    }else{
                        
                        NSInteger monthRemainingDays = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:[self.monthRemainingArray[monthRow] integerValue] + 1];
                        
                        rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % monthRemainingDays + 1];
                        
                    }
                }else{
                    rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % monthDays + 1];
                    }
                
                break;
                
            case ShowDateAfterToday:
                if ([self.yearArray[yearRow] integerValue] == currentYear) {
                    if ([self.monthRemainingArray[monthRow] integerValue] + 1 == currentMonth) {
                        
                        rowLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.dayRemainingArray[row] integerValue] + 1];
                        
                    }else{
                        
                        NSInteger monthRemainingDays = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:[self.monthRemainingArray[monthRow] integerValue]];
                        rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % monthRemainingDays + 1];
                    }
                    
                }else{
                    
                    rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % monthDays + 1];
                }
                
                break;
            case ShowAllDate:
                rowLabel.text = [NSString stringWithFormat:@"%ld",(long)row % monthDays + 1];
                dayStr = rowLabel.text;
                break;
                
            default:
                break;
        }
        
        dayStr = rowLabel.text;
        labEnddata.text = [NSString stringWithFormat:@"%@年%@月%@日",yearStr,monthStr,dayStr];
        return rowLabel;
    }
}
#pragma mark -
/**
 * 返回有多少个月
 */
- (NSInteger)MonthInSelectYear{
    NSInteger yearRow = [yearPicker selectedRowInComponent:0];
    
    if ([self.yearArray[yearRow] integerValue] == currentYear) {
        
        return self.monthRemainingArray.count;
        
    }else{
        return 12;
    }
    
}
/**
 * 返回有多少天
 */
- (NSInteger)daysInSelectMonth:(DateShowMode)timeMode{
    NSInteger yearRow = [yearPicker selectedRowInComponent:0] % self.yearArray.count;
    NSInteger monthRow = [monthPicker selectedRowInComponent:0] % 12;
    NSInteger monthDays = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:(monthRow + 1)];
    if (timeMode == ShowDateAfterToday || dateShowMode == ShowDateBeforeToday) {
        
        if ([self.yearArray[yearRow] integerValue] == currentYear ) {
            
            if ([self.monthRemainingArray[monthRow] integerValue] + 1 == currentMonth) {
                
                return self.dayRemainingArray.count;
                
            }else{
                
                NSInteger monthRemainingDays = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:[self.monthRemainingArray[monthRow] integerValue] + 1];
                
                return monthRemainingDays;
            }
            
        }else{
            
            return monthDays;
        }
    }else{
        NSInteger days = [self LeapYearCompare:[self.yearArray[yearRow] integerValue] withMonth:(monthRow + 1)];
        return days;
    }
}

#pragma mark - 取消按钮点击方法
- (void)cancelAction{
    [self.delegate DatePickerView:yearStr withMonth:monthStr withDay:dayStr withDate:@"取消"withTag:1002];
}

#pragma mark - 确定按钮点击方法
- (void)sureAction{
    [self.delegate DatePickerView:yearStr withMonth:monthStr withDay:dayStr withDate:[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr] withTag:1001];
}

@end
