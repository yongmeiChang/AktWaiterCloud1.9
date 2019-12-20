//
//  SearchDateController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/21.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "SearchDateController.h"
#import "SearchDateCell.h"
#import "FilterController.h"
@interface SearchDateController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
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

@property (nonatomic,strong) UIPickerView * datePickView;//日期选择器
@property (nonatomic,strong) UIView * bottomView;//日期选择器顶部视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topviewLayout;//顶部视图的topLayout

@property(nonatomic,strong) NSMutableArray * yearArr;
@property(nonatomic,strong) NSMutableArray * monthArr;
@property(nonatomic,strong) NSMutableArray * dayArr;
@property(nonatomic,strong) NSMutableArray * AllArr;

@property(nonatomic,strong) NSMutableArray * hourArr;
@property(nonatomic,strong) NSMutableArray * minuteArr;
@property(nonatomic,strong) NSMutableArray * hmAllArr;


@property(nonatomic,strong) NSString * Date;//给后台
@property(nonatomic,strong) NSString * bTime;//给后台
@property(nonatomic,strong) NSString * eTime;//给后台
@property(nonatomic,strong) NSString * serviceDate;//服务日期
@property(nonatomic,strong) NSString * serviceBeginTime;//服务开始时间
@property(nonatomic,strong) NSString * serviceEndTime;//服务结束时间

@property(nonatomic,assign) int dateType;//1开始时间 2结束时间

@property (weak, nonatomic) IBOutlet UIButton *btnToday;
@property (weak, nonatomic) IBOutlet UIButton *btnToWeek;
@property (weak, nonatomic) IBOutlet UIButton *btnToMounth;
@property (weak, nonatomic) IBOutlet UILabel *labStartData;
@property (weak, nonatomic) IBOutlet UILabel *labEndData;



@end

@implementation SearchDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B1");
    self.topviewLayout.constant = AktNavAndStatusHight;
    //初始化日期选择器的内容
    [self initDateArray];
    [self initDateBeginTime];
    [self initDataPicker];
    [self setTitle:@"筛选日期"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
  
    self.bottomView.hidden = YES;
    self.datePickView.hidden = YES;
    self.netWorkErrorView.hidden = YES;
}

-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview delegate
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"SearchDateCell";
    SearchDateCell *cell = (SearchDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchDateCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if(indexPath.row==0){
        cell.leftlabel.text = @"开始时间";
        cell.datelabel.text = _bTime;
    }else if(indexPath.row==1){
        cell.leftlabel.text = @"结束时间";
        cell.datelabel.text = _eTime;
    }
    
    return cell;
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    selectindex = (int)row;
    if(indexPath.row==0){
        self.dateType = 1;
    }
    if(indexPath.row==1){
        self.dateType = 2;
    }
    self.bottomView.hidden = NO;
    self.datePickView.hidden = NO;
 
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark - btn click

- (IBAction)selectStartDataTimeClick:(UIButton *)sender {
    selectindex = 0;
    self.dateType = 1;
    self.bottomView.hidden = NO;
    self.datePickView.hidden = NO;
}
- (IBAction)selectEndDataTimeClick:(UIButton *)sender {
    selectindex = 1;
    self.dateType = 2;
    self.bottomView.hidden = NO;
    self.datePickView.hidden = NO;
}

#pragma mark - init date
-(void)initDateArray{
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 3) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
        currentday = [dateArray[2] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
    selectecDay = [NSString stringWithFormat:@"%ld",(long)currentday];
    //初始化年数据源数组
    _yearArr = [[NSMutableArray alloc]init];
    for (NSInteger i = currentYear; i <= 2099 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)i];
        [_yearArr addObject:yearStr];
    }
    
    _monthArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
        [_monthArr addObject:monthStr];
    }
    
    _dayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 30; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld日",(long)i];
        [_dayArr addObject:dayStr];
    }
    _AllArr = [NSMutableArray arrayWithCapacity:3];
    [_AllArr addObject:_yearArr];
    [_AllArr addObject:_monthArr];
    [_AllArr addObject:_dayArr];
}

-(void)initDataPicker{
    _datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-SCREEN_HEIGHT/2-165 , SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    _datePickView.showsSelectionIndicator = YES;
    _datePickView.backgroundColor = [UIColor whiteColor];
    _datePickView.alpha = 1;
    _datePickView.delegate = self;
    [_datePickView selectRow:0 inComponent:0 animated:NO];
    [_datePickView selectRow:currentMonth-1 inComponent:1 animated:NO];
    [_datePickView selectRow:currentday-1 inComponent:2 animated:NO];
    [_datePickView selectRow:hour inComponent:3 animated:NO];
    [_datePickView selectRow:minute inComponent:4 animated:NO];
    
    [self.view addSubview:_datePickView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-165 , SCREEN_WIDTH, SCREEN_HEIGHT/4)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIButton * canelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 40)];
    
    UIButton * okBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2-20, 5, 100, 40)];
    [_bottomView addSubview:canelBtn];
    [_bottomView addSubview:okBtn];

//    canelBtn.layer.cornerRadius =10.0f;
//    okBtn.layer.cornerRadius =10.0f;

    [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canelBtn addTarget:self action:@selector(canelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"]
        forState:UIControlStateNormal];
    [self.view addSubview:_bottomView];
    
    [_datePickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT/4);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.datePickView.mas_top).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [canelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5-5);
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.equalTo(canelBtn.mas_right).offset(5);
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(0);
        make.height.mas_equalTo(40);
    }];
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
-(void)canelBtnClick{
    self.datePickView.hidden = YES;
    self.bottomView.hidden = YES;
}

-(void)okBtnClick{
    self.datePickView.hidden = YES;
    self.bottomView.hidden = YES;
    if(_dateType==1){
        NSInteger yrow=[_datePickView selectedRowInComponent:0];
        NSString *subStringYear=[_yearArr objectAtIndex:yrow];
        NSString * year = [subStringYear substringToIndex:[subStringYear length] - 1];
        
        NSInteger mrow=[_datePickView selectedRowInComponent:1];
        NSString *subStringMonth=[_monthArr objectAtIndex:mrow];
        NSString *month = [subStringMonth substringToIndex:[subStringMonth length] - 1];
        
        NSInteger drow=[_datePickView selectedRowInComponent:2];
        NSString *subStringDay=[_dayArr objectAtIndex:drow];
        NSString * day = [subStringDay substringToIndex:[subStringDay length] - 1];
        
        NSInteger hrow=[_datePickView selectedRowInComponent:3];
        NSString *subStringHour=[_hourArr objectAtIndex:hrow];
        NSString *hours =[subStringHour substringToIndex:[subStringHour length] - 1];
        
        NSInteger minuterow=[_datePickView selectedRowInComponent:4];
        NSString *subStringMinute=[_minuteArr objectAtIndex:minuterow];
        NSString *minutes =[subStringMinute substringToIndex:[subStringMinute length] - 1];
        
        _serviceDate = [NSString stringWithFormat:@"%@%@%@",subStringYear,subStringMonth,subStringDay];
        _Date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
        _serviceBeginTime = [NSString stringWithFormat:@"%@%@%@ %@:%@",subStringYear,subStringMonth,subStringDay,subStringHour,subStringMinute];
        if(month.length==1){
            month = [NSString stringWithFormat:@"0%@",month];
        }
        if(day.length==1){
            day = [NSString stringWithFormat:@"0%@",day];
        }
        _bTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hours,minutes];
        
        NSString * dstr =[[_bTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString * str = [[_bTime componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString * hstr = [[str componentsSeparatedByString:@":"] objectAtIndex:0];
        NSString * mstr = [[str componentsSeparatedByString:@":"] objectAtIndex:1];
        if(hstr.length==1){
            hstr = [NSString stringWithFormat:@"0%@",hstr];
        }
        if(mstr.length==1){
            mstr = [NSString stringWithFormat:@"0%@",mstr];
        }
        _bTime = [NSString stringWithFormat:@"%@ %@:%@:00",dstr,hstr,mstr];
    }else if(_dateType ==2){
        NSInteger yrow=[_datePickView selectedRowInComponent:0];
        NSString *subStringYear=[_yearArr objectAtIndex:yrow];
        NSString * year = [subStringYear substringToIndex:[subStringYear length] - 1];
        
        NSInteger mrow=[_datePickView selectedRowInComponent:1];
        NSString *subStringMonth=[_monthArr objectAtIndex:mrow];
        NSString *month = [subStringMonth substringToIndex:[subStringMonth length] - 1];
        
        NSInteger drow=[_datePickView selectedRowInComponent:2];
        NSString *subStringDay=[_dayArr objectAtIndex:drow];
        NSString * day = [subStringDay substringToIndex:[subStringDay length] - 1];
        
        NSInteger hrow=[_datePickView selectedRowInComponent:3];
        NSString *subStringHour=[_hourArr objectAtIndex:hrow];
        NSString *hours =[subStringHour substringToIndex:[subStringHour length] - 1];
        
        NSInteger minuterow=[_datePickView selectedRowInComponent:4];
        NSString *subStringMinute=[_minuteArr objectAtIndex:minuterow];
        NSString *minutes =[subStringMinute substringToIndex:[subStringMinute length] - 1];
        _serviceEndTime = [NSString stringWithFormat:@"%@%@%@ %@:%@",subStringYear,subStringMonth,subStringDay,subStringHour,subStringMinute];
        if(month.length==1){
            month = [NSString stringWithFormat:@"0%@",month];
        }
        if(day.length==1){
            day = [NSString stringWithFormat:@"0%@",day];
        }
        _eTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hours,minutes];
        
        NSString * dstr =[[_eTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString * str = [[_eTime componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString * hstr = [[str componentsSeparatedByString:@":"] objectAtIndex:0];
        NSString * mstr = [[str componentsSeparatedByString:@":"] objectAtIndex:1];
        if(hstr.length==1){
            hstr = [NSString stringWithFormat:@"0%@",hstr];
        }
        if(mstr.length==1){
            mstr = [NSString stringWithFormat:@"0%@",mstr];
        }
        _eTime = [NSString stringWithFormat:@"%@ %@:%@:00",dstr,hstr,mstr];
    }
    self.labStartData.text = _bTime;
    self.labEndData.text = _eTime;
}


-(void)initDateBeginTime{
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@" "];
    NSString * date = [dateArray objectAtIndex:0];
    //拆分年月成数组
    NSArray *dateArr = [date componentsSeparatedByString:@"-"];
    if (dateArray.count == 3) {//年 月
        currentYear = [[dateArr firstObject]integerValue];
        currentMonth =  [dateArr[1] integerValue];
        currentday = [dateArr[2] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
    selectecDay = [NSString stringWithFormat:@"%ld",(long)currentday];
    
    //初始化年数据源数组
    _yearArr = [[NSMutableArray alloc]init];
    for (NSInteger i = currentYear; i <= 2099 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)i];
        [_yearArr addObject:yearStr];
    }
    
    _monthArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
        [_monthArr addObject:monthStr];
    }
    
    _dayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 30; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld日",(long)i];
        [_dayArr addObject:dayStr];
    }
    
    NSString * da = dateArray[1];
    dateArray = [da componentsSeparatedByString:@":"];
    strhour = [dateArray objectAtIndex:0];
    strminute = [dateArray objectAtIndex:1];
    hour = [strhour integerValue];
    minute = [strminute integerValue];
    
    _hourArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= 23 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld时",(long)i];
        [_hourArr addObject:yearStr];
    }
    
    _minuteArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= 59 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld分",(long)i];
        [_minuteArr addObject:yearStr];
    }
    
    _hmAllArr = [NSMutableArray array];
    [_hmAllArr addObject:_yearArr];
    [_hmAllArr addObject:_monthArr];
    [_hmAllArr addObject:_dayArr];
    [_hmAllArr addObject:_hourArr];
    [_hmAllArr addObject:_minuteArr];
}

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
            _serviceEndTime = [NSString stringWithFormat:@"%@-%@-30 23:59:59",y,m];
            _eTime = _serviceEndTime;
        }

    }
    
    self.labStartData.text = _bTime;
    self.labEndData.text = _eTime;
}
#pragma mark - search click
- (IBAction)submitBtnClick:(UIButton *)sender {
    _datePickView.hidden = YES;
    _bottomView.hidden = YES;
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
    [self requestOrderByDate];
}

-(void)requestOrderByDate{
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        if([appDelegate.userinfo.isclickOff_line isEqualToString:@"0"]){
            if(appDelegate.netWorkType==Off_line){
                [self showMessageAlertWithController:self Message:ContinueError];
            }else{
                [self showMessageAlertWithController:self Message:LoadingError];
            }
            appDelegate.netWorkType = Off_line;
        }else{
            [self showMessageAlertWithController:self Message:NetWorkMessage];
        }
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setStatus:Loading];
    }
    
    NSArray *barray = [self.bTime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString * bdatetime = barray[0];
    NSArray *earray = [self.eTime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString *edatetime = earray[0];
    NSDictionary * parameters =@{@"type":@"done",@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"beginDate":bdatetime,@"endDate":edatetime};
    
    [[AFNetWorkingRequest sharedTool] requestgetWorkListByDay:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            arr = [dic objectForKey:@"object"];
            if(arr&&arr.count>0){
                FilterController * filetcontroller = [[FilterController alloc] init];
                for (NSMutableDictionary * dicc in arr) {
                    NSDictionary * createBydic = [dicc objectForKey:@"createBy"];
                    NSDictionary * updateBydic = [dicc objectForKey:@"updateBy"];
                    NSString * createBy = [createBydic objectForKey:@"id"];
                    NSString * updateBy = [updateBydic objectForKey:@"id"];
                    [dicc removeObjectForKey:@"createBy"];
                    [dicc removeObjectForKey:@"updateBy"];
                    [dicc setObject:createBy forKeyedSubscript:@"createBy"];
                    [dicc setObject:updateBy forKeyedSubscript:@"updateBy"];
                    NSDictionary * objdic = (NSDictionary*)dicc;
                    OrderInfo * orderinfo;
                    orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                    orderinfo.tid = orderinfo.id;
                    
                    filetcontroller.titleStr=@"筛选已完成任务";
                    
                    [filetcontroller.dataArray addObject:orderinfo];
                }
                [self.navigationController pushViewController:filetcontroller animated:YES];
            }else{
                [self showMessageAlertWithController:self Message:@"暂无数据"];
                }
        }else{
            [self showMessageAlertWithController:self Message:@"暂无数据"];
        }
        if(appDelegate.netWorkType == Off_line){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showOffLineAlertWithTime:0.7  message:NetWorkSuccess DoSomethingBlock:^{
                }];
                appDelegate.netWorkType = On_line;
            });
        }
        [SVProgressHUD dismiss];
    }
    failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showMessageAlertWithController:self Message:@"查询错误，请重新操作!"];
    }];
}


#pragma mark - ====pickview代理
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _hmAllArr.count;
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *items = self.hmAllArr[component];
    return items.count;
    
}
// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.hmAllArr[component][row];
}


//滑动事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
}

//重写字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
@end
