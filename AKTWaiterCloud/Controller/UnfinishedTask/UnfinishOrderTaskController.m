//
//  UnfinishOrderTaskController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/2.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "UnfinishOrderTaskController.h"
#import "PlanTaskCell.h"
#import "MinuteTaskController.h"
#import "QRCodeViewController.h"
#import "AKTSearchInfoVC.h"
#import "SearchDateController.h" // 筛选日期

@interface UnfinishOrderTaskController ()<UITableViewDataSource,UITableViewDelegate,AktSearchDelegate>{
    int pageSize;//当前分页
    NSString *searchKey; // 用户名搜索
    NSString *searchAddress; // 服务地址
    NSString *searchBTime; // 服务开始时间
    NSString *searchETime; // 服务结束时间
    NSString *searchWorkNo;// 服务单号
    LoginModel *model; // 登录
}

@property(nonatomic,strong) NSDate * locationServiceEndDate;
@property(nonatomic,strong) NSString * LocationwaiterId;//定位的服务工单的id
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@end

@implementation UnfinishOrderTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchKey = [NSString stringWithFormat:@""];
    searchAddress = [NSString stringWithFormat:@""];
    searchBTime = [NSString stringWithFormat:@""];
    searchETime = [NSString stringWithFormat:@""];
    searchWorkNo = [NSString stringWithFormat:@""];


    pageSize = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.taskTableview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
    [self initWithNavLeftImageName:@"search" RightImageName:@"qrcode"];
    [self setNavTitle:@"任务"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork) name:@"requestUnFinish" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    model = [LoginModel gets];
    [self initTaskTableView];
}
#pragma mark - init table
-(void)initTaskTableView{
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    //去除没有数据时的分割线
    self.taskTableview.mj_header = self.mj_header;
    self.taskTableview.mj_footer = self.mj_footer;
    [self loadNewData];
}
#pragma mark - nav click
-(void)RightBarClick{ // 扫码
    QRCodeViewController * qrcodeController = [[QRCodeViewController alloc]initWithQRCode:self Type:@"unfinishedcontroller"];
    qrcodeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrcodeController animated:YES];
}
-(void)LeftBarClick{
    AKTSearchInfoVC *searvc = [AKTSearchInfoVC new];
    searvc.delegate = self;
    searvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searvc animated:YES];
}
#pragma mark - search delegate
-(void)searchKey:(NSString *)search SearchAddress:(nonnull NSString *)address Searchtime:(nonnull NSString *)searchtime SearchOrder:(nonnull NSString *)orderid Sender:(NSInteger)sender{
    if (sender == 1) {
        searchKey = search; // 用户名
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
    self.strCustmerUkey = @"";
    searchKey = @"";
    searchAddress = @"";
    searchBTime = @"";
    searchETime = @"";
    searchWorkNo = @"";
    pageSize=1;
    [self loadNewData];
}
-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
    [self loadMoreDataFooter];
}
// 下拉刷新
-(void)loadNewData
{
    // 马上进入刷新状态
    pageSize = 1;
    [self checkNetWork];
    [self.taskTableview.mj_header endRefreshing];
}
// 上拉加载
-(void)loadMoreDataFooter
{
    pageSize = pageSize+1;
    [self checkNetWork];
    [self.taskTableview.mj_footer endRefreshing];
}
#pragma mark - network
-(void)checkNetWork{
    //判断网络状态
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        self.netWorkErrorView.hidden = NO;
    }else{
        [self requestUnFinishedTask];
    }
}

#pragma mark - 请求工单列表
-(void)requestUnFinishedTask{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:Loading];
    model = [LoginModel gets];
    NSDictionary * parameters =@{@"waiterId":kString(model.uuid),@"tenantsId":kString(model.tenantId),@"pageNumber":[NSString stringWithFormat:@"%d",pageSize],@"customerName":kString(searchKey),@"serviceAddress":kString(searchAddress),@"serviceDate":kString(searchBTime),@"serviceDateEnd":kString(searchETime),@"workNo":kString(searchWorkNo),@"customerUkey":kString(self.strCustmerUkey)}; // @"waiterId":kString(model.uuid),

    [[AFNetWorkingRequest sharedTool] requesthistoryNoHandled:parameters type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        
        if([code intValue]==1){
            NSDictionary * obj = [dic objectForKey:ResponseData];
            // 分页数据判断
            if (pageSize == 1) {
                [_dataArray removeAllObjects];
            }
            self.taskTableview.hidden = NO;
            self.netWorkErrorView.hidden = YES;

            AktOrderModel *ordermodel = [[AktOrderModel alloc] initWithDictionary:obj error:nil];
            [_dataArray addObjectsFromArray:ordermodel.list];
            [self.taskTableview reloadData];
            
        }else if(pageSize == 1 && [code intValue]==2){
            self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
            self.taskTableview.hidden = YES;
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }
        [[AppDelegate sharedDelegate] hidHUD];
    }failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        self.netWorkErrorView.hidden = NO;
        self.netWorkErrorView.userInteractionEnabled = YES;
        self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
    }];
}
#pragma mark - 刷新
-(void)labelClick{
    self.strCustmerUkey = @"";
    searchKey = @"";
    searchAddress = @"";
    searchBTime = @"";
    searchETime = @"";
    searchWorkNo = @"";
    pageSize=1;
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        self.netWorkErrorView.hidden = NO;
    }
    
    [self loadNewData];
}

#pragma mark - tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListModel * orderinfo = _dataArray[indexPath.section];
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
    OrderListModel * orderinfo = _dataArray[indexPath.section];
    [cell setOrderList:orderinfo Type:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc]initMinuteTaskControllerwithOrderInfo:self.dataArray[indexPath.section]];
    minuteTaskContoller.type = @"0";
    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:minuteTaskContoller animated:YES];
}

@end


