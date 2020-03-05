//
//  MinuteTaskController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MinuteTaskController.h"
#import "OrderTaskFmdb.h"
#import "PlanTaskCell.h"
#import "SignInCell.h"
#import "SignoutController.h"
#import "EditOrderController.h"
#import "VisitCell.h"
#import "NoDateCell.h"
#import <CoreLocation/CoreLocation.h>
@interface MinuteTaskController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,PlanTaskPhoneDelegate>
{
    CLGeocoder *_geocoder;
    NSString *_latitude;//纬度
    NSString *_longitude;//经度
}
@property(nonatomic,strong) OrderTaskFmdb * orderfmdb;
@property(nonatomic,strong) OrderInfo * orderinfo;
@property(weak,nonatomic) IBOutlet UITableView * minuteTaskTableView;

@property(nonatomic,strong) UILabel * signinDateLabel;//签入日期
@property(nonatomic,strong) UILabel * signoutDateLabel;//签出日期
@property(nonatomic,strong) UILabel * signoutDateLengthLabel;//签出服务时长
@property(nonatomic,strong) SignoutController * sgController;

@property (weak, nonatomic) IBOutlet UIButton *btnSingInOrSingOut;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewTop;

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
    
    if([self.type isEqualToString:@"1"]){ // 我的-工单任务
        self.viewHeightConstraint.constant = 0;
    }else{ // 任务
        self.viewHeightConstraint.constant = 84;
    }
    _geocoder=[[CLGeocoder alloc]init];
    [self getCoordinateByAddress:self.orderinfo.serviceAddress];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _sgController = [[SignoutController alloc] init];
    if([self.orderinfo.workStatus isEqualToString:@"4"]){
        _sgController.type = 1;
         [self.btnSingInOrSingOut setTitle:@"任务签出" forState:UIControlStateNormal];
    }else if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]){
        _sgController.type = 0;
         [self.btnSingInOrSingOut setTitle:@"任务签入" forState:UIControlStateNormal];
    }
}

#pragma mark - showUserMoney
-(void)showUserMoney{ //显示用户余额
 
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"请求中..."];
    NSDictionary * param = @{@"customerId":_orderinfo.customerId,@"customerName":_orderinfo.customerName,@"tenantsId":appDelegate.userinfo.tenantsId};
    [[AFNetWorkingRequest sharedTool] requestWithGetCustomerBalanceParameters:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        NSString * message = @"";
        if([code intValue] == 1){
            NSString * object = dic[@"object"];
            message = [[object componentsSeparatedByString:@"："] objectAtIndex:1];
            [self showMessageAlertWithController:self title:@"" Message:message canelBlock:^{
                
            }];
        }else{
            message = [dic objectForKey:@"message"];
            [self showMessageAlertWithController:self Message:message];
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}

-(void)clickEdit{
    EditOrderController * eoController = [[EditOrderController alloc] init];
    eoController.serviceid = self.orderinfo.serviceItemId;
    eoController.untype = self.orderinfo.unitType;
    eoController.oldmoney = self.orderinfo.serviceMoney;
    eoController.oldBeginTime = self.orderinfo.serviceBegin;
    eoController.workstuats = self.orderinfo.workStatus;
    eoController.oldEndTime = self.orderinfo.serviceEnd;
    eoController.workid = self.orderinfo.id;
    eoController.workNo = self.orderinfo.workNo;
    eoController.stationId = self.orderinfo.stationId;
    eoController.oldService = self.orderinfo.serviceItemName;
    [self.navigationController pushViewController:eoController animated:YES];
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
    if([Vaildate dx_isNullOrNilWithObject:self.orderinfo]){
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 200;
    }else if(indexPath.section==1){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
            return 105.5;
        }else{
            return 180;
        }
    }else if(indexPath.section==2){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"4"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
            return 105.5;
        }else{
            return 240;
        }
    }else if(indexPath.section==3){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"4"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
            return 105.5;
        }else{
            return 177;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
       return 0.01;
}

/**Cell生成*/
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
        [cell setOrderList:self.orderinfo];
        return cell;
    }else if(indexPath.section==1){

        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"11"]){

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
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"4"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
        
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
            
            if([self.orderinfo.workStatus isEqualToString:@"6"]||[self.orderinfo.workStatus isEqualToString:@"8"]||[self.orderinfo.workStatus isEqualToString:@"10"]){
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
    _sgController.orderinfo = self.orderinfo;
       [self.navigationController pushViewController:_sgController animated:YES];
}

#pragma mark - showImageIn
-(void)showImageIn{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"加载中..."];
    NSDictionary * param = @{@"workOrderId":self.orderinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"signType":@"101"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = dic[@"object"];
            if(obj.count>0){
                
                UIView * popview = [[UIView alloc] init];
                popview.backgroundColor = [UIColor grayColor];
                [popview setTag:10];
                [self.view addSubview:popview];

                UIScrollView *scollBg = [[UIScrollView alloc] init];
                scollBg.contentSize = CGSizeMake(SCREEN_WIDTH*obj.count, SCREEN_WIDTH);
                scollBg.pagingEnabled = YES;
                [popview addSubview:scollBg];
                
                for (int i = 0; i<obj.count; i++) {
                    NSDictionary * object = obj[i];
                    NSString * affixName = object[@"affixUrl"];
                    NSString * imagebaseStr = [NSString stringWithFormat:@"%@",affixName];
                    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imagebaseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    photoImageView.image = [UIImage imageWithData:imageData];
                    [scollBg addSubview:photoImageView];
                    
                }
                
                UIButton * closeBtn = [[UIButton alloc] init];
                [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
                [closeBtn addTarget:self action:@selector(closedPopview) forControlEvents:UIControlEventTouchUpInside];
                [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [popview addSubview: closeBtn];

                [popview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(AktNavAndStatusHight);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(SCREEN_HEIGHT-AktNavAndStatusHight);
                }];
                [scollBg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.mas_equalTo(0);
                }];
                
                [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(popview.mas_right).offset(0);
                    make.top.equalTo(popview.mas_top).offset(0);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(30);
                }];
                
            }
        }else{
            [self showMessageAlertWithController:self Message:@"没有图片"];
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}

-(void)closedPopview{
    for(UIView * v in self.view.subviews){
        if(v.tag == 10){
            [v removeFromSuperview];
        }
    }
}

-(void)showImageOut{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"加载中..."];
    NSDictionary * param = @{@"workOrderId":self.orderinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"signType":@"102"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = dic[@"object"];
            
            UIView * popview = [[UIView alloc] init];
            popview.backgroundColor = [UIColor grayColor];
            [self.view addSubview:popview];
            
            UIScrollView *scollBg = [[UIScrollView alloc] init];
            scollBg.contentSize = CGSizeMake(SCREEN_WIDTH*obj.count, SCREEN_WIDTH);
            scollBg.pagingEnabled = YES;
            [popview addSubview:scollBg];
            
            for (int i = 0; i<obj.count; i++) {
                NSDictionary * object = obj[i];
                NSString * affixName = object[@"affixUrl"];
                NSString * imagebaseStr = [NSString stringWithFormat:@"%@",affixName];
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imagebaseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                photoImageView.image = [UIImage imageWithData:imageData];
                [scollBg addSubview:photoImageView];
                
            }
            
            UIButton * closeBtn = [[UIButton alloc] init];
                [popview setTag:10];
                [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
                [closeBtn addTarget:self action:@selector(closedPopview) forControlEvents:UIControlEventTouchUpInside];
                [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [popview addSubview: closeBtn];
         
            [popview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(AktNavAndStatusHight);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(SCREEN_HEIGHT-AktNavAndStatusHight);
            }];
            [scollBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(popview.mas_right).offset(0);
                make.top.equalTo(popview.mas_top).offset(0);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(30);
            }];
            
        }else{
            [self showMessageAlertWithController:self Message:@"没有图片"];
        }
        
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
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
     //谷歌地图
    /* if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
      NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
      googleMapDic[@"title"] = @"谷歌地图";
         NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@&directionsmode=driving",@"导航功能",@"nav123456",self.orderinfo.serviceAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      googleMapDic[@"url"] = urlString;
      [maps addObject:googleMapDic];
     }*/
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

//日期比较
-(int)compareDate:(NSDate *)btime endtime:(NSDate *)etime{
    NSComparisonResult result = [btime compare:etime];
    NSLog(@"date1 : %@, date2 : %@", btime, etime);
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
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
