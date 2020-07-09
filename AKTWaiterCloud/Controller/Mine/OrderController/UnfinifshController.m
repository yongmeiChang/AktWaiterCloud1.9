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
#import "AKTSearchInfoVC.h"

@interface UnfinifshController ()<UITableViewDataSource,UITableViewDelegate,AktSearchDelegate>{
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

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation UnfinifshController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchKey = [NSString stringWithFormat:@""];
    searchAddress = [NSString stringWithFormat:@""];
     searchWorkNo = [NSString stringWithFormat:@""];
    
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    //去除没有数据时的分割线
    self.taskTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.taskTableview.mj_header = self.mj_header;
    self.taskTableview.mj_footer = self.mj_footer;
    [self.taskTableview.mj_header beginRefreshing];

    pageSize = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];
    //显示的title
    NSArray * titleArr = @[@"待完成任务",@"进行中任务",@"已完成任务"];
    self.title = titleArr[_bid];
    [self setLeftNavTilte:@"back.png" RightNavTilte:@"search.png" RightTitleTwo:@"calendar.png"];

    // 注册日历筛选通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNoticeDate:) name:@"searchDateVC" object:nil];

    self.topConstant.constant = [[UIApplication sharedApplication] statusBarFrame].size.height +   self.navigationController.navigationBar.frame.size.height;
    
    if([ReachbilityTool.internetStatus isEqualToString:@"notReachable"]){
        [self.view bringSubviewToFront:self.netWorkErrorView];
    }else{
        [self.view sendSubviewToBack:self.netWorkErrorView];
    }
    
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.taskTableview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
    if(self.bid==3){
        return;
    }
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
    AKTSearchInfoVC *searvc = [AKTSearchInfoVC new];
    searvc.delegate = self;
    searvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searvc animated:YES];
}
-(void)SearchBarClick{
    NSLog(@"搜索按钮");
    SearchDateController * sdController = [[SearchDateController alloc] init];
    sdController.hidesBottomBarWhenPushed = YES;
    sdController.mindate = @"1996-01-01";
    sdController.maxdate = [AktUtil getNowDate];
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
        self.orderfmdb = [[OrderTaskFmdb alloc] init];
        _dataArray = [self.orderfmdb findAllOrderInfo];
        if(_dataArray.count==0){
            self.netWorkErrorView.hidden = NO;
        }else{
            self.netWorkErrorView.hidden = YES;
            [self.taskTableview reloadData];
        }
        
    }else{
        [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:Loading];
    }
    tableviewtype = 0;
    //status：状态(1：未完成 2：服务中 3：已完成)
    NSArray * typeArr = @[@"1",@"2",@"3",@""];
    if (pageSize == 1) {
        [self.dataArray removeAllObjects];
    }
    NSLog(@"%@",[LoginModel gets]);
    LoginModel *model = [LoginModel gets];
    NSDictionary * parameters =@{@"status":typeArr[self.bid], @"waiterId":kString(model.uuid),@"tenantsId":kString(model.tenantsId),@"pageNumber":[NSString stringWithFormat:@"%d",pageSize],@"customerName":kString(searchKey),@"serviceAddress":kString(searchAddress),@"serviceBegin":kString(searchBTime),@"serviceEnd":kString(searchETime),@"workNo":kString(searchWorkNo)};
    [[AFNetWorkingRequest sharedTool] requestgetWorkByStatus:parameters type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = [dic objectForKey:@"message"];
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            NSDictionary * obj = [dic objectForKey:ResponseData];
            arr = obj[@"list"];
            if([message isEqualToString:@"当前没有工单任务!"]){
                [self showOffLineAlertWithTime:1.0  message:@"当前没有工单任务!" DoSomethingBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }else{
                if(arr&&arr.count>0){
                    self.taskTableview.hidden = NO;
                    self.netWorkErrorView.hidden = YES;

                    for (NSMutableDictionary * dicc in arr) {
//                        NSDictionary * createBydic = [dicc objectForKey:@"createBy"];
                        NSDictionary * updateBydic = [dicc objectForKey:@"updateBy"];
//                        NSString * createBy = [createBydic objectForKey:@"id"];
                        NSString * updateBy = [updateBydic objectForKey:@"id"];
//                        [dicc removeObjectForKey:@"createBy"];
                        [dicc removeObjectForKey:@"updateBy"];
//                        [dicc setObject:createBy forKeyedSubscript:@"createBy"];
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
                    [[AppDelegate sharedDelegate] hidHUD];
                    self.netWorkErrorView.userInteractionEnabled = YES;
                }else{
                    self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
                    self.netWorkErrorView.hidden = NO;
                    [[AppDelegate sharedDelegate] hidHUD];
                    self.netWorkErrorView.userInteractionEnabled = YES;
                }
            }
        }else if(pageSize == 1 && [code integerValue] == 2){
            self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
            [self showMessageAlertWithController:self Message:@"暂无数据"];
            self.taskTableview.hidden = YES;
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }
        [[AppDelegate sharedDelegate] hidHUD];
    }
        failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%ld",(long)error.code]];
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }];
}

-(void)labelClick{
    pageSize=0;
    DDLogInfo(@"点击了刷新按钮");
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        [self showMessageAlertWithController:self Message:NetWorkMessage];
    }
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:Loading];
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

    return 0.01f;
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
    OrderInfo * orderinfo = [_dataArray objectAtIndex:indexPath.section];
    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc]initMinuteTaskControllerwithOrderInfo:orderinfo];
    minuteTaskContoller.type = @"1";
    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:minuteTaskContoller animated:YES];
}

#pragma mark - left click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
