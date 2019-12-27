//
//  AktRangePickerView.m
//  DateAndTimePicker
//
//  Created by 常永梅 on 2019/12/25.
//  Copyright © 2019 常永梅. All rights reserved.
//

#import "AktRangePickerView.h"
#import "FSCalendar.h"
#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"
#import "Masonry.h"

// 屏幕高度
#define SCREENHEIGHT            CGRectGetHeight([UIScreen mainScreen].bounds)
// 屏幕宽度
#define SCREENWIDTH             CGRectGetWidth([UIScreen mainScreen].bounds)

@interface AktRangePickerView ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
{
    NSString *strFisrt; // 开始日期
    NSString *strLast; // 结束日期
}

@property (weak, nonatomic) FSCalendar *calendar;

@property (weak, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIButton *btnReset; // 重置
@property (strong, nonatomic) UIButton *btnSure;  // 确认
@property (strong, nonatomic) NSDate *date1; // 开始
@property (strong, nonatomic) NSDate *date2; // 结束

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;


@end

@implementation AktRangePickerView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setViews];
    }
    return self;
}

-(void)setViews{
    UIView *viewGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    viewGray.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:viewGray];
    
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-475, SCREENWIDTH, 475)];
    viewWhite.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewWhite];
    
    UIView *viewTitleClose = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    viewTitleClose.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:249/255.0 alpha:1.0];
    [viewWhite addSubview:viewTitleClose];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 35)];
    [btnClose addTarget:self action:@selector(btnCloseViewDate) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setImage:[UIImage imageNamed:@"close_range"] forState:UIControlStateNormal];
    [viewTitleClose addSubview:btnClose];
    
    UIView *viewTitleBg = [[UIView alloc] init];
    viewTitleBg.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:249/255.0 alpha:1.0];
    [viewWhite addSubview:viewTitleBg];
    [viewTitleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewTitleClose.mas_bottom);
        make.left.right.width.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    FSCalendar *calendar = [[FSCalendar alloc] init];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = YES; // 翻页
    calendar.allowsMultipleSelection = YES;
    calendar.rowHeight = 60;
//    calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail; // 日历显示类型 六行
    calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;  // 横行滑动
    [viewWhite addSubview:calendar];
    self.calendar = calendar;
    self.calendar.appearance.separators = FSCalendarSeparatorInterRows; // 横线
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
//    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    calendar.appearance.titleDefaultColor = [UIColor blackColor]; // 日历 文字颜色
    calendar.appearance.headerTitleColor = [UIColor blackColor]; // 标题颜色
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.weekdayHeight = 50; // 星期 的高度
    calendar.appearance.weekdayTextColor = [UIColor blackColor]; // 星期 字体颜色
    
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.today = nil; // Hide the today circle
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(viewTitleClose.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(390);
    }];
    
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [previousButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewWhite addSubview:previousButton];
    [previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(calendar.mas_top);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(44);
    }];
             
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton setImage:[UIImage imageNamed:@"time_right"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewWhite addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(calendar.mas_top);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(44);
    }];
    
    
    self.btnReset = [[UIButton alloc] init];
    [self.btnReset setTitle:@"重置" forState:UIControlStateNormal];
    [self.btnReset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnReset setBackgroundColor:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]];
    [self.btnReset addTarget:self action:@selector(btnResetClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewWhite addSubview:self.btnReset];
    [self.btnReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(calendar.mas_bottom);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(138);
    }];
           
           
    self.btnSure = [[UIButton alloc] init];
    [self.btnSure setTitle:@"确认" forState:UIControlStateNormal];
    [self.btnSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSure setBackgroundImage:[UIImage imageNamed:@"singOut"] forState:UIControlStateNormal];
    [self.btnSure addTarget:self action:@selector(btnSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewWhite addSubview:self.btnSure];
    [self.btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(calendar.mas_right);
        make.top.mas_equalTo(calendar.mas_bottom);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(self.btnReset.mas_right);
    }];
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.calendar.accessibilityIdentifier = @"calendar";
}


#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"1986-01-01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:50 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
        if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = date;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }
    }
    
    [self configureVisibleCells];
    
    if (self.date2) {
        strFisrt = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.date1]];
        strLast = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.date2]];
    }else{
        strFisrt = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.date1]];
    }
    NSLog(@"did select date %@    %@",strFisrt,strLast);

}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
}

#pragma mark - btn click
-(void)btnResetClick:(UIButton *)sender{
    NSLog(@"重置");
    if (strLast.length>0) {
        [self.calendar deselectDate:self.date1];
        [self.calendar deselectDate:self.date2];
        strFisrt = @"";
        strLast = @"";
        self.date1= nil;
        self.date2 = nil;
    }else{
        [self.calendar deselectDate:self.date1];
        strFisrt = @"";
        self.date1= nil;
    }

    [self.calendar reloadData];
}
-(void)btnSureClick:(UIButton *)sender{
    NSLog(@"确认 开始:%@   结束:%@",strFisrt,strLast);
    if (_delegate && [_delegate respondsToSelector:@selector(AktRangePickerViewFirstDate:LastDate:)]) {
         [self.delegate AktRangePickerViewFirstDate:strFisrt LastDate:strLast];
    }
}
- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

-(void)btnCloseViewDate{
    if (_delegate && [_delegate respondsToSelector:@selector(AktRangePickerViewFirstDate:LastDate:)]) {
            [self.delegate AktRangePickerViewFirstDate:strFisrt LastDate:strLast];
       }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
