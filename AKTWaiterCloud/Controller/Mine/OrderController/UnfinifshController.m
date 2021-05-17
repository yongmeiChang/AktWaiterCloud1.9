//
//  UnfinifshController.m
//  AKTWaiterCloud
//
//  Created by 常 on 2020/11/22.
//  Copyright © 2020年 常. All rights reserved.
//

#import "UnfinifshController.h"
#import "PlanTaskCell.h"
#import "MinuteTaskController.h"
#import "SearchDateController.h"
#import "AKTSearchInfoVC.h"

@interface UnfinifshController ()<UITableViewDataSource,UITableViewDelegate,AktSearchDelegate>{
    int pageSize;
    BOOL ishidden;

    NSString *searchKey;
    NSString *searchAddress; // 服务地址
    NSString *searchBTime; // 服务开始时间
    NSString *searchETime; // 服务结束时间
    NSString *searchWorkNo;// 服务单号
    
    NSMutableArray * orderListAry;//数据源
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property(weak,nonatomic) IBOutlet UITableView * taskTableview;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation UnfinifshController

- (void)viewDidLoad {
    [super viewDidLoad];
    orderListAry = [[NSMutableArray alloc] init];
    
    searchKey = [NSString stringWithFormat:@""];
    searchAddress = [NSString stringWithFormat:@""];
     searchWorkNo = [NSString stringWithFormat:@""];

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
    
    //表数据
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    self.taskTableview.mj_header = self.mj_header;
    self.taskTableview.mj_footer = self.mj_footer;
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DDLogInfo(@"点击了待办任务item");
    ishidden = YES;
    [self loadNewData];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)showAllBtnClicked:(id)sender
{
    [self RightBarClick];
    [self requestTask];
}

#pragma mark - notice
-(void)searchNoticeDate:(NSNotification *)searchDate{
    if (searchDate) {
        NSDictionary *dicDate = [searchDate object];
        searchBTime = kString([dicDate objectForKey:@"beginDate"]);
        searchETime = kString([dicDate objectForKey:@"endDate"]);
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
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - mj
-(void)loadHeaderData:(MJRefreshGifHeader*)mj{
    [self loadNewData];
}
-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
    [self loadMoreDataFooter];
}
// 下拉刷新
-(void)loadNewData
{
    pageSize = 1;
    [self requestTask];
    [self.taskTableview.mj_header endRefreshing];
}
// 上拉加载
-(void)loadMoreDataFooter
{
    pageSize = pageSize+1;
    [self requestTask];
    [self.taskTableview.mj_footer endRefreshing];
}
#pragma mark - request
-(void)requestTask{
    //status：状态(1：未完成 2：服务中 3：已完成)
    NSArray * typeArr = @[@"1",@"2",@"3",@""];
    LoginModel *model = [LoginModel gets];
    NSDictionary * parameters =@{@"status":typeArr[self.bid], @"waiterId":kString(model.uuid),@"tenantsId":kString(model.tenantId),@"pageNumber":[NSString stringWithFormat:@"%d",pageSize],@"customerName":kString(searchKey),@"serviceAddress":kString(searchAddress),@"serviceDate":kString(searchBTime),@"serviceDateEnd":kString(searchETime),@"workNo":kString(searchWorkNo)};
    [[AFNetWorkingRequest sharedTool] requestgetWorkByStatus:parameters type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = [dic objectForKey:@"message"];
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            NSDictionary * obj = [dic objectForKey:ResponseData];
            arr = obj[@"list"];
            // 分页判断
            if (pageSize == 1) {
                [orderListAry removeAllObjects];
            }
            if([message isEqualToString:@"共有0个工单任务！"]){
                self.netWorkErrorView.hidden = NO;
                [self showOffLineAlertWithTime:1.0  message:@"当前没有工单任务!" DoSomethingBlock:^{
                }];
            }else{
                self.taskTableview.hidden = NO;
                self.netWorkErrorView.hidden = YES;

                AktOrderModel *ordermodel = [[AktOrderModel alloc] initWithDictionary:obj error:nil];
                [orderListAry addObjectsFromArray:ordermodel.list];
                [self.taskTableview reloadData];
                [[AppDelegate sharedDelegate] hidHUD];
                self.netWorkErrorView.userInteractionEnabled = YES;
            }
        }else if(pageSize == 1 && [code integerValue] == 1){
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
//点击了刷新按钮
-(void)labelClick{
    pageSize=1;
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        [self showMessageAlertWithController:self Message:NetWorkMessage];
    }
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:Loading];
    [self requestTask];
}

#pragma mark - tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return orderListAry.count;
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.section);
    OrderListModel * orderinfo = orderListAry[indexPath.section];
    NSString * itemName = orderinfo.serviceItemName;
    itemName = [itemName stringByReplacingOccurrencesOfString:@"->" withString:@"  >  "];//▶

    CGFloat itemF = [AktUtil getNewTextSize:itemName font:14 limitWidth:(SCREEN_WIDTH-30)].height-14; // 项目名称的高度
    CGFloat itemAddress = [AktUtil getNewTextSize:[NSString stringWithFormat:@"%@",orderinfo.serviceAddress] font:14 limitWidth:(SCREEN_WIDTH-50)].height; // 项目名称的高度
    return 215.0f+itemF+itemAddress;
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

    OrderListModel * orderinfo = orderListAry[indexPath.section];
    [cell setOrderList:orderinfo Type:1];
    cell.grabSingleBtn.hidden = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListModel * orderinfo = [orderListAry objectAtIndex:indexPath.section];
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
