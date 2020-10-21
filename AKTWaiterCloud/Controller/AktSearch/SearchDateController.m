//
//  SearchDateController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/21.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "SearchDateController.h"
#import "AktRangePickerView.h"

@interface SearchDateController ()<AktRangePickerViewDelegate>{
    int selectindex;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentday;
    NSInteger hour;
    NSInteger minute;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    NSString *selectecDay;
    NSString *strhour;
    NSString *strminute;
}
@property (nonatomic,strong) NSMutableArray * dataArray;//数据源（目前2行为 开始、结束日期选择）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topviewLayout;//顶部视图的topLayout

@property(nonatomic,strong) NSString * Date;//给后台
@property(nonatomic,strong) NSString * bTime;//给后台
@property(nonatomic,strong) NSString * eTime;//给后台
@property(nonatomic,assign) int dateType;//1开始时间 2结束时间
@property (weak, nonatomic) IBOutlet UIButton *btnsearch;

@property (weak, nonatomic) IBOutlet UIButton *btnToday;
@property (weak, nonatomic) IBOutlet UIButton *btnToWeek;
@property (weak, nonatomic) IBOutlet UIButton *btnToMounth;
@property (weak, nonatomic) IBOutlet UILabel *labStartData;
@property (weak, nonatomic) IBOutlet UILabel *labEndData;
@property (nonatomic, strong) AktRangePickerView *rangPickerView;


@end

@implementation SearchDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B1"); 
    //初始化日期选择器的内容
    [self setTitle:@"筛选日期"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    self.netWorkErrorView.hidden = YES;
    
    if (self.typeVC == 0) {
        [self.btnsearch setTitle:@"搜索" forState:UIControlStateNormal];
    }else{
        [self.btnsearch setTitle:@"确认" forState:UIControlStateNormal];
    }
    // 日期时间选择
    self.rangPickerView = [[AktRangePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.rangPickerView.delegate = self;
    self.rangPickerView.minimumDate = _mindate;
    self.rangPickerView.maximumDate = _maxdate;
    self.rangPickerView.tag = 106;
}

-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - btn click

- (IBAction)selectStartDataTimeClick:(UIButton *)sender {
    selectindex = 0;
    self.dateType = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:self.rangPickerView];
}
- (IBAction)selectEndDataTimeClick:(UIButton *)sender {
    selectindex = 1;
    self.dateType = 2;
    [[UIApplication sharedApplication].keyWindow addSubview:self.rangPickerView];

}

#pragma mark - 比较日期大小
-(int)compareDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *bdate = [formatter dateFromString:_bTime];
    NSDate *edate = [formatter dateFromString:_eTime];
    NSComparisonResult result = [bdate compare:edate];
    NSLog(@"date1 : %@, date2 : %@", bdate, edate);
    //1 a>b  0 a=b  -1 a<b
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
}

#pragma mark - click
//头部的3个快捷按钮点击事件
-(IBAction)clickTopBtn:(id)sender{
    UIButton * btn = (UIButton *)sender;
    btn.selected =!btn.selected;
    if (btn.tag ==1) {
        _btnToday.selected = btn.selected;
        _btnToWeek.selected = !btn.selected;
        _btnToMounth.selected = !btn.selected;
    }else if(btn.tag == 2){
        _btnToday.selected = !btn.selected;
        _btnToWeek.selected = btn.selected;
        _btnToMounth.selected = !btn.selected;
    }else{
        _btnToday.selected = !btn.selected;
        _btnToWeek.selected = !btn.selected;
        _btnToMounth.selected = btn.selected;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate * tdate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString * y;
    NSString * m;
    NSString * d;
    if(btn.tag == 1){    //今天
        NSString * str = [formatter stringFromDate:tdate];
        NSArray * arr = [str componentsSeparatedByString:@"-"];
        for(int i = 0; i< arr.count; i++){
            if(i==0){
                y  = [NSString stringWithFormat:@"%@",arr[i]];
            }else if(i==1){
                m  = [NSString stringWithFormat:@"%@",arr[i]];
            }else if(i==2){
                d  = [NSString stringWithFormat:@"%@",arr[i]];
            }
        }
        _bTime = [NSString stringWithFormat:@"%@-%@-%@ 00:00:00",y,m,d];
        _eTime = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59",y,m,d];
        
    }else if(btn.tag == 2){    //本周
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                             fromDate:now];
        
        // 得到星期几
        // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
        NSInteger weekDay = [comp weekday];
        // 得到几号
        NSInteger day = [comp day];
        
        NSLog(@"weekDay:%ld   day:%ld",(long)weekDay,(long)day);
        
        // 计算当前日期和这周的星期一和星期天差的天数
        long firstDiff,lastDiff;
        if (weekDay == 1) {
            firstDiff = 1;
            lastDiff = 0;
        }else{
            firstDiff = [calendar firstWeekday] - weekDay;
            lastDiff = 9 - weekDay;
        }
        
        NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
        
        // 在当前日期(去掉了时分秒)基础上加上差的天数
        NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        [firstDayComp setDay:day + firstDiff];
        NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
        
        NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        [lastDayComp setDay:day + lastDiff];
        NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
        NSLog(@"当前 %@",[formater stringFromDate:now]);
        NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:lastDayOfWeek];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * str = [formater stringFromDate:lastDay];
        str = [[str componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString * lastdayStr = [NSString stringWithFormat:@"%@ 23:59:59", str];
        _bTime =[formater stringFromDate:firstDayOfWeek];
        _eTime =lastdayStr;
    }else if(btn.tag == 3){    //本月
        NSString * str = [formatter stringFromDate:tdate];
        NSArray * arr = [str componentsSeparatedByString:@"-"];
        for(int i = 0; i< arr.count; i++){
            if(i==0){
                y  = [NSString stringWithFormat:@"%@",arr[i]];
            }else if(i==1){
                m  = [NSString stringWithFormat:@"%@",arr[i]];
            }else if(i==2){
                d  = [NSString stringWithFormat:@"%@",arr[i]];
            }
        }
        _bTime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",y,m];
        if([m isEqualToString:@"1"]||[m isEqualToString:@"3"]||[m isEqualToString:@"5"]||[m isEqualToString:@"7"]||[m isEqualToString:@"8"]||[m isEqualToString:@"10"]||[m isEqualToString:@"12"]){
            _eTime = [NSString stringWithFormat:@"%@-%@-31 23:59:59",y,m];
        }else if([m isEqualToString:@"2"]){
            _eTime = [NSString stringWithFormat:@"%@-%@-28 23:59:59",y,m];
        }else{
            _eTime = [NSString stringWithFormat:@"%@-%@-30 23:59:59",y,m];
        }

    }
    
    self.labStartData.text = _bTime;
    self.labEndData.text = _eTime;
}
#pragma mark - search click
- (IBAction)submitBtnClick:(UIButton *)sender {

    if(!_bTime){
        [self showMessageAlertWithController:self Message:@"请输入开始时间"];
        return;
    }
    if([_bTime isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入开始时间"];
        return;
    }
    if(!_eTime){
        [self showMessageAlertWithController:self Message:@"请输入结束时间"];
        return;
    }
    if([_eTime isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入结束时间"];
        return;
    }
    if([self compareDate]==1){
        [self showMessageAlertWithController:self Message:@"开始日期必须小于结束日期"];
        return;
    }
    NSArray *barray = [self.bTime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString * bdatetime = barray[0];
    NSArray *earray = [self.eTime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString *edatetime = earray[0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchDateVC" object:@{@"beginDate":bdatetime,@"endDate":edatetime} userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - rangePickerView delegate
-(void)AktRangePickerViewFirstDate:(NSString *)firstdate LastDate:(NSString *)lastdate{
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:106] removeFromSuperview];

    _bTime = [NSString stringWithFormat:@"%@ 00:00:00",firstdate];
    _eTime = [NSString stringWithFormat:@"%@ 23:59:59",lastdate];
    
    if (firstdate.length>1 && lastdate.length>1) {
        self.labStartData.text = _bTime;
        self.labEndData.text = _eTime;
    }else{
        self.labStartData.text = @"请选择时间";
        self.labEndData.text = @"请选择时间";
    }
}


@end
