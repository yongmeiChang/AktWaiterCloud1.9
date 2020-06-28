//
//  MineServiceController.m
//  TianXiaJianKang
//
//  Created by bea on 2018/1/9.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import "CalendarSearchController.h"
#import "FSCalendar.h"
@interface CalendarSearchController ()<FSCalendarDelegateAppearance,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource>{
    NSString *postDate;
    BOOL ishidden;
    int index;//判断数据源
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSArray * dataArray;//模拟后台数据
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@end

@implementation CalendarSearchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    ishidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    //移除观察者 _observe
    [[NSNotificationCenter defaultCenter] removeObserver:_observe];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([ReachbilityTool.internetStatus isEqualToString:@"notReachable"]){
        [self.view bringSubviewToFront:self.netWorkErrorView];
    }else{
        [self.view sendSubviewToBack:self.netWorkErrorView];
    }
    //弱引用用于block
    __weak CalendarSearchController * mc = self;
    self.topConstant.constant = [[UIApplication sharedApplication] statusBarFrame].size.height +   self.navigationController.navigationBar.frame.size.height;
    
    _observe = [[NSNotificationCenter defaultCenter] addObserverForName:@"click" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
    }];
    
    self.calendar.hidden = YES;
    //self.view.backgroundColor = RGB(243.0, 243.0, 243.0);
    [self setNavTitle: @"待完成任务"];
    ishidden = NO;
    index = 1;
    //异步执行 防止卡顿
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initWithNavLeftImageName:@"logo" RightImageName:@"calendar"];
        [self initCalender];
        self.tableview.layer.shadowOpacity = 0.56f;
        self.tableview.layer.shadowRadius = 4.f;
        self.tableview.layer.shadowOffset = CGSizeMake(0,0);
        self.tableview.layer.shadowColor = RGB(198,198,198).CGColor;
        
        self.calendar.layer.shadowOpacity = 0.56f;
        self.calendar.layer.shadowRadius = 4.f;
        self.calendar.layer.shadowOffset = CGSizeMake(0,0);
        self.calendar.layer.shadowColor = RGB(198,198,198).CGColor;
    });

    //self.calendar.hidden = true;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    LRRegisterNibsQuick(self.tableview, @[@"NewServiceCell"]);
}

//上拉动画
-(void)upLayoutAnimate{
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1
          initialSpringVelocity:4.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
                         CGPoint point = self.calendar.center;
                         point.y = -rectStatus.size.height-self.navigationController.navigationBar.frame.size.height-self.calendar.frame.size.height*0.4;
                         [self.calendar setCenter:point];
                         
                     } completion:^(BOOL finished) {
                         // 动画完成后执行
                         [self.calendar setAlpha:1];
                         [self.tableview reloadData];
                     }];
}

//下拉动画
-(void)downLayoutAnimate{
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1
          initialSpringVelocity:3.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
                         CGPoint point = self.calendar.center;
                         point.y = rectStatus.size.height+self.navigationController.navigationBar.frame.size.height+SCREEN_HEIGHT*0.4*0.5;
                         [self.calendar setCenter:point];
                         
                     } completion:^(BOOL finished) {
                         // 动画完成后执行
                         [self.calendar setAlpha:1];
                     }];
}

#pragma mark -- 初始化日历控件
-(void)initCalender{
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.firstWeekday = 2;     //设置周一为第一天
    _calendar.appearance.weekdayTextColor = [UIColor blackColor];
    _calendar.appearance.weekdayFont = [UIFont systemFontOfSize:18];
    _calendar.appearance.headerTitleColor = [UIColor darkGrayColor];
    _calendar.appearance.titleDefaultColor = [UIColor darkGrayColor];
    _calendar.appearance.titleFont = [UIFont systemFontOfSize:18];
    //        _calendar.appearance.subtitleDefaultColor = [UIColor greenColor];
    //_calendar.appearance.eventSelectionColor = [UIColor lightGrayColor];
    //_calendar.appearance.selectionColor = [UIColor redColor];
    _calendar.appearance.eventDefaultColor = [UIColor colorWithHexString:@"#900000"];//事件点的颜色
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    _calendar.appearance.todayColor = nil;//今日的颜色
    _calendar.appearance.borderRadius = 1.0;  // 设置当前选择是圆形,0.0是正方形
    _calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    _calendar.backgroundColor = [UIColor whiteColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _calendar.locale = locale;  // 设置周次是中文显示
    //[_calendar selectDate:[NSDate date]]; // 设置默认选中日期是今天
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone; //月份模式时，只显示当前月份
}

//日历点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    NSLog(@"选择查看了====%@",[dateFormatter stringFromDate:date]);
    [self RightBarClick];
    self.dataArray = [NSArray array];
    [self.tableview reloadData];
}

#pragma mark FSCalendarDelegateAppearance
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * orderStr = @"";
    for(OrderInfo * order in self.dataArray){
        orderStr = order.serviceDate;
        NSDate *orderDate = [formatter dateFromString:orderStr];
        if([date isEqualToDate:orderDate]){
//            calendar.appearance.eventDefaultColor = [UIColor colorWithHexString:@"#1878C0"];
            //日期上的按钮背景色
            UIColor * color = [UIColor colorWithHexString:@"#1878C0"];
            return color;
        }else{
            return nil;
        }
    }
    return nil;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * str = [formatter stringFromDate:date];

    return nil;
}

//- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
//
//}
//
//- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
//}

//显示下面的事件点的数量
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strTest = @"2018-03-07";
    NSDate * bdate = [formatter dateFromString:strTest];
    //_calendar.appearance.eventDefaultColor = [UIColor greenColor];
    if([date isEqualToDate:bdate]){
        return 1;
    }
    return 0;
}

//无数据页面点击事件
-(void)labelClick{
    
}

-(void)RightBarClick{
    NSLog(@"点击成功");
    if(ishidden){
        self.calendar.hidden = NO;
        [self downLayoutAnimate];
        ishidden = NO;
    }else{
        [self upLayoutAnimate];
        ishidden = YES;
    }
}

#pragma mark ====tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//如果要动态修改高度，必须实现此方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

@end
