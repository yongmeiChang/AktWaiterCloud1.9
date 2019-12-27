//
//  PlanTaskController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

//#import "PlanTaskController.h"
//#import <FSCalendar.h>
//@interface PlanTaskController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating,FSCalendarDelegateAppearance>
#import "PlanTaskController.h"
#import "OrderTaskFmdb.h"
#import "PlanTaskCell.h"
#import <MJRefresh.h>
#import <FSCalendar.h>
#import "MinuteTaskController.h"
@interface PlanTaskController ()<UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>{
    int pageSize;
    BOOL ishidden;
    int tableviewtype;//是显示全部数据还是某天数据  0全部 1某天
}
@property(weak,nonatomic) IBOutlet UITableView * taskTableview;
@property(nonatomic,strong) NSMutableArray * dataArray;//数据源
@property(nonatomic,strong) NSMutableArray * dateArray;//日历选中某天的数据源

@property(nonatomic,strong) OrderTaskFmdb * orderfmdb;

@property(nonatomic,assign) long pagecount;//分页最大值
@property(nonatomic,assign) int requestype;//0下拉 1上拉

@property(nonatomic,strong) MJRefreshAutoGifFooter *footer;
@property(nonatomic,strong) MJRefreshGifHeader * header;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@end

@implementation PlanTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTaskTableView];
    [self initCalender];
    self.calendar.hidden = YES;
    pageSize = 1;
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.taskTableview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
    [self initWithNavLeftImageName:@"" RightImageName:@"calendar"];
    self.navigationItem.title = @"计划";
    self.dataArray = [NSMutableArray array];
    [self checkNetWork];
}

-(void)viewWillAppear:(BOOL)animated{
    DDLogInfo(@"点击了待办任务item");
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    ishidden = YES;
    if(appDelegate.isclean){
        [self viewDidLoad];
        appDelegate.isclean = false;
    }
    if(appDelegate.planTaskOrderRf){
        appDelegate.planTaskOrderRf = YES;
        pageSize = 0;
        [self requestUnFinishedTask];
    }
}


#pragma mark - 初始化日历控件
-(void)initCalender{
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.firstWeekday = 2;     //设置周一为第一天
    _calendar.appearance.weekdayTextColor = [UIColor blackColor];
    _calendar.appearance.weekdayFont = [UIFont systemFontOfSize:18];
    _calendar.appearance.headerTitleColor = [UIColor darkGrayColor];
    _calendar.appearance.titleDefaultColor = [UIColor darkGrayColor];
    _calendar.appearance.titleFont = [UIFont systemFontOfSize:18];
    //_calendar.appearance.subtitleDefaultColor = [UIColor greenColor];
    _calendar.appearance.eventDefaultColor = [UIColor colorWithHexString:@"#900000"];//事件点的颜色
    //_calendar.appearance.eventSelectionColor = [UIColor lightGrayColor];
    //_calendar.appearance.selectionColor = [UIColor whiteColor];//点击日期的颜色
    _calendar.appearance.titleSelectionColor = [UIColor darkGrayColor];//点击日期的字体颜色
    //_calendar.appearance.todaySelectionColor = [UIColor blueColor];
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
//    _calendar.appearance.todayColor = [UIColor colorWithHexString:@"#1878C0"];//今日的颜色
    _calendar.appearance.todayColor = nil;//今日的颜色
    _calendar.appearance.titleTodayColor = [UIColor lightGrayColor];
    _calendar.appearance.borderRadius = 1.0;  // 设置当前选择是圆形,0.0是正方形
    _calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    _calendar.backgroundColor = [UIColor whiteColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _calendar.locale = locale;  // 设置周次是中文显示
    //[_calendar selectDate:[NSDate date]]; // 设置默认选中日期是今天
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone; //月份模式时，只显示当前月份
    
    UIButton *showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showAllBtn.frame = CGRectMake(SCREEN_WIDTH-105, 5, 95, 34);
    //showAllBtn.backgroundColor = [UIColor colorWithHexString:@"#1878C0"];
    [showAllBtn setTitle:@"显示全部" forState:UIControlStateNormal];
    [showAllBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    showAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [previousButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [showAllBtn addTarget:self action:@selector(showAllBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendar addSubview:showAllBtn];
}

- (void)showAllBtnClicked:(id)sender
{
    tableviewtype = 0;
    [self RightBarClick];
    [self.taskTableview reloadData];
}


-(void)initTaskTableView{
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    //去除没有数据时的分割线
    self.taskTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //去除右侧滚动条
    self.taskTableview.showsVerticalScrollIndicator = NO;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [_header setTitle:@"按住下拉" forState:MJRefreshStateIdle];
    [_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片 (idleImages 是图片)
    [_header setImages:self.imageArrs forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //[_header setImages:self.imageArrs forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [_header setImages:self.imageArrs forState:MJRefreshStateRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置刷新图片
    //[footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [_footer setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
    _footer.triggerAutomaticallyRefreshPercent = 50.0;
    self.taskTableview.mj_header = _header;
    self.taskTableview.mj_footer = _footer;
}

-(void)loadMoreData{
    if(pageSize==_pagecount){
        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        [self.taskTableview.mj_footer endRefreshing];
        [_footer endRefreshingWithNoMoreData];
        return;
    }
    [self.taskTableview.mj_footer beginRefreshing];
    self.requestype = 1;

    [self checkNetWork];
}

-(void)loadNewData{
    [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    // 马上进入刷新状态
    [self.taskTableview.mj_header beginRefreshing];
    self.requestype = 0;
    [self checkNetWork];
}

-(void)checkNetWork{
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        if([appDelegate.userinfo.isclickOff_line isEqualToString:@"0"]){
            if(appDelegate.netWorkType==Off_line){
                [self showMessageAlertWithController:self Message:ContinueError];
            }else{
                [self showMessageAlertWithController:self Message:LoadingError];
            }
            appDelegate.netWorkType = Off_line;
            self.orderfmdb = [[OrderTaskFmdb alloc] init];
            _dataArray = [self.orderfmdb findAllOrderInfo];
            if(_dataArray.count==0){
                self.netWorkErrorView.hidden = NO;
            }else{
                self.netWorkErrorView.hidden = YES;
                [self.taskTableview reloadData];
            }
        }else{
            [self showMessageAlertWithController:self Message:NetWorkMessage];
        }
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setStatus:Loading];
        [self requestUnFinishedTask];
    }
}

-(void)RightBarClick{
    if(ishidden){
        self.calendar.hidden = NO;
        [self downLayoutAnimate];
        ishidden = NO;
    }else{
        [self upLayoutAnimate];
        ishidden = YES;
    }
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
                         [self.taskTableview reloadData];
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

-(void)requestUnFinishedTask{
    //记录上拉加载的分页
    pageSize++;
    NSString * pagenum = @"0";
    if(self.requestype == 0){
        pageSize=1;
        pagenum = [NSString stringWithFormat:@"%d",pageSize];
        [self.dataArray removeAllObjects];
        [_footer resetNoMoreData];
    }
    if(self.requestype == 1){
        pagenum = [NSString stringWithFormat:@"%d",pageSize];
    }
    tableviewtype=0;
    NSDictionary * parameters =@{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"pageNumber":pagenum};
    [[AFNetWorkingRequest sharedTool] requesttoBeHandle:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = [dic objectForKey:@"message"];
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            NSDictionary * obj = [dic objectForKey:@"object"];
            NSNumber * pages = obj[@"pages"];
            _pagecount = [pages longValue];
            arr = obj[@"result"];
            
            if([message isEqualToString:@"当前没有工单任务!"]){
                [self showOffLineAlertWithTime:1.0  message:@"当前没有工单任务!" DoSomethingBlock:^{
                    self.netWorkErrorView.hidden = NO;
                    self.netWorkErrorView.userInteractionEnabled = YES;
                }];
            }else{
                if(arr&&arr.count>0){
                    self.taskTableview.hidden = NO;
                    self.netWorkErrorView.hidden = YES;
                    NSMutableArray * editArray =[NSMutableArray array];

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
                        self.orderfmdb = [[OrderTaskFmdb alloc]init];
                        OrderInfo * orderinfo;
                        orderinfo = [self.orderfmdb findByWorkNo:[objdic objectForKey:@"workNo"]];
                        if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil){
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            if([orderinfo.workStatus isEqualToString:@"11"]){
                                [editArray addObject:orderinfo];
                            }else{
                                [_dataArray addObject:orderinfo];
                            }
                            orderinfo.tid = orderinfo.id;
                            [self.orderfmdb saveOrderTask:orderinfo];
                        }else{
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            if([orderinfo.workStatus isEqualToString:@"11"]){
                                [editArray addObject:orderinfo];
                            }else{
                                [_dataArray addObject:orderinfo];
                            }
                            orderinfo.tid = orderinfo.id;
                            [self.orderfmdb updateObject:orderinfo];
                        }
                    }
                    if(editArray.count>0){
                        for(int i = 0; i< editArray.count; i++){
                            [_dataArray insertObject:editArray[i] atIndex:i];
                        }
                    }
                    [self.taskTableview reloadData];
                }else{
                    if(self.requestype==1){
                        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
                    }else{
                        [self showMessageAlertWithController:self Message:@"暂无数据"];
                        self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
                        self.netWorkErrorView.hidden = NO;
                        [SVProgressHUD dismiss];
                        self.netWorkErrorView.userInteractionEnabled = YES;
                    }
                }
            }
            if(pageSize ==_pagecount){
                [_footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
                [_footer endRefreshing];
            }
        }else{
            self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
            [self showMessageAlertWithController:self Message:@"暂无数据"];
            self.taskTableview.hidden = YES;
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }
        if(appDelegate.netWorkType == Off_line){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showOffLineAlertWithTime:0.7  message:NetWorkSuccess DoSomethingBlock:^{
                }];
                appDelegate.netWorkType = On_line;
            });
        }
        [SVProgressHUD dismiss];
        [self.calendar reloadData];
        if(self.requestype == 0){
            [self.taskTableview.mj_header endRefreshing];
        }else{
            [self.taskTableview.mj_footer endRefreshing];
        }
        self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
    }
    failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.calendar reloadData];
        self.netWorkErrorView.userInteractionEnabled = YES;
        self.netWorkErrorView.hidden = NO;
        if(self.requestype == 0){
            [self.taskTableview.mj_header endRefreshing];
        }else{
            [self.taskTableview.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 比较日期
- (void)compareNsdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (OrderInfo * info in _dataArray) {
        NSDate *date = [formatter dateFromString:info.serviceDate];
        [tempArray addObject:date];
    }
    [tempArray sortUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
        return [date2 compare:date1];
    }];
}

-(void)labelClick{
    
    pageSize=0;
    DDLogInfo(@"点击了刷新按钮");
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        if([appDelegate.userinfo.isclickOff_line isEqualToString:@"0"]){
            if(appDelegate.netWorkType==Off_line){
                [self showMessageAlertWithController:self title:@"提示" Message:ContinueError canelBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }else{
                [self showMessageAlertWithController:self title:@"提示" Message:LoadingError canelBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }
            appDelegate.netWorkType = Off_line;
            return;
        }else{
            [self showMessageAlertWithController:self Message:@"网络状态不佳,请稍后再试!"];
        }
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:Loading];
    self.netWorkErrorLabel.text = Loading;
    pageSize = 0;
    [self requestUnFinishedTask];
    self.netWorkErrorView.userInteractionEnabled = false;
}

#pragma mark ==========tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableviewtype==0){
        return _dataArray.count;
    }else{
        return _dateArray.count;
    }
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(SCREEN_WIDTH<375){
        return 190.0f;
        }else{
            return 220.0f;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0;
    }
    return 20.0f;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"PlanTaskCell";
    PlanTaskCell *cell = (PlanTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    NSArray * arr = [NSArray array];
    if(tableviewtype==0){
        arr = _dataArray;
    }else{
        arr = _dateArray;
    }
    if(arr.count>0){
        OrderInfo * orderinfo = arr[indexPath.section];
        [cell setOrderList:orderinfo];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfo * orderinfo = [_dataArray objectAtIndex:indexPath.section];
    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc]initMinuteTaskControllerwithOrderInfo:self.dataArray[indexPath.section]];
    minuteTaskContoller.type = @"2";
    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:minuteTaskContoller animated:YES];
}

-(void)ClickName:(id)sender{
    UIButton * btn = (UIButton*)sender;
    NSInteger tag = btn.tag;
    OrderInfo * orderinfo = _dataArray[tag-1];
    NSDictionary * param = @{@"customerId":orderinfo.customerId,@"customerName":orderinfo.customerName,@"tenantsId":appDelegate.userinfo.tenantsId};
    [[AFNetWorkingRequest sharedTool] requestWithGetCustomerBalanceParameters:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        NSString * message = @"";
        if([code intValue] == 2){
            message = [dic objectForKey:@"message"];
            [self showMessageAlertWithController:self Message:message];
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark FSCalendarDelegateAppearance
//日历点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    NSLog(@"选择查看了====%@",[dateFormatter stringFromDate:date]);

    [self RightBarClick];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateArray = [NSMutableArray array];
    for(OrderInfo * info in self.dataArray){
        if([dateStr isEqualToString:info.serviceDate]){
            [self.dateArray addObject:info];
        }
    }
    tableviewtype = 1;
    if(self.dateArray.count==0){
        [self showMessageAlertWithController:self Message:@"当日无工单"];
        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
    }else{
        [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    }
    [self.taskTableview reloadData];
}

//在未选中的状态中填写特定日期的填充颜色
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
            continue;
        }
    }
    return nil;
}

//显示下面的事件点的数量
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [formatter stringFromDate:date];
    int count = 0;
    for(OrderInfo * info in self.dataArray){
        if([dateStr isEqualToString:info.serviceDate]){
            count++;
        }
    }
    //_calendar.appearance.eventDefaultColor = [UIColor greenColor];
    if(count>3){
        return 3;
    }
    return count;
}

//每次切换月份日期时的事件
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"did change to page %@",[formatter stringFromDate:calendar.currentPage]);
}
@end
