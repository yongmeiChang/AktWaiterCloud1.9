//
//  UnfinifshController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/22.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "UnfinifshController.h"
#import "OrderTaskFmdb.h"
#import "PlanTaskCell.h"
#import "MinuteTaskController.h"
#import "SearchDateController.h"
#import <FSCalendar.h>
#import "AKTSearchInfoVC.h"

@interface UnfinifshController ()<UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,AktSearchDelegate>{
    int pageSize;
    BOOL ishidden;
    int tableviewtype;//是显示全部数据还是某天数据  0全部 1某天
     NSString *searchKey;
    NSString *searchAddress; // 服务地址
    NSString *searchBTime; // 服务开始时间
    NSString *searchETime; // 服务结束时间
    NSString *searchWorkNo;// 服务单号
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property(weak,nonatomic) IBOutlet UITableView * taskTableview;
@property(nonatomic,strong) NSMutableArray * dataArray;//数据源
@property(nonatomic,strong) NSMutableArray * dateArray;//日历选中某天的数据源

@property(nonatomic,strong) OrderTaskFmdb * orderfmdb;
@property(nonatomic) int b;


@property(nonatomic,strong) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@end

@implementation UnfinifshController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableTop.constant = AktNavAndStatusHight;
    searchKey = [NSString stringWithFormat:@""];
    searchAddress = [NSString stringWithFormat:@""];
    searchBTime = [NSString stringWithFormat:@""];
    searchETime = [NSString stringWithFormat:@""];
     searchWorkNo = [NSString stringWithFormat:@""];
    
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    self.calendar.hidden = YES;
    pageSize = 1;
    self.dataArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    //显示的title
    NSArray * titleArr = @[@"待完成任务",@"进行中任务",@"已完成任务"];
    self.title = titleArr[_bid];
    [self setLeftNavTilte:@"back.png" RightNavTilte:@"search.png" RightTitleTwo:@"calendar.png"];

    // 注册搜索通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNoticeDate:) name:@"searchDateVC" object:nil];

    self.topConstant.constant = [[UIApplication sharedApplication] statusBarFrame].size.height +   self.navigationController.navigationBar.frame.size.height;
    
    if([ReachbilityTool.internetStatus isEqualToString:@"notReachable"]){
        [self.view bringSubviewToFront:self.netWorkErrorView];
        [self.view bringSubviewToFront:self.calendar];
    }else{
        [self.view sendSubviewToBack:self.netWorkErrorView];
    }
    
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.taskTableview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
    if(self.bid==3){
        return;
    }
    [self initTableview];
    [self requestTask];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DDLogInfo(@"点击了待办任务item");
    ishidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)showAllBtnClicked:(id)sender
{
    tableviewtype = 0;
    [self RightBarClick];
    [self requestTask];
}

#pragma mark - notice
-(void)searchNoticeDate:(NSNotification *)searchDate{
    if (searchDate) {
     NSDictionary *dicDate = [searchDate object];
        searchBTime = kString([dicDate objectForKey:@"beginDate"]);
        searchETime = kString([dicDate objectForKey:@"endDate"]);
        [self.taskTableview.mj_header beginRefreshing];
    }
}

#pragma mark - nav click
-(void)RightBarClick{
//    if(self.bid==1){
//        return;
//    }else if(self.bid==0){
//        if(ishidden){
//            self.calendar.hidden = NO;
//            [self downLayoutAnimate];
//            ishidden = NO;
//        }else{
//            [self upLayoutAnimate];
//            ishidden = YES;
//        }
//
//    }
    
    AKTSearchInfoVC *searvc = [AKTSearchInfoVC new];
    searvc.delegate = self;
    searvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searvc animated:YES];
}
-(void)SearchBarClick{
    NSLog(@"搜索按钮");
    SearchDateController * sdController = [[SearchDateController alloc] init];
    sdController.hidesBottomBarWhenPushed = YES;
    sdController.type = _bid;
    [self.navigationController pushViewController:sdController animated:YES];
}
#pragma mark - search delegate
-(void)searchKey:(NSString *)search SearchAddress:(nonnull NSString *)address Searchtime:(nonnull NSString *)searchtime SearchOrder:(nonnull NSString *)orderid Sender:(NSInteger)sender{
    if (sender == 1) {
       searchKey = search;
       searchAddress = address; // 地址
        if (searchtime.length>10) {
            searchBTime = [searchtime substringToIndex:10]; // 时间
            searchETime = [searchtime substringWithRange:NSMakeRange(11, 10)]; // 结束时间
        }else{
            searchBTime = @"";
            searchETime = @"";
        }
       searchWorkNo = orderid; // 单号
       [self.navigationController popViewControllerAnimated:YES];
       [self.taskTableview.mj_header beginRefreshing];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - mj
-(void)initTableview{
    //去除没有数据时的分割线
    self.taskTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //去除右侧滚动条
    self.taskTableview.showsVerticalScrollIndicator = NO;
    
    self.taskTableview.mj_header = self.mj_header;
    self.taskTableview.mj_footer = self.mj_footer;
}
-(void)loadHeaderData:(MJRefreshGifHeader*)mj{
    [self.taskTableview.mj_header beginRefreshing];
    pageSize = 1;
    [self requestTask];
    [self.taskTableview.mj_header endRefreshing];
}
-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
    [self.taskTableview.mj_footer beginRefreshing];
    pageSize = pageSize+1;
    [self requestTask];
    [self.taskTableview.mj_footer endRefreshing];
}

#pragma mark - request
-(void)requestTask{
    //网络状态判断
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
    }
    tableviewtype = 0;
    //status：状态(1：未完成 2：服务中 3：已完成)
    NSArray * typeArr = @[@"1",@"2",@"3",@""];
    if (pageSize == 1) {
        [self.dataArray removeAllObjects];
    }
    NSLog(@"%@",appDelegate.userinfo);
    NSDictionary * parameters =@{@"status":typeArr[self.bid], @"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"pageNumber":[NSString stringWithFormat:@"%d",pageSize],@"customerName":kString(searchKey),@"serviceAddress":kString(searchAddress),@"serviceBegin":kString(searchBTime),@"serviceEnd":kString(searchETime),@"workNo":kString(searchWorkNo)};
    [[AFNetWorkingRequest sharedTool] requestgetWorkByStatus:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = [dic objectForKey:@"message"];
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            NSDictionary * obj = [dic objectForKey:@"object"];
            arr = obj[@"result"];
            if([message isEqualToString:@"当前没有工单任务!"]){
                [self showOffLineAlertWithTime:1.0  message:@"当前没有工单任务!" DoSomethingBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }else{
                if(arr&&arr.count>0){
                    self.taskTableview.hidden = NO;
                    self.netWorkErrorView.hidden = YES;

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
                        if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil||!orderinfo.tid){
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            [_dataArray addObject:orderinfo];
                            [self.orderfmdb saveOrderTask:orderinfo];
                            
                        }else{
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            [_dataArray addObject:orderinfo];
                            [self.orderfmdb updateObject:orderinfo];
                        }
                    }
                    
                    [self.taskTableview reloadData];
                    [SVProgressHUD dismiss];
                    self.netWorkErrorView.userInteractionEnabled = YES;
                }else{
                    self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
                    self.netWorkErrorView.hidden = NO;
                    [SVProgressHUD dismiss];
                    self.netWorkErrorView.userInteractionEnabled = YES;
                }
            }
        }else if(pageSize == 1){
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
    }
        failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%ld",(long)error.code]];
            [self.calendar reloadData];
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }];
}

-(void)labelClick{
    pageSize=0;
    DDLogInfo(@"点击了刷新按钮");
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        if([appDelegate.userinfo.isclickOff_line isEqualToString:@"0"]){
            if(appDelegate.netWorkType==Off_line){
                [self showOffLineAlertWithTime:1.0  message:ContinueError DoSomethingBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }else{
                [self showOffLineAlertWithTime:1.0  message:LoadingError DoSomethingBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }
            appDelegate.netWorkType = Off_line;
            return;
        }else{
            [self showMessageAlertWithController:self Message:NetWorkMessage];
        }
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:Loading];
    self.netWorkErrorLabel.text = Loading;
    [self requestTask];
    self.netWorkErrorView.userInteractionEnabled = NO;
}

#pragma mark - tableview设置
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
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.0f;
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
    cell.grabSingleBtn.hidden = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderInfo * orderinfo = [_dataArray objectAtIndex:indexPath.section];
    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc]initMinuteTaskControllerwithOrderInfo:self.dataArray[indexPath.section]];
    minuteTaskContoller.type = @"1";
    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:minuteTaskContoller animated:YES];
}

#pragma mark - left click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)RequestgetWorkByDay:(NSString *)dateStr{
    //NSString * date = [NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    //type=doing  进行中工单   type=undo 未开始工单  type=done 已完成工单
    NSDictionary * dic =  @{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"date":dateStr,@"type":@"undo"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkByDay:dic type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dicc = responseObject;
        NSLog(@"%@",dicc);
        int code = [dicc[@"code"] intValue];
        if(code==1){
            tableviewtype = 1;
            [self.dateArray removeAllObjects];
            NSArray * arr = dicc[@"object"];
            if(arr.count>0){
                for(NSMutableDictionary * ordrerDic in arr){
                    NSDictionary * createBydic = [ordrerDic objectForKey:@"createBy"];
                    NSDictionary * updateBydic = [ordrerDic objectForKey:@"updateBy"];
                    NSString * createBy = [createBydic objectForKey:@"id"];
                    NSString * updateBy = [updateBydic objectForKey:@"id"];
                    [ordrerDic removeObjectForKey:@"createBy"];
                    [ordrerDic removeObjectForKey:@"updateBy"];
                    [ordrerDic setObject:createBy forKeyedSubscript:@"createBy"];
                    [ordrerDic setObject:updateBy forKeyedSubscript:@"updateBy"];
                    OrderInfo * order = [[OrderInfo alloc] initWithDictionary:ordrerDic error:nil];
                    [self.dateArray addObject:order];
                }
                [self.taskTableview reloadData];
            }
        }else{
//            [self showMessageAlertWithController:self Message:[dicc objectForKey:@"message"]];
            self.netWorkErrorLabel.text = [dicc objectForKey:@"message"];
            [self showMessageAlertWithController:self Message:@"暂无数据"];
            self.taskTableview.hidden = YES;
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = NO;
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:Loading];
    [self RequestgetWorkByDay:dateStr];

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
            //日期上的按钮背景色
            UIColor * color = [UIColor colorWithHexString:@"#1878C0"];
            return color;
        }else{
            continue;
        }
    }
    return nil;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{

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
