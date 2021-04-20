//
//  MinuteTaskController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MinuteTaskController.h"
#import "PlanTaskCell.h" // 服务对象信息
#import "SignInCell.h" // 签入
#import "SignoutController.h"
#import "VisitCell.h"  // 回访
#import "NoDateCell.h" // 无数据
#import <CoreLocation/CoreLocation.h>
#import "AktOrderDetailsCheckImageVC.h" // 查看图片
#import "AktOrderDetailsModel.h"
#import "AktOrderScanVC.h" // 订单签入 签出 扫一扫

#define PI 3.1415926
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface MinuteTaskController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,PlanTaskPhoneDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    CLGeocoder *_geocoder;
    NSString *_latitude;//纬度
    NSString *_longitude;//经度
    
    double distanceSingin; // 签入定位误差(米)
    double lateSingin; // 迟到最大时长(分钟)
    
    double distanceSingout; // 签出定位误差
}

@property(nonatomic,strong) OrderInfo * orderinfo;
@property(weak,nonatomic) IBOutlet UITableView * minuteTaskTableView;

//@property(nonatomic,strong) UILabel * signinDateLabel;//签入日期
//@property(nonatomic,strong) UILabel * signoutDateLabel;//签出日期
//@property(nonatomic,strong) UILabel * signoutDateLengthLabel;//签出服务时长
@property(nonatomic,strong) SignoutController * sgController;

@property (weak, nonatomic) IBOutlet UIButton *btnSingInOrSingOut;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewTop;

/*定位*/
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic,strong) AMapLocationManager * unfinishManager; // 地址管理
@property (nonatomic,strong) AMapSearchAPI * searchAPI;  // 逆地理编码
@property (nonatomic,strong) NSString * locaitonLatitude;//定位的当前坐标
@property (nonatomic,strong) NSString * locaitonLongitude;//定位的当前坐标
@property (nonatomic,strong) NSString * distancePost; // 距离 单位米


@end

@implementation MinuteTaskController

-(id)initMinuteTaskControllerwithOrderInfo:(OrderInfo *)orderinfo{
    if(self = [super init]){
        self.orderinfo = orderinfo;
        return self;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"任务详情"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
//    self.tableTop.constant = AktNavAndStatusHight;
    self.bgviewTop.constant = AktNavAndStatusHight+200;
    
    self.netWorkErrorView.hidden = YES;
    self.minuteTaskTableView.delegate = self;
    self.minuteTaskTableView.dataSource = self;
    
    if([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"2"]){ // 我的-工单任务、计划工单
        self.viewHeightConstraint.constant = 0;
    }else{ // 任务
        self.viewHeightConstraint.constant = 84;
    }
    _geocoder=[[CLGeocoder alloc]init];
    [self getCoordinateByAddress:self.orderinfo.serviceAddress];
    
    // 获取定位权限
    [self getlocation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    _sgController = [[SignoutController alloc] init];
    if([self.orderinfo.workStatus isEqualToString:@"2"]){
        _sgController.type = 1;
         [self.btnSingInOrSingOut setTitle:@"任务签出" forState:UIControlStateNormal];
    }else if([self.orderinfo.workStatus isEqualToString:@"1"]){
        _sgController.type = 0;
         [self.btnSingInOrSingOut setTitle:@"任务签入" forState:UIControlStateNormal];
    }
}

#pragma mark - 权限获取
-(void)distanceBetween:(CLLocationDistance)distance{
    self.distancePost = [NSString stringWithFormat:@"%0.1f",distance]; // 距离
}
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{ // 逆地理编码
    if (response.geocodes.count == 0)
    {
        return;
    }
    //解析response获取地理信息
    self.orderinfo.serviceLocationX = [NSString stringWithFormat:@"%f",response.geocodes.lastObject.location.longitude];
    self.orderinfo.serviceLocationY = [NSString stringWithFormat:@"%f",response.geocodes.lastObject.location.latitude];
    //进行单次带逆地理定位请求
    [self.unfinishManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];;
}
-(void)refurbishBtnClick{
    //1.将两个经纬度点转成投影点
    MAMapPoint pointStart = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.orderinfo.serviceLocationY doubleValue],[self.orderinfo.serviceLocationX doubleValue])); // 地址位置
    MAMapPoint pointEnd = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.locaitonLatitude doubleValue],[self.locaitonLongitude doubleValue])); //用户当前位置
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(pointStart,pointEnd);
    [self distanceBetween:distance];
}

- (void)configLocationManager
{
    self.unfinishManager = [[AMapLocationManager alloc] init];
    
    [self.unfinishManager setDelegate:self];
    
    //设置期望定位精度
    [self.unfinishManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.unfinishManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.unfinishManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.unfinishManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.unfinishManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}
- (void)initCompleteBlock
{
    __weak MinuteTaskController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            weakSelf.orderinfo.isAbnormal = @"1";
            [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%ld-%@",(long)error.code,error.localizedDescription]];
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        //修改label显示内容
        if (regeocode)
        {
            //返回用户经纬度，计算两点间的距离
            [weakSelf refurbishBtnClick];
        }

    };
}
-(void)getlocation{
    /*定位 正地理编码*/
    [self initCompleteBlock]; //地理回调
    [self configLocationManager]; // 位置管理
    if(!self.orderinfo.serviceLocationX||!self.orderinfo.serviceLocationY){// 无返回经纬度
        self.searchAPI = [[AMapSearchAPI alloc] init];
        self.searchAPI.delegate = self;
        //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
        AMapGeocodeSearchRequest *searchRequest = [[AMapGeocodeSearchRequest alloc] init];
        searchRequest.address = self.orderinfo.serviceAddress;
        //发起正向地理编码
        [self.searchAPI AMapGeocodeSearch: searchRequest];
    }else{
        //进行单次带逆地理定位请求
        [self.unfinishManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    }
}

#pragma mark - nav back
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
/**行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([AktUtil dx_isNullOrNilWithObject:self.orderinfo]){
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        NSString * itemName = self.orderinfo.serviceItemName;
        itemName = [itemName stringByReplacingOccurrencesOfString:@"->" withString:@"  >  "];//▶
        
        CGFloat itemF = [AktUtil getNewTextSize:itemName font:14 limitWidth:(SCREEN_WIDTH-30)].height-14; // 项目名称的高度
        CGFloat contentF = [AktUtil getNewTextSize:[NSString stringWithFormat:@"%@", self.orderinfo.serviceContent] font:14 limitWidth:(SCREEN_WIDTH-70)].height; // 服务内容的高度
        CGFloat itemAddress = [AktUtil getNewTextSize:[NSString stringWithFormat:@"%@",self.orderinfo.serviceAddress] font:14 limitWidth:(SCREEN_WIDTH-50)].height; // 项目名称的高度
        return 220.0f+itemF+itemAddress+contentF;
        
    }else if(indexPath.section==1){
        if([self.orderinfo.workStatus isEqualToString:@"1"]){
            return 105.5;
        }else{
            return 180;
        }
    }else if(indexPath.section==2){
        if([self.orderinfo.workStatus isEqualToString:@"1"] || [self.orderinfo.workStatus isEqualToString:@"2"]){
            return 105.5;
        }else{
            return 240;
        }
    }else if(indexPath.section==3){
        if([self.orderinfo.workStatus isEqualToString:@"4"]){
            return 177;
        }else{
            return 105.5;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
       return 0;
}

/*Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"PlanTaskCell";
    static NSString *cellidentify1 = @"SignInCell";
    static NSString *cellidentify3 = @"VisitCell";
    static NSString *cellidentify4 = @"NoDateCell";

    if(indexPath.section==0){
        PlanTaskCell * cell;
        cell = (PlanTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellidentify owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self;
        [cell setOrderList:self.orderinfo Type:2];
        return cell;
    }else if(indexPath.section==1){

        if([self.orderinfo.workStatus isEqualToString:@"1"]){

            NoDateCell * sCell;
            sCell = (NoDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify4];
            if (sCell == nil) {
                sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify4 owner:self options:nil] objectAtIndex:0];
            }
            sCell.leftLabel.text = @"签入情况";
            return sCell;
        }else{
            SignInCell * sCell;
            sCell = (SignInCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify1];
            if (sCell == nil) {
                sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify1 owner:self options:nil] objectAtIndex:0];
            }
            [sCell setSignInInfo:self.orderinfo];
            
            UITapGestureRecognizer *openSinImageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageIn)];
            openSinImageTapGestureRecognizer.delegate = self;
            [sCell.btnCheckImage addGestureRecognizer:openSinImageTapGestureRecognizer];
            return sCell;
        }
    }else if(indexPath.section==2){
        if([self.orderinfo.workStatus isEqualToString:@"1"] || [self.orderinfo.workStatus isEqualToString:@"2"]){
        
            NoDateCell * sCell;
            sCell = (NoDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify4];
            if (sCell == nil) {
                sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify4 owner:self options:nil] objectAtIndex:0];
            }
            sCell.leftLabel.text = @"签出情况";
            return sCell;
        }else{
            SignInCell * soutCell;
            soutCell = (SignInCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify1];
            if (soutCell == nil) {
                soutCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify1 owner:self options:nil] objectAtIndex:0];
            }
            [soutCell setSignOutInfo:self.orderinfo];
            
            UITapGestureRecognizer *openSinImageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageOut)];
            openSinImageTapGestureRecognizer.delegate = self;
            [soutCell.btnCheckImage addGestureRecognizer:openSinImageTapGestureRecognizer];
            
            return soutCell;
        }
    }else if(indexPath.section==3){
            
            if([self.orderinfo.workStatus isEqualToString:@"4"]){
                VisitCell * visitCell;
                visitCell = (VisitCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify3];
                if (visitCell == nil) {
                    visitCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify3 owner:self options:nil] objectAtIndex:0];
                }
                  [visitCell setVisitInfo:self.orderinfo];
                  return visitCell;
            }else{
                NoDateCell * sCell;
                sCell = (NoDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify4];
                if (sCell == nil) {
                    sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify4 owner:self options:nil] objectAtIndex:0];
                }
                sCell.leftLabel.text = @"回访情况";
                return sCell;
            }
        }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.minuteTaskTableView deselectRowAtIndexPath:indexPath animated:NO];
}
 
#pragma mark - 签入  签出
- (IBAction)orderSingInOrSingOutClick:(UIButton *)sender {
    NSLog(@"点击签入 签出按钮");
    
    [[AFNetWorkingRequest sharedTool] requestFindAdvantage:@{@"serviceItemId":self.orderinfo.serviceItemId} type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *strcode = [dic objectForKey:ResponseCode];
        if ([strcode integerValue] == 1) {
            AktFindAdvanceModel *model = [[AktFindAdvanceModel alloc] initWithDictionary:[dic objectForKey:ResponseData] error:nil];
            if([self.orderinfo.workStatus isEqualToString:@"2"]){
                    // 签出逻辑判断
                        distanceSingin = [model.maxLocationDistanceSignOut doubleValue]-[self.distancePost doubleValue]; // 签出相差距离
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                /**实际服务时间 与 最低服务时间的差值 **/
                NSInteger mtime = [AktUtil getMinuteFrom:[formatter dateFromString:self.orderinfo.actualBegin] To:[formatter dateFromString:[AktUtil getNowDateAndTime]]]; // 实际服务的时长 to-from
                NSInteger Stime = [AktUtil getTimeDifferenceValueFrome:self.orderinfo.serviceEnd ToTime:self.orderinfo.serviceBegin]; // 应该服务的时长
                NSInteger Ltime = Stime-mtime;
                if (mtime>Stime){ // 实际大于应该
                    Ltime = 0;
                }
                
                BOOL bollateSignOut = (Ltime-[model.maxEarlyTime integerValue])<0; //
                /* 签入时间与当前时间的差值 是否 满足最低服务时长*/
//                NSInteger mtimeless = [AktUtil getMinuteFrom:[formatter dateFromString:[AktUtil getNowDateAndTime]] To:[formatter dateFromString:self.orderinfo.actualBegin]]; // 服务开始时间与当前时间的差值 负数是正常
                BOOL bollateSignOutLess = (mtime-[model.minServiceLength integerValue])<0; // 实际服务小于最低
                
                /**判断当前工单是否在服务有效期内**/
                formatter.dateFormat = @"yyyy-MM-dd";
                if ([AktUtil compareDate:[formatter dateFromString:[self.orderinfo.actualBegin substringToIndex:10]] End:[formatter dateFromString:[AktUtil getNowDate]]] != 0) { // 超出
                    [self showMessageAlertWithController:self title:@"温馨提示" Message:@"您的工单不在服务有效期内！" canelBlock:^{}];
                    return;
                }
                        
                if (([model.recordEarly isEqualToString:@"1"] && ((bollateSignOut == YES) && [model.earlyAbnormal isEqualToString:@"2"])) || ([model.recordLocationSignOut isEqualToString:@"1"] && [model.recordLocationAbnormalSignOut isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignOut isEqualToString:@"2"])) || ([model.recordServiceLength isEqualToString:@"1"] && ([model.recordServiceLengthLess isEqualToString:@"1"] && [model.serviceLengthLessAbnormal isEqualToString:@"2"])) || ([model.recordMinServiceLength isEqualToString:@"1"] && ((bollateSignOutLess == YES) && [model.minServiceLengthLessAbnormal isEqualToString:@"2"]))) {
                            
                            BOOL bollation = ([model.recordLocationSignOut isEqualToString:@"1"] && [model.recordLocationAbnormalSignOut isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignOut isEqualToString:@"2"]));
                            BOOL bolearly = ([model.recordEarly isEqualToString:@"1"] && ((bollateSignOut == YES) && [model.earlyAbnormal isEqualToString:@"2"]));
                           BOOL bolservice = ([model.recordServiceLength isEqualToString:@"1"] && ([model.recordServiceLengthLess isEqualToString:@"1"] && [model.serviceLengthLessAbnormal isEqualToString:@"2"]));
                           BOOL bolserviceLess = ([model.recordMinServiceLength isEqualToString:@"1"] && ((bollateSignOutLess == YES) && [model.minServiceLengthLessAbnormal isEqualToString:@"2"]));
                    if ([model.codeScanSignOut isEqualToString:@"1"]) {// 扫码签出
                        AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                        scanOrder.ordertype = @"2";
                        scanOrder.detailsModel = model;
                        scanOrder.orderinfo = self.orderinfo;
                        scanOrder.isnewLation = bollation;
                        scanOrder.isnewearly = bolearly;
                        scanOrder.isnewserviceTime = bolservice;
                        scanOrder.isnewserviceTimeLess = bolserviceLess;
                        [self.navigationController pushViewController:scanOrder animated:YES];
                        
                    }else{
                            _sgController.isnewLation = bollation;
                            _sgController.isnewearly = bolearly;
                            _sgController.isnewserviceTime = bolservice;
                            _sgController.isnewserviceTimeLess = bolserviceLess;
                            _sgController.orderinfo = self.orderinfo;
                            _sgController.findAdmodel = model;
                            [self.navigationController pushViewController:_sgController animated:YES];
                    }
                        }else if (([model.recordEarly isEqualToString:@"1"] && ((bollateSignOut == YES) && [model.earlyAbnormal isEqualToString:@"3"])) || ([model.recordLocationSignOut isEqualToString:@"1"] && [model.recordLocationAbnormalSignOut isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignOut isEqualToString:@"3"])) || ([model.recordServiceLength isEqualToString:@"1"] && ([model.recordServiceLengthLess isEqualToString:@"1"] && [model.serviceLengthLessAbnormal isEqualToString:@"3"])) || ([model.recordMinServiceLength isEqualToString:@"1"] && ((bollateSignOutLess == YES) && [model.minServiceLengthLessAbnormal isEqualToString:@"3"]))){
                            
                            [[AppDelegate sharedDelegate] showTextOnly:@"订单异常，暂无法操作！"];
                        }else if (([model.recordLocationSignOut isEqualToString:@"1"] && [model.recordLocationAbnormalSignOut isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignOut isEqualToString:@"0"])) || ([model.recordEarly isEqualToString:@"1"] && ((bollateSignOut == YES) && [model.earlyAbnormal isEqualToString:@"0"])) || ([model.recordServiceLength isEqualToString:@"1"] && ([model.recordServiceLengthLess isEqualToString:@"1"] && [model.serviceLengthLessAbnormal isEqualToString:@"0"])) || ([model.recordMinServiceLength isEqualToString:@"1"] && ((bollateSignOutLess == YES) && [model.minServiceLengthLessAbnormal isEqualToString:@"0"]))){
                            // 终止 orderId  工单id   stopReason  终止原因
                            NSString *strReason;
                            if ([model.locationAbnormalSignOut isEqualToString:@"0"]) {
                                strReason = @"定位异常终止工单";
                            }else if ([model.earlyAbnormal isEqualToString:@"0"]){
                                strReason = @"早退异常终止工单";
                            }else if ([model.minServiceLengthLessAbnormal isEqualToString:@"0"]){
                                strReason = @"最低服务时长异常终止工单";
                            }else{
                                strReason = @"服务时长异常终止工单";
                            }
                            [[AppDelegate sharedDelegate] showTextOnly:strReason];
                            [[AFNetWorkingRequest sharedTool] requestOrderStop:@{@"orderId":self.orderinfo.id,@"stopReason":strReason} type:HttpRequestTypePost success:^(id responseObject) {
//                                [self.navigationController popViewControllerAnimated:YES];
                            } failure:^(NSError *error) {
                                [[AppDelegate sharedDelegate] showTextOnly:error.domain];
                            }];
                            
                        }else{
                            if ([model.codeScanSignOut isEqualToString:@"1"]) {// 扫码签出
                                AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                                scanOrder.ordertype = @"2";
                                scanOrder.detailsModel = model;
                                scanOrder.orderinfo = self.orderinfo;
                                [self.navigationController pushViewController:scanOrder animated:YES];
                                                   
                            }else{
                            _sgController.orderinfo = self.orderinfo;
                            _sgController.findAdmodel = model;
                            [self.navigationController pushViewController:_sgController animated:YES];
                                }
                        }
//                    }
               }else if([self.orderinfo.workStatus isEqualToString:@"1"]){
                   distanceSingin = [model.maxLocationDistanceSignIn doubleValue]-[self.distancePost doubleValue]; // 相差距离
                   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                   [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                   NSInteger mtime = [AktUtil getTimeDifferenceValueFrome:self.orderinfo.serviceBegin ToTime:[[AktUtil getNowDateAndTime] substringFromIndex:11]]; // 签入时间与当前时间的差值
                   BOOL bollateSignin = NO;
                   if (mtime<0) {// mtime<0 迟到
                       bollateSignin = (labs(mtime) - [model.maxLateTime integerValue])>0; // 超出最大迟到时间
                   }
                   
                   if (([model.recordLocationSignIn isEqualToString:@"1"] && [model.recordLocationAbnormalSignIn isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignIn isEqualToString:@"2"])) || ([model.recordLate isEqualToString:@"1"] && ((bollateSignin == YES) && [model.lateAbnormal isEqualToString:@"2"]))) {
                       NSLog(@"弹框");
                         
                       BOOL bollation = ([model.recordLocationSignIn isEqualToString:@"1"] && [model.recordLocationAbnormalSignIn isEqualToString:@"1"] && [model.locationAbnormalSignIn isEqualToString:@"2"]); // 定位弹框
                       BOOL bolLate = ([model.recordLate isEqualToString:@"1"] && (bollateSignin == YES) && [model.lateAbnormal isEqualToString:@"2"]); // 迟到弹框
                       if ([model.timeConflict isEqualToString:@"3"] || [model.timeConflict isEqualToString:@"0"] || [model.timeConflict isEqualToString:@"2"]){
                           [[AFNetWorkingRequest sharedTool] requestCheckSignInStatus:@{} type:HttpRequestTypeGet success:^(id responseObject) {
                               NSDictionary *dic = responseObject;
                               NSString *strcode = [dic objectForKey:ResponseCode];
                               if ([strcode integerValue] == 2) { // 有签入工单，暂停 timeConflict=2弹框继续
                                   if ([model.timeConflict isEqualToString:@"2"]){ // 弹框提示用户当前工单有进行中，让用户点击确定之后再继续
                                       [[AppDelegate sharedDelegate] showAlertView:@"温馨提示" des:@"您当前有其他正在进行的工单，\n 也要记得完成哦~" cancel:@"" action:@"确定" acHandle:^(UIAlertAction *action) {
                                           if ([model.codeScanSignIn isEqualToString:@"1"]) {// 扫码签入
                                               AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                                               scanOrder.ordertype = @"2";
                                               scanOrder.detailsModel = model;
                                               scanOrder.orderinfo = self.orderinfo;
                                               scanOrder.isnewLation = bollation;
                                               scanOrder.isnewlate = bolLate;
                                               [self.navigationController pushViewController:scanOrder animated:YES];
                                                                                        
                                            }else{
                                                _sgController.isnewLation = bollation;
                                                _sgController.isnewlate = bolLate;
                                                _sgController.orderinfo = self.orderinfo;
                                                _sgController.findAdmodel = model;
                                                [self.navigationController pushViewController:_sgController animated:YES];
                                                }
                                       }];
                                   }else{
                                       [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[dic objectForKey:ResponseMsg]]];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                               }else{
                                   if ([model.codeScanSignIn isEqualToString:@"1"]) {// 扫码签入
                                       AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                                       scanOrder.ordertype = @"2";
                                       scanOrder.detailsModel = model;
                                       scanOrder.orderinfo = self.orderinfo;
                                       scanOrder.isnewLation = bollation;
                                       scanOrder.isnewlate = bolLate;
                                       [self.navigationController pushViewController:scanOrder animated:YES];
                                                                                
                                    }else{
                                        _sgController.isnewLation = bollation;
                                        _sgController.isnewlate = bolLate;
                                        _sgController.orderinfo = self.orderinfo;
                                        _sgController.findAdmodel = model;
                                        [self.navigationController pushViewController:_sgController animated:YES];
                                        }
                               }
                           } failure:^(NSError *error) {}];
                       }else{
                       if ([model.codeScanSignIn isEqualToString:@"1"]) {// 扫码签入
                            AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                            scanOrder.ordertype = @"2";
                            scanOrder.detailsModel = model;
                            scanOrder.orderinfo = self.orderinfo;
                            scanOrder.isnewLation = bollation;
                            scanOrder.isnewlate = bolLate;
                            [self.navigationController pushViewController:scanOrder animated:YES];
                                              
                        }else{
                       _sgController.isnewLation = bollation;
                       _sgController.isnewlate = bolLate;
                       _sgController.orderinfo = self.orderinfo;
                       _sgController.findAdmodel = model;
                       [self.navigationController pushViewController:_sgController animated:YES];
                            }
                       }
                       
                   }else if (([model.recordLocationSignIn isEqualToString:@"1"] && [model.recordLocationAbnormalSignIn isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignIn isEqualToString:@"3"])) || ([model.recordLate isEqualToString:@"1"] && ((bollateSignin == YES) && [model.lateAbnormal isEqualToString:@"3"]))){
                       NSLog(@"暂停");
                       [[AppDelegate sharedDelegate] showTextOnly:@"订单异常，暂无法操作！"];
                   }else if ((([model.recordLocationSignIn isEqualToString:@"1"] && [model.recordLocationAbnormalSignIn isEqualToString:@"1"] && (distanceSingin<0 && [model.locationAbnormalSignIn isEqualToString:@"0"])) || ([model.recordLate isEqualToString:@"1"] && ((bollateSignin == YES) && [model.lateAbnormal isEqualToString:@"0"])))){
                       NSLog(@"返回首页");
                       // 终止 orderId  工单id   stopReason  终止原因
                       NSString *strReason;
                       if ([model.locationAbnormalSignIn isEqualToString:@"0"]) {
                           strReason = @"定位异常终止工单";
                       }else{
                           strReason = @"迟到异常终止工单";
                       }
                       [[AFNetWorkingRequest sharedTool] requestOrderStop:@{@"orderId":self.orderinfo.id,@"stopReason":strReason} type:HttpRequestTypePut success:^(id responseObject) {
                           [self.navigationController popViewControllerAnimated:YES];
                       } failure:^(NSError *error) {
                           [[AppDelegate sharedDelegate] showTextOnly:error.domain];
                       }];
                   }else if ([model.timeConflict isEqualToString:@"3"] || [model.timeConflict isEqualToString:@"0"] || [model.timeConflict isEqualToString:@"2"]){ // 请求新的接口
                       [[AFNetWorkingRequest sharedTool] requestCheckSignInStatus:@{} type:HttpRequestTypeGet success:^(id responseObject) {
                           NSDictionary *dic = responseObject;
                           NSString *strcode = [dic objectForKey:ResponseCode];
                           if ([strcode integerValue] == 2) { // 有签入工单，暂停 timeConflict=2弹框继续
                               if ([model.timeConflict isEqualToString:@"2"]){ // 弹框提示用户当前工单有进行中，让用户点击确定之后再继续
                                   [[AppDelegate sharedDelegate] showAlertView:@"温馨提示" des:@"您当前有其他正在进行的工单，\n 也要记得完成哦~" cancel:@"" action:@"确定" acHandle:^(UIAlertAction *action) {
                                       if ([model.codeScanSignIn isEqualToString:@"1"]) {// 扫码签入
                                           AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                                           scanOrder.ordertype = @"2";
                                           scanOrder.detailsModel = model;
                                           scanOrder.orderinfo = self.orderinfo;
                                           [self.navigationController pushViewController:scanOrder animated:YES];
                                                                                    
                                        }else{
                                       _sgController.orderinfo = self.orderinfo;
                                       _sgController.findAdmodel = model;
                                       [self.navigationController pushViewController:_sgController animated:YES];
                                            }
                                   }];
                               }else{
                                   [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[dic objectForKey:ResponseMsg]]];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                           }else{
                               if ([model.codeScanSignIn isEqualToString:@"1"]) {// 扫码签入
                                   AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                                   scanOrder.ordertype = @"2";
                                   scanOrder.detailsModel = model;
                                   scanOrder.orderinfo = self.orderinfo;
                                   [self.navigationController pushViewController:scanOrder animated:YES];
                                                                            
                                }else{
                               _sgController.orderinfo = self.orderinfo;
                               _sgController.findAdmodel = model;
                               [self.navigationController pushViewController:_sgController animated:YES];
                                    }
                           }
                       } failure:^(NSError *error) {}];
                   }else{
                       NSLog(@"继续");
                       if ([model.codeScanSignIn isEqualToString:@"1"]) {// 扫码签入
                           AktOrderScanVC *scanOrder = [AktOrderScanVC new];
                           scanOrder.ordertype = @"2";
                           scanOrder.detailsModel = model;
                           scanOrder.orderinfo = self.orderinfo;
                           [self.navigationController pushViewController:scanOrder animated:YES];
                                                                    
                        }else{
                       _sgController.orderinfo = self.orderinfo;
                       _sgController.findAdmodel = model;
                       [self.navigationController pushViewController:_sgController animated:YES];
                            }
                   }
                  
               }
        }
        NSLog(@"%@ \n %@ \n %@",strcode,[dic objectForKey:ResponseMsg],[dic objectForKey:ResponseData]);
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];

}

#pragma mark - showImageIn
-(void)showImageIn:(NSString *)type{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"加载中..."];
    NSDictionary * param;
    if ([type isEqualToString:@"1"]) {
        param = @{@"workOrderId":self.orderinfo.id,@"tenantsId":[LoginModel gets].tenantId,@"signType":@"101"};
    }else{
        param = @{@"workOrderId":self.orderinfo.id,@"tenantsId":[LoginModel gets].tenantId,@"signType":@"102"};
    }
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = [dic objectForKey:ResponseData];
            if(obj.count>0){
                AktOrderDetailsCheckImageVC *detailsImgVC = [[AktOrderDetailsCheckImageVC alloc] init];
                detailsImgVC.aryImg = obj;
                [self.navigationController pushViewController:detailsImgVC animated:YES];
            } else {
                [[AppDelegate sharedDelegate] showTextOnly:@"没有图片"];
            }
        }else{
            [self showMessageAlertWithController:self Message:@"没有图片"];
        }
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
    }];
}

-(void)showImageIn{
    [self showImageIn:@"1"];
}

-(void)closedPopview{
    for(UIView * v in self.view.subviews){
        if(v.tag == 10){
            [v removeFromSuperview];
        }
    }
}

-(void)showImageOut{
    [self showImageIn:@"2"];
}
#pragma mark - cell phone
-(void)didSelectPhonecomster:(NSString *)phone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}
-(void)didSelectAddressMap{
    
    NSMutableArray *maps = [NSMutableArray array];
     //苹果原生地图-苹果原生地图方法和其他不一样
     NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
     iosMapDic[@"title"] = @"苹果地图";
     [maps addObject:iosMapDic];
     //百度地图
     if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
      NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
      baiduMapDic[@"title"] = @"百度地图";
      NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%@&mode=driving&coord_type=gcj02",self.orderinfo.serviceAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      baiduMapDic[@"url"] = urlString;
      [maps addObject:baiduMapDic];
     }
     //高德地图
     if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
      NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
      gaodeMapDic[@"title"] = @"高德地图";
      NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"路线功能",@"nav123456",_latitude,_longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      gaodeMapDic[@"url"] = urlString;
      [maps addObject:gaodeMapDic];
     }
     //腾讯地图
     if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
      NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
      qqMapDic[@"title"] = @"腾讯地图";
      NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",_latitude, _longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      qqMapDic[@"url"] = urlString;
      [maps addObject:qqMapDic];
     }
     //选择
     UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     NSInteger index = maps.count;
     for (int i = 0; i < index; i++) {
      NSString * title = maps[i][@"title"];
      //苹果原生地图方法
      if (i == 0) {
       UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self navAppleMapnavAppleMapWithArray];
       }];
       [alert addAction:action];
       continue;
      }
      UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       NSString *urlString = maps[i][@"url"];
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
      }];
      [alert addAction:action];
     }
     UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     }];
     [alert addAction:action];
//     [[CPBaseViewController getCurrentVC] presentViewController:alert animated:YES completion:nil];
     [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 苹果地图
//苹果地图
- (void)navAppleMapnavAppleMapWithArray
{
 float lat = [NSString stringWithFormat:@"%@",_latitude].floatValue;
 float lon = [NSString stringWithFormat:@"%@",_longitude].floatValue;
 //终点坐标
 CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
 //用户位置
 MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
 //终点位置
 MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
 NSArray *items = @[currentLoc,toLocation];
 //第一个
 NSDictionary *dic = @{       MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,       MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),       MKLaunchOptionsShowsTrafficKey : @(YES)
       };
 //第二个，都可以用
 // NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
 //       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
 [MKMapItem openMapsWithItems:items launchOptions:dic];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}
#pragma mark - 地址转化坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
     [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
         //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
           CLPlacemark *placemark=[placemarks firstObject];
           CLLocation *location=placemark.location;//位置

           CLLocationDegrees latitude=location.coordinate.latitude;
           CLLocationDegrees longitude=location.coordinate.longitude;
           NSLog(@"纬度-->%lf,经度-->%lf",latitude,longitude);

           //传给接口的纬度和经度
           _latitude=[NSString stringWithFormat:@"%lf",latitude];

           _longitude=[NSString stringWithFormat:@"%lf",longitude];
     }];

}

@end
