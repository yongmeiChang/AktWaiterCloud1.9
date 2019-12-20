//
//  DownOrderController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/8.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "DownOrderController.h"
#import "DownOrderCell.h"
#import "ServicePojController.h"
#import "DownOrdersController.h"
#import "QRCodeViewController.h"
#import "DownOrderView.h"
#import "HandCodeController.h"
#import "AktAddOrderUserInfoCell.h" // 用户信息
#import "AktServiceRemarkCell.h" // 服务内容

@interface DownOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,HandDelegate,SearchDelegate,AktServiceRemarkCellDelegate>
{
    NSString *strAddress; // 详细地址
    NSString *strArea; //  市区
    NSString *strRemark; // 服务内容
}
@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong) UIPickerView * datePickView;
@property(nonatomic,strong) NSString * money;
@property(nonatomic,strong) NSString * Date;//给后台
@property(nonatomic,strong) NSString * bTime;//给后台
@property(nonatomic,strong) NSString * eTime;//给后台
@property(nonatomic,strong) NSString * serviceDate;
@property(nonatomic,strong) NSString * serviceBeginTime;
@property(nonatomic,strong) NSString * serviceEndTime;

@property(nonatomic,strong) NSMutableArray * yearArr;
@property(nonatomic,strong) NSMutableArray * monthArr;
@property(nonatomic,strong) NSMutableArray * dayArr;
@property(nonatomic,strong) NSMutableArray * AllArr;

@property(nonatomic,strong) NSMutableArray * hourArr;
@property(nonatomic,strong) NSMutableArray * minuteArr;
@property(nonatomic,strong) NSMutableArray * hmAllArr;

@property (nonatomic,strong) DownOrderView * doView;
@property(nonatomic,strong) UIButton * submitBtn;
@property(nonatomic,strong) UIView * bottomView;

@property(nonatomic,strong) NSDictionary * addressDic;
@property(nonatomic) int type;


@end

@implementation DownOrderController{
    NSString *selectedYear;
    NSString *selectecMonth;
    NSString *selectecDay;
    NSString *strhour;
    NSString *strminute;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentday;
    
    NSInteger hour;
    NSInteger minute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B2");
    strAddress = [[NSString alloc] init];
    strArea = [[NSString alloc] init];
    strRemark = [[NSString alloc] init];
    [self setNavTitle:@"添加工单"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    
    [self initDateArray];
    [self initDateBeginTime];
    [self initTableview];
    [self initButton];
}

-(void)viewWillAppear:(BOOL)animated{
    if(_servicepojInfo){
        //按时计算
        if([_servicepojInfo.unitType intValue]==1){
            _money = _servicepojInfo.serviceMoney;
            if([_money isEqualToString:@""]){
                _money = @"";
            }
            int isbig = [self compareDate];
            if(isbig==-1){
                float m =[_servicepojInfo.serviceMoney floatValue];
                long jg = [self computehour];
                float mon = m*jg;
                _money =  [NSString stringWithFormat:@"%f",mon];
            }
        }else if([_servicepojInfo.unitType intValue]== 2 || [_servicepojInfo.unitType isEqualToString:@""]){ //按次计算
            _money = _servicepojInfo.serviceMoney;
            if([_money isEqualToString:@""]){
                _money = @"免费";
            }
        }
        // 项目时间
        NSLog(@"%@--%@",_servicepojInfo.serviceBegin,_servicepojInfo.serviceEnd);
        if (_servicepojInfo.serviceBegin.length>16) {
            _serviceDate = [NSString stringWithFormat:@"%@",[AktUtil rangeDate:_servicepojInfo.serviceBegin]];// 日期
            _serviceBeginTime = [NSString stringWithFormat:@"%@",[AktUtil rangeDateAndTime:_servicepojInfo.serviceBegin]];// 开始时间
            _serviceEndTime = [NSString stringWithFormat:@"%@",[AktUtil rangeDateAndTime:_servicepojInfo.serviceEnd]]; // 结束时间
            _Date = [[NSString stringWithFormat:@"%@",_servicepojInfo.serviceBegin] substringToIndex:10];
            _bTime = [NSString stringWithFormat:@"%@",_servicepojInfo.serviceBegin];
            _eTime = [NSString stringWithFormat:@"%@",_servicepojInfo.serviceEnd];
        }
        [_tableview reloadData];
    }else{
        _serviceDate = [NSString stringWithFormat:@"%@",[AktUtil rangeDate:self.dofInfo.serviceDate]];
        _serviceBeginTime = [NSString stringWithFormat:@"%@",[AktUtil rangeDateAndTime:self.dofInfo.serviceBegin]];
        _serviceEndTime = [NSString stringWithFormat:@"%@",[AktUtil rangeDateAndTime:self.dofInfo.serviceEnd]];
        _Date = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceDate)];
        _bTime = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceBegin)];
        _eTime = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceEnd)];
    }
}

#pragma mark - init time
-(id)initDownOrderControllerWithCustomerUkey:(DownOrderFirstInfo *)oldman customerUkey:(NSString *)customerUkey{
    if(self = [super init]){
        self.dofInfo = oldman;
        self.customerUkey = customerUkey;
        return self;
    }else{
        return nil;
    }
}

-(long)computehour{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *bdate = [formatter dateFromString:_serviceBeginTime];
    NSDate *edate = [formatter dateFromString:_serviceEndTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:edate toDate:bdate options:0];
    long jg = cmps.day*24+cmps.hour;
    return jg;
}

-(int)compareDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *bdate = [formatter dateFromString:_bTime];
    NSDate *edate = [formatter dateFromString:_eTime];
    NSComparisonResult result = [bdate compare:edate];
    NSLog(@"date1 : %@, date2 : %@", bdate, edate);
    if (result == NSOrderedDescending) {
        return 1;
    }
    //b>=e
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
}

-(void)initDateBeginTime{
    
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@" "];
    NSString * date = [dateArray objectAtIndex:0];
    //拆分年月成数组
    NSArray *dateArr = [date componentsSeparatedByString:@"-"];
    if (dateArray.count == 3) {//年 月
        currentYear = [[dateArr firstObject]integerValue];
        currentMonth =  [dateArr[1] integerValue];
        currentday = [dateArr[2] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
    selectecDay = [NSString stringWithFormat:@"%ld",(long)currentday];
    
    //初始化年数据源数组
    _yearArr = [[NSMutableArray alloc]init];
    for (NSInteger i = currentYear; i <= 2099 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)i];
        [_yearArr addObject:yearStr];
    }
    
    _monthArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
        [_monthArr addObject:monthStr];
    }
    
    _dayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 30; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld日",(long)i];
        [_dayArr addObject:dayStr];
    }
    
    
    
    NSString * da = dateArray[1];
    dateArray = [da componentsSeparatedByString:@":"];
    strhour = [dateArray objectAtIndex:0];
    strminute = [dateArray objectAtIndex:1];
    hour = [strhour integerValue];
    minute = [strminute integerValue];
    
    _hourArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= 23 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld时",(long)i];
        [_hourArr addObject:yearStr];
    }
    
    _minuteArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= 59 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld分",(long)i];
        [_minuteArr addObject:yearStr];
    }
    
    _hmAllArr = [NSMutableArray array];
    [_hmAllArr addObject:_yearArr];
    [_hmAllArr addObject:_monthArr];
    [_hmAllArr addObject:_dayArr];
    [_hmAllArr addObject:_hourArr];
    [_hmAllArr addObject:_minuteArr];
}


-(void)initDateArray{
    
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 3) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
        currentday = [dateArray[2] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
    selectecDay = [NSString stringWithFormat:@"%ld",(long)currentday];
    //初始化年数据源数组
    _yearArr = [[NSMutableArray alloc]init];
    for (NSInteger i = currentYear; i <= 2099 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)i];
        [_yearArr addObject:yearStr];
    }
    
    _monthArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
        [_monthArr addObject:monthStr];
    }
    
    _dayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 30; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld日",(long)i];
        [_dayArr addObject:dayStr];
    }
    _AllArr = [NSMutableArray arrayWithCapacity:3];
    [_AllArr addObject:_yearArr];
    [_AllArr addObject:_monthArr];
    [_AllArr addObject:_dayArr];
}

#pragma mark - init
-(void)initTableview{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-123) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.bounces = NO;
}

-(void)initButton{
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.5, SCREEN_HEIGHT-self.tableview.frame.size.height-74, SCREEN_WIDTH-20, 74)];
    [_submitBtn addTarget:self action:@selector(SubmitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableview.mas_bottom).offset(0);
        make.left.mas_equalTo(10.5);
        make.right.mas_equalTo(-9.5);
        make.height.mas_equalTo(64);
    }];
    [_submitBtn setHidden: NO];
}

#pragma mark - nav back
-(void)LeftBarClick{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 提交工单
-(void)SubmitBtnClick{
    
    int ok = [self compareDate];
    if(ok!=-1){
        [SVProgressHUD showInfoWithStatus:@"日期格式不符合要求"];
        return;
    }
    
    if(kString(_servicepojInfo.name).length==0){
        [SVProgressHUD showInfoWithStatus:@"请选择服务项目"];
        return;
    }
    if(kString(_serviceDate).length==0){
        [SVProgressHUD showInfoWithStatus:@"请选择服务日期"];
        return;
    }
    if(kString(_serviceBeginTime).length==0){
        [SVProgressHUD showInfoWithStatus:@"请选择服务开始时间"];
        return;
    }
    if(kString(_serviceEndTime).length==0){
        [SVProgressHUD showInfoWithStatus:@"请选择服务结束时间"];
        return;
    }
//    if(_phoneTfield.text==nil){
//        [SVProgressHUD showInfoWithStatus:@"用户电话不能为空"];
//        return;
//    }
    if(strArea.length==0){
        [SVProgressHUD showInfoWithStatus:@"服务区域不能为空"];
        return;
    }
    if(strAddress.length==0){
        [SVProgressHUD showInfoWithStatus:@"服务地址不能为空"];
        return;
    }
    NSArray * bg =  [_bTime componentsSeparatedByString:@" "];;
    NSString * btstr = bg[0];
    if(![_Date isEqualToString:btstr]){
        [SVProgressHUD showInfoWithStatus:@"服务日期与服务开始时间不相符"];
        return;
    }
    
    
    NSLog(@"点击下单按钮");
    [_submitBtn setEnabled:false];
    [self requestSubmit];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"提交中"];
}

-(void)requestSubmit{
    NSMutableDictionary *paremeter = [NSMutableDictionary dictionary];
    [paremeter addUnEmptyString:_customerUkey forKey:@"customerUkey"];
    [paremeter addUnEmptyString:_servicepojInfo.id forKey:@"serviceItemId"];
    [paremeter addUnEmptyString:_servicepojInfo.name forKey:@"serviceItemName"];
    [paremeter addUnEmptyString:_dofInfo.serviceAddress forKey:@"serviceAddress"];
    [paremeter addUnEmptyString:_Date forKey:@"serviceDate"];
    [paremeter addUnEmptyString:_bTime forKey:@"serviceBegin"];
    [paremeter addUnEmptyString:_eTime forKey:@"serviceEnd"];
    [paremeter addUnEmptyString:strRemark forKey:@"serviceContent"]; // 服务内容
    [paremeter addUnEmptyString:_money forKey:@"serviceMoney"];
    [paremeter addUnEmptyString:appDelegate.userinfo.id forKey:@"waiterId"];
    [paremeter addUnEmptyString:appDelegate.userinfo.waiterName forKey:@"waiterName"];
    [[AFNetWorkingRequest sharedTool] requestsubmitOrder:paremeter type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSLog(@"%@",dic[@"message"]);
        NSNumber * code = dic[@"code"];
        if([code longValue] == 1){
            [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for(UIView * view in self.view.subviews){
                    [view removeFromSuperview];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changerootview" object:nil userInfo:nil];
                [SVProgressHUD dismiss];
                
            });
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:dic[@"message"]];
            [_submitBtn setEnabled:YES];
            }
    } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"提交失败，请重新提交!"];
            [_submitBtn setEnabled:YES];
    }];
}


#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_dofInfo){
        return 3;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==1?4:1;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        static NSString *cellidentify = @"userCell";
        AktAddOrderUserInfoCell *cell = (AktAddOrderUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AktAddOrderUserInfoCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.labName.text = _dofInfo.customerName;
        cell.labPhone.text = _dofInfo.customerPhone;
        cell.labArea.text = _dofInfo.serviceAreaName;
        strArea = _dofInfo.serviceAreaName;
        cell.labAddress.text = _dofInfo.serviceAddress;
        strAddress = _dofInfo.serviceAddress;
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellidentify = @"DownOrderCell";
        DownOrderCell *cell = (DownOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DownOrderCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell setOrderInfo:indexPath];
        if (indexPath.row == 0) {
            cell.labValue.text = _servicepojInfo.name;
        }else if (indexPath.row == 1){
            cell.labValue.text = _serviceDate;
        }else if (indexPath.row == 2){
             cell.labValue.text = _serviceBeginTime;
        }else{
            cell.labValue.text = _serviceEndTime;
        }
        return cell;
        
    }else{
        static NSString *cellidentify = @"AktServiceRemarkCell";
        AktServiceRemarkCell *cell = (AktServiceRemarkCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AktServiceRemarkCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self;
         return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section==1?53:150.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        if(indexPath.row==0){
            ServicePojController * spController = [[ServicePojController alloc] init];
            spController.DoContoller = self;
            spController.selectInfo = self.servicepojInfo;
            [self.navigationController pushViewController:spController animated:YES];
        }else if(indexPath.row==1){
            //            _type = 1;
            //            _datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-SCREEN_HEIGHT/3-165 , SCREEN_WIDTH, SCREEN_HEIGHT/3)];
            //            _datePickView.showsSelectionIndicator = YES;
            //            _datePickView.backgroundColor = [UIColor grayColor];
            //            _datePickView.alpha = 1;
            //            _datePickView.delegate = self;
            //            [_datePickView selectRow:0 inComponent:0 animated:NO];
            //            [_datePickView selectRow:currentMonth-1 inComponent:1 animated:NO];
            //            [_datePickView selectRow:currentday-1 inComponent:2 animated:NO];
            //
            //            [self.view addSubview:_datePickView];
            //
            //            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-165 , SCREEN_WIDTH, SCREEN_HEIGHT/3)];
            //            _bottomView.backgroundColor = [UIColor grayColor];
            //            UIButton * canelBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 5, 200, 40)];
            //            UIButton * okBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 60, 200, 40)];
            //
            //            [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
            //            [canelBtn addTarget:self action:@selector(canelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            //            [okBtn setTitle:@"确定" forState:UIControlStateNormal];
            //            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            //            canelBtn.backgroundColor = [UIColor brownColor];
            //            okBtn.backgroundColor = [UIColor brownColor];
            //            [_bottomView addSubview:canelBtn];
            //            [_bottomView addSubview:okBtn];
            //            [self.view addSubview:_bottomView];
        }else if(indexPath.row==2){
            _type = 2;
            if(self.datePickView){
                [self.datePickView removeFromSuperview];
            }
            if(self.bottomView){
                [self.bottomView removeFromSuperview];
            }
            _datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-SCREEN_HEIGHT/2-165 , SCREEN_WIDTH, SCREEN_HEIGHT/2)];
            _datePickView.showsSelectionIndicator = YES;
            _datePickView.backgroundColor = [UIColor whiteColor];
            _datePickView.alpha = 1;
            _datePickView.delegate = self;
            [_datePickView selectRow:0 inComponent:0 animated:NO];
            [_datePickView selectRow:currentMonth-1 inComponent:1 animated:NO];
            [_datePickView selectRow:currentday-1 inComponent:2 animated:NO];
            [_datePickView selectRow:hour inComponent:3 animated:NO];
            [_datePickView selectRow:minute inComponent:4 animated:NO];
            
            [self.view addSubview:_datePickView];
            
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-165 , SCREEN_WIDTH, SCREEN_HEIGHT/4)];
            _bottomView.backgroundColor = [UIColor whiteColor];
            UIButton * canelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 40)];
            
            UIButton * okBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2-20, 5, 100, 40)];
            
            
            canelBtn.layer.cornerRadius =10.0f;
            okBtn.layer.cornerRadius =10.0f;
            
            [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [canelBtn addTarget:self action:@selector(canelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [okBtn setTitle:@"确定" forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [canelBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            [okBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            [self.view addSubview:_bottomView];
            
            [_datePickView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(SCREEN_HEIGHT/4);
            }];
            
            [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.datePickView.mas_top).offset(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(60);
            }];
            [_bottomView addSubview:canelBtn];
            [_bottomView addSubview:okBtn];
            [canelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.width.mas_equalTo(SCREEN_WIDTH*0.5-5);
                make.centerY.equalTo(self.bottomView.mas_centerY).offset(0);
                make.height.mas_equalTo(40);
            }];
            
            [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.left.equalTo(canelBtn.mas_right).offset(5);
                make.centerY.equalTo(self.bottomView.mas_centerY).offset(0);
                make.height.mas_equalTo(40);
            }];
        }else if(indexPath.row==3){
            _type = 3;
            if(self.datePickView){
                [self.datePickView removeFromSuperview];
            }
            if(self.bottomView){
                [self.bottomView removeFromSuperview];
            }
            _datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-SCREEN_HEIGHT/2-165 , SCREEN_WIDTH, SCREEN_HEIGHT/2)];
            _datePickView.showsSelectionIndicator = YES;
            _datePickView.backgroundColor = [UIColor whiteColor];
            _datePickView.alpha = 1;
            _datePickView.delegate = self;
            [_datePickView selectRow:0 inComponent:0 animated:NO];
            [_datePickView selectRow:currentMonth-1 inComponent:1 animated:NO];
            [_datePickView selectRow:currentday-1 inComponent:2 animated:NO];
            [_datePickView selectRow:hour inComponent:3 animated:NO];
            [_datePickView selectRow:minute inComponent:4 animated:NO];
            
            [self.view addSubview:_datePickView];
            
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-165 , SCREEN_WIDTH, SCREEN_HEIGHT/4)];
            _bottomView.backgroundColor = [UIColor whiteColor];
            UIButton * canelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 100, 40)];
            
            UIButton * okBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2-20, 5, 100, 40)];
            
            
            canelBtn.layer.cornerRadius =10.0f;
            okBtn.layer.cornerRadius =10.0f;
            
            [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [canelBtn addTarget:self action:@selector(canelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [okBtn setTitle:@"确定" forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [canelBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            [okBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
            [self.view addSubview:_bottomView];
            
            [_datePickView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(SCREEN_HEIGHT/4);
            }];
            
            [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.datePickView.mas_top).offset(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(60);
            }];
            [_bottomView addSubview:canelBtn];
            [_bottomView addSubview:okBtn];
            [canelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.width.mas_equalTo(SCREEN_WIDTH*0.5-5);
                make.centerY.equalTo(self.bottomView.mas_centerY).offset(0);
                make.height.mas_equalTo(40);
            }];
            
            [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.left.equalTo(canelBtn.mas_right).offset(5);
                make.centerY.equalTo(self.bottomView.mas_centerY).offset(0);
                make.height.mas_equalTo(40);
            }];
        }else if(indexPath.row==4){
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - remark cell delegate
-(void)remarkChangeDelegateText:(NSString *)remak{
    strRemark = remak;
}

#pragma mark - click
-(void)ClickReload{
    NSLog(@"点击了重新计算");
    [self showMessageAlertWithController:self Message:@"计算完毕"];
}

#pragma make - cancel
-(void)canelBtnClick{
    [self.datePickView removeFromSuperview];
    [self.bottomView removeFromSuperview];
}

-(void)okBtnClick{
    [self.datePickView removeFromSuperview];
    [self.bottomView removeFromSuperview];

    if(_type==1){
        //        NSInteger yrow=[_datePickView selectedRowInComponent:0];
        //        NSString *subStringYear=[_yearArr objectAtIndex:yrow];
        //        NSString * year = [subStringYear substringToIndex:[subStringYear length] - 1];
        //
        //        NSInteger mrow=[_datePickView selectedRowInComponent:1];
        //        NSString *subStringMonth=[_monthArr objectAtIndex:mrow];
        //        NSString *month = [subStringMonth substringToIndex:[subStringMonth length] - 1];
        //
        //        NSInteger drow=[_datePickView selectedRowInComponent:2];
        //        NSString *subStringDay=[_dayArr objectAtIndex:drow];
        //        NSString * day = [subStringDay substringToIndex:[subStringDay length] - 1];
        //        _serviceDate = [NSString stringWithFormat:@"%@%@%@",subStringYear,subStringMonth,subStringDay];
        //        _Date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }else if(_type==2){
        NSInteger yrow=[_datePickView selectedRowInComponent:0];
        NSString *subStringYear=[_yearArr objectAtIndex:yrow];
        NSString * year = [subStringYear substringToIndex:[subStringYear length] - 1];
        
        NSInteger mrow=[_datePickView selectedRowInComponent:1];
        NSString *subStringMonth=[_monthArr objectAtIndex:mrow];
        NSString *month = [subStringMonth substringToIndex:[subStringMonth length] - 1];
        if(month.length==1){
            month = [NSString stringWithFormat:@"0%@",month];
        }
        
        NSInteger drow=[_datePickView selectedRowInComponent:2];
        NSString *subStringDay=[_dayArr objectAtIndex:drow];
        NSString * day = [subStringDay substringToIndex:[subStringDay length] - 1];
        if(day.length==1){
            day = [NSString stringWithFormat:@"0%@",day];
        }
        
        NSInteger hrow=[_datePickView selectedRowInComponent:3];
        NSString *subStringHour=[_hourArr objectAtIndex:hrow];
        NSString *hours =[subStringHour substringToIndex:[subStringHour length] - 1];
        if(hours.length==1){
            hours = [NSString stringWithFormat:@"0%@",hours];
        }
        
        NSInteger minuterow=[_datePickView selectedRowInComponent:4];
        NSString *subStringMinute=[_minuteArr objectAtIndex:minuterow];
        NSString *minutes =[subStringMinute substringToIndex:[subStringMinute length] - 1];
        if(minutes.length==1){
            minutes = [NSString stringWithFormat:@"0%@",minutes];
        }
        
        _serviceDate = [NSString stringWithFormat:@"%@%@%@",subStringYear,subStringMonth,subStringDay];
        _Date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
        _serviceBeginTime = [NSString stringWithFormat:@"%@%@%@ %@:%@",subStringYear,subStringMonth,subStringDay,subStringHour,subStringMinute];
        _bTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hours,minutes];
        
    }else if(_type ==3){
        NSInteger yrow=[_datePickView selectedRowInComponent:0];
        NSString *subStringYear=[_yearArr objectAtIndex:yrow];
        NSString * year = [subStringYear substringToIndex:[subStringYear length] - 1];
        
        NSInteger mrow=[_datePickView selectedRowInComponent:1];
        NSString *subStringMonth=[_monthArr objectAtIndex:mrow];
        NSString *month = [subStringMonth substringToIndex:[subStringMonth length] - 1];
        if(month.length==1){
            month = [NSString stringWithFormat:@"0%@",month];
        }
        
        NSInteger drow=[_datePickView selectedRowInComponent:2];
        NSString *subStringDay=[_dayArr objectAtIndex:drow];
        NSString * day = [subStringDay substringToIndex:[subStringDay length] - 1];
        if(day.length==1){
            day = [NSString stringWithFormat:@"0%@",day];
        }
        
        NSInteger hrow=[_datePickView selectedRowInComponent:3];
        NSString *subStringHour=[_hourArr objectAtIndex:hrow];
        NSString *hours =[subStringHour substringToIndex:[subStringHour length] - 1];
        if(hours.length==1){
            hours = [NSString stringWithFormat:@"0%@",hours];
        }
        
        NSInteger minuterow=[_datePickView selectedRowInComponent:4];
        NSString *subStringMinute=[_minuteArr objectAtIndex:minuterow];
        NSString *minutes =[subStringMinute substringToIndex:[subStringMinute length] - 1];
        if(minutes.length==1){
            minutes = [NSString stringWithFormat:@"0%@",minutes];
        }
        
        _serviceEndTime = [NSString stringWithFormat:@"%@%@%@ %@:%@",subStringYear,subStringMonth,subStringDay,subStringHour,subStringMinute];
        _eTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hours,minutes];
    }
    if([self.servicepojInfo.unitType intValue] == 1){
        if(![_bTime isEqualToString:@""]&&![_eTime isEqualToString:@""]){
            float times = [self computehour];
            _money = [NSString stringWithFormat:@"%f",times*[self.servicepojInfo.serviceMoney floatValue]];
        }
    }
   
    [self.tableview reloadData];
}

#pragma mark - uipickview delegate

// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(_type==1){
        return _AllArr.count;
        
    }else{
        return _hmAllArr.count;
    }
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(_type==1){
        NSArray *items = self.AllArr[component];
        return items.count;
    }else{
        NSArray *items = self.hmAllArr[component];
        return items.count;
    }
    
}
// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(_type==1){
        return self.AllArr[component][row];
    }else{
        return self.hmAllArr[component][row];
    }
}


//滑动事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
//    NSLog(@"%@----%@-----%@----%@-----%@",_yearArr[component][row],_monthArr[component][row],_dayArr[component][row],_hourArr[component][row],_monthArr[component][row]);
    if(component==1){
        if(row==0||row==2||row==4||row==6||row==7||row==9||row==11){
            _dayArr = [[NSMutableArray alloc]init];
            for (NSInteger i = 1 ; i <= 31; i++) {
                NSString *dayStr = [NSString stringWithFormat:@"%ld日",i];
                [_dayArr addObject:dayStr];
            }
            if(_type==1){
                [self.AllArr replaceObjectAtIndex:2 withObject:_dayArr];
            }else{
                [self.hmAllArr replaceObjectAtIndex:2 withObject:_dayArr];
            }
             [self.datePickView reloadComponent:2];
        }else if(row == 1){
            _dayArr = [[NSMutableArray alloc]init];
            for (NSInteger i = 1 ; i <= 28; i++) {
                NSString *dayStr = [NSString stringWithFormat:@"%ld日",i];
                [_dayArr addObject:dayStr];
            }
            if(_type==1){
                [self.AllArr replaceObjectAtIndex:2 withObject:_dayArr];
            }else{
                [self.hmAllArr replaceObjectAtIndex:2 withObject:_dayArr];
            }
            [self.datePickView reloadComponent:2];
        }else{
            _dayArr = [[NSMutableArray alloc]init];
            for (NSInteger i = 1 ; i <= 30; i++) {
                NSString *dayStr = [NSString stringWithFormat:@"%ld日",i];
                [_dayArr addObject:dayStr];
            }
            if(_type==1){
                [self.AllArr replaceObjectAtIndex:2 withObject:_dayArr];
            }else{
                [self.hmAllArr replaceObjectAtIndex:2 withObject:_dayArr];
            }
            [self.datePickView reloadComponent:2];
        }
    }
}

//重写字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
