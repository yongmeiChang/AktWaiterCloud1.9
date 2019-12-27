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

@interface UnfinishOrderTaskController ()<UITableViewDataSource,UITableViewDelegate,AMapLocationManagerDelegate,AktSearchDelegate>{
    int pageSize;//当前分页
    NSString *searchKey; // 用户名搜索
    NSString *searchAddress; // 服务地址
    NSString *searchBTime; // 服务开始时间
    NSString *searchETime; // 服务结束时间
    NSString *searchWorkNo;// 服务单号
}

@property(nonatomic,strong) NSDate * locationServiceEndDate;
@property(nonatomic,strong) NSString * LocationwaiterId;//定位的服务工单的id
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@end

@implementation UnfinishOrderTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableTop.constant = AktNavAndStatusHight;
    searchKey = [NSString stringWithFormat:@""];
    searchAddress = [NSString stringWithFormat:@""];
    searchBTime = [NSString stringWithFormat:@""];
    searchETime = [NSString stringWithFormat:@""];
    searchWorkNo = [NSString stringWithFormat:@""];

    [self initTaskTableView];
    pageSize = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.taskTableview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
    [self initWithNavLeftImageName:@"search" RightImageName:@"qrcode"];
    [self setNavTitle:@"任务"];
    self.dataArray = [NSMutableArray array];
    [self checkNetWork];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork) name:@"requestUnFinish" object:nil];
}

-(void)initTaskTableView{
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    //去除没有数据时的分割线
    self.taskTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //去除右侧滚动条
    self.taskTableview.showsVerticalScrollIndicator = NO;
  
    self.taskTableview.mj_header = self.mj_header;
    self.taskTableview.mj_footer = self.mj_footer;

}

#pragma mark - nav click
-(void)RightBarClick{
    DDLogInfo(@"点击了扫码功能");
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
        [self.taskTableview.mj_header beginRefreshing];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - mj
-(void)loadHeaderData:(MJRefreshGifHeader*)mj{
    // 马上进入刷新状态
    pageSize = 1;
    [self.taskTableview.mj_header beginRefreshing];
    [self checkNetWork];
    [self.taskTableview.mj_header endRefreshing];
}
-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
    pageSize = pageSize+1;
    [self.taskTableview.mj_footer beginRefreshing];
    [self checkNetWork];
    [self.taskTableview.mj_footer endRefreshing];
}
#pragma mark - network
-(void)checkNetWork{
    //判断网络状态
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
        [self requestUnFinishedTask];
    }
}

#pragma mark - 请求工单列表
-(void)requestUnFinishedTask{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:Loading];
    NSLog(@"---%@",appDelegate.userinfo);
    NSDictionary * parameters =@{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"pageNumber":[NSString stringWithFormat:@"%d",pageSize],@"customerName":kString(searchKey),@"serviceAddress":kString(searchAddress),@"serviceBegin":kString(searchBTime),@"serviceEnd":kString(searchETime),@"workNo":kString(searchWorkNo)};

    [[AFNetWorkingRequest sharedTool] requesthistoryNoHandled:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = [dic objectForKey:@"message"];
        NSNumber * code = [dic objectForKey:@"code"];
        
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            NSDictionary * obj = [dic objectForKey:@"object"];
            arr = obj[@"result"];
            // 分页数据判断
            if (pageSize == 1) {
                [_dataArray removeAllObjects];
            }
            
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
                OrderInfo * orderinfo;
                                   
                //判断工单是否本地有缓存,有缓存则更新，没缓存则添加至缓存
              orderinfo = [self.orderfmdb findByWorkNo:[objdic objectForKey:@"workNo"]];
                if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil){
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
    }failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        self.netWorkErrorView.hidden = NO;
        self.netWorkErrorView.userInteractionEnabled = YES;
        self.netWorkErrorLabel.text = @"暂无数据,请轻触重新加载";
    }];
}
#pragma mark -
-(void)labelClick{
    DDLogInfo(@"点击了刷新按钮");
    pageSize=1;
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
    
    self.netWorkErrorLabel.text = Loading;
    [self requestUnFinishedTask];
    self.netWorkErrorView.userInteractionEnabled = false;
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
    return 200.0f;
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
    if(_dataArray.count>0){
        OrderInfo * orderinfo = _dataArray[indexPath.section];
        DataManager * dm = [[DataManager alloc] init];
        
        if([orderinfo.serviceItemName rangeOfString:@"体检"].location != NSNotFound){
            if(![orderinfo.workStatus isEqualToString:@"3"]&&![orderinfo.workStatus isEqualToString:@"7"] ){
                
            }else{
                if([self compareDate:[dm changeTime:orderinfo.serviceEnd] End:[dm getNowDate]]==-1){
                    if([[AppInfoDefult sharedClict].orderinfoId isEqualToString:orderinfo.id]){
                        [AppInfoDefult sharedClict].orderinfoId = @"";
                        [AppInfoDefult sharedClict].islongLocation = 0;
                        [self.locationManager stopUpdatingLocation];
                    }
                    cell.grabSingleBtn.hidden=YES;
                }else{
                    cell.grabSingleBtn.hidden = NO;
                }
                
                if([AppInfoDefult sharedClict].islongLocation == 1){
                    if([[AppInfoDefult sharedClict].orderinfoId isEqualToString:orderinfo.id]){
                        [cell.grabSingleBtn setTitle:@"已出发" forState:UIControlStateNormal];
                        [cell.grabSingleBtn setBackgroundColor:[UIColor grayColor]];
                        //cell.grabSingleBtn.enabled = NO;
                    }else{
                        cell.grabSingleBtn.backgroundColor = UIColor.grayColor;
                    }
                }
            }
            
        }
        cell.continuityLocation = ^(UIButton *btn) {
            NSString * str = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            [self continuityLocationById:orderinfo.id section:str button:btn];
        };
        [cell setOrderList:orderinfo];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([appDelegate.userinfo.missionTrans isEqualToString:@"1"]){
        [self showMessageAlertWithController:self Message:@"您尚未拥有此权限"];
        return;
    }
    OrderInfo * orderinfo = [_dataArray objectAtIndex:indexPath.section];
    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc]initMinuteTaskControllerwithOrderInfo:self.dataArray[indexPath.section]];
    minuteTaskContoller.type = @"0";
    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([AppInfoDefult sharedClict].islongLocation == 1){
        minuteTaskContoller.lm = self.locationManager;
    }
    [self.navigationController pushViewController:minuteTaskContoller animated:YES];
}

#pragma mark - 日期换算
-(int)compareDate:(NSDate *)bdate End:(NSDate *)edate{
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

//连续定位
-(void)continuityLocationById:(NSString *)Orderid section:(NSString *)section button:(UIButton *)btn{
    if([AppInfoDefult sharedClict].islongLocation == 1){
        return;
    }
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"出发确认" message:@"点击确定将开启持续定位，工单签入成功后将自动关闭定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn.enabled = NO;
        [self configLocationManagerForContinuity];
        [self.locationManager setLocatingWithReGeocode:YES];
        [self.locationManager startUpdatingLocation];
        OrderInfo * or = self.dataArray[[section integerValue]];
        self.LocationwaiterId = or.waiterId;
        [AppInfoDefult sharedClict].orderinfoId = Orderid;
        [AppInfoDefult sharedClict].islongLocation = 1;
        [self.taskTableview reloadData];
    }];
    UIAlertAction * canel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:ok];
    [ac addAction:canel];
    ac.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ac animated:YES completion:nil];

}
#pragma mark =====定位
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
        NSString * longitude = [NSString stringWithFormat:@"%.4f",location.coordinate.longitude];
        NSString * latitude =  [NSString stringWithFormat:@"%.4f",location.coordinate.latitude];
        NSString * location = reGeocode.formattedAddress;
        NSDictionary * dic = @{@"longitude":longitude,
                               @"latitude":latitude,
                               @"location":location,
                               @"tenantsId":appDelegate.userinfo.tenantsId,
                               @"status":@"99",
                               @"referenceId":self.LocationwaiterId
                               };
        [[AFNetWorkingRequest sharedTool] uploadLocateInformation:dic Url:@"uploadLocateInformation" type:HttpRequestTypeGet success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}
@end


