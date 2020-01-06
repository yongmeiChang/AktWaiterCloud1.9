//
//  PlanTaskController.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/31.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//


#import "PlanTaskController.h"
#import "OrderTaskFmdb.h"
#import "PlanTaskCell.h"
#import <MJRefresh.h>
#import <FSCalendar.h>
#import "MinuteTaskController.h"
#import "SearchDateController.h" // 筛选

@interface PlanTaskController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *searchBTime; // 服务开始时间
    NSString *searchETime; // 服务结束时间
    int pageSize; // 页数
}
@property(weak,nonatomic) IBOutlet UITableView * taskTableview;
@property(nonatomic,strong) NSMutableArray * dataArray;//数据源
@property(nonatomic,strong) OrderTaskFmdb * orderfmdb;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *topConstant;


@end

@implementation PlanTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTaskTableView];
    searchBTime = [NSString stringWithFormat:@""];
    searchETime = [NSString stringWithFormat:@""];
    self.topConstant.constant = AktNavAndStatusHight;
    pageSize = 1;
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.taskTableview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
    [self initWithNavLeftImageName:@"" RightImageName:@"calendar"];
    self.navigationItem.title = @"计划";
    self.dataArray = [NSMutableArray array];
    [self checkNetWork];
    // 注册日历筛选通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNoticeDate:) name:@"searchDateVC" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    DDLogInfo(@"点击了待办任务item");
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -
-(void)initTaskTableView{
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    self.taskTableview.mj_header = self.mj_header;
    self.taskTableview.mj_footer = self.mj_footer;
    [self.taskTableview.mj_header beginRefreshing];
}

#pragma mark - mj
-(void)loadHeaderData:(MJRefreshGifHeader*)mj{
    pageSize = 1;
    [self checkNetWork];
    [self.taskTableview.mj_header endRefreshing];
}

-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
    pageSize = pageSize+1;
    [self.taskTableview.mj_footer beginRefreshing];
    [self checkNetWork];
    [self.taskTableview.mj_footer endRefreshing];
}

#pragma mark - checkNetWork
-(void)checkNetWork{
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        [self showMessageAlertWithController:self Message:NetWorkMessage];
    }else{
        [self requestUnFinishedTask];
    }
}

-(void)RightBarClick{
    SearchDateController * sdController = [[SearchDateController alloc] init];
    sdController.hidesBottomBarWhenPushed = YES;
    sdController.mindate = [AktUtil getNowDate];
    sdController.maxdate = @"50";
    [self.navigationController pushViewController:sdController animated:YES];
}

-(void)requestUnFinishedTask{
     [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    NSDictionary * parameters =@{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"pageNumber":[NSString stringWithFormat:@"%d",pageSize],@"serviceBegin":searchBTime,@"serviceEnd":searchETime};
    [[AFNetWorkingRequest sharedTool] requesttoBeHandle:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        if (pageSize == 1) {
            [self.dataArray removeAllObjects];
            }
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            NSDictionary * obj = [dic objectForKey:@"object"];
            arr = obj[@"result"];
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
                  if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil){
                      orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                      [_dataArray addObject:orderinfo];
                      orderinfo.tid = orderinfo.id;
                      [self.orderfmdb saveOrderTask:orderinfo];
                  }else{
                      orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                     [_dataArray addObject:orderinfo];
                      orderinfo.tid = orderinfo.id;
                      [self.orderfmdb updateObject:orderinfo];
                  }
              }
              [self.taskTableview reloadData];
        }else  if(pageSize == 1 && [code integerValue] == 2){
            self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
            self.taskTableview.hidden = YES;
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }
        [[AppDelegate sharedDelegate] hidHUD];
    }failure:^(NSError *error) {
        self.netWorkErrorView.userInteractionEnabled = YES;
        self.netWorkErrorView.hidden = NO;
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}

#pragma mark - 点击了刷新按钮
-(void)labelClick{
    DDLogInfo(@"点击了刷新按钮");
    self.netWorkErrorView.userInteractionEnabled = false;
    [self.taskTableview.mj_header beginRefreshing];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"PlanTaskCell";
    PlanTaskCell *cell = (PlanTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    if(_dataArray.count>0){
        OrderInfo * orderinfo = _dataArray[indexPath.section];
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

#pragma mark - notice
-(void)searchNoticeDate:(NSNotification *)searchDate{
    if (searchDate) {
     NSDictionary *dicDate = [searchDate object];
        searchBTime = kString([dicDate objectForKey:@"beginDate"]);
        searchETime = kString([dicDate objectForKey:@"endDate"]);
        [self.taskTableview.mj_header beginRefreshing];
    }
}

@end
