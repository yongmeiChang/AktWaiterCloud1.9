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
#import "AktAddOrderUserInfoCell.h" // 用户信息
#import "AktServiceRemarkCell.h" // 服务内容
#import "DateAndTimePickerView.h"

@interface DownOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AktServiceRemarkCellDelegate,DateAndTimePickerViewDelegate>
{
    NSString *strAddress; // 详细地址
    NSString *strArea; //  市区
    NSString *strRemark; // 服务内容
}
@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong) NSString * money; // 金额
@property(nonatomic,strong) NSString * Date;//给后台 开始日期
@property(nonatomic,strong) NSString * eDate;//给后台 结束日期
@property(nonatomic,strong) NSString * bTime;//给后台 开始时间
@property(nonatomic,strong) NSString * eTime;//给后台 结束时间

@property(nonatomic,strong) NSDictionary * addressDic;
@property(nonatomic) int type;
// 服务日期选项
@property (nonatomic, strong) DateAndTimePickerView *timePickerView;

@end

@implementation DownOrderController
#pragma mark - date time
-(void)serviceEndDate:(NSString *)Nowdate Validity:(NSString *)type{
    // 日期格式化类
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    myDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *newDate = [myDateFormatter dateFromString:Nowdate];
    
    
    if ([type isEqualToString:@"0"]) { // 开始日期所在周
       if (newDate == nil) {
             newDate = [NSDate date];
         }
         double interval = 0;
         NSDate *beginDate = nil;
         NSDate *endDate = nil;
         
         NSCalendar *calendar = [NSCalendar currentCalendar];
         [calendar setFirstWeekday:2];//设定周一为周首日
         BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginDate interval:&interval forDate:newDate];
         // 分别修改为 NSCalendarUnitDay NSCalendarUnitWeekOfYear NSCalendarUnitYear
         if (ok) {
             endDate = [beginDate dateByAddingTimeInterval:interval-1];
         }else {
             return;
         }

         NSString *beginString = [myDateFormatter stringFromDate:beginDate];
         NSString *endString = [myDateFormatter stringFromDate:endDate];
         NSLog(@"所在周:%@-%@",beginString,endString);
        _eDate = endString;
    }else if ([type isEqualToString:@"-1"]){ // 开始日期所在月
        if (newDate == nil) {
                 newDate = [NSDate date];
             }
             double interval = 0;
             NSDate *beginDate = nil;
             NSDate *endDate = nil;
             
             NSCalendar *calendar = [NSCalendar currentCalendar];
             [calendar setFirstWeekday:2];//设定周一为周首日
             BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
             // 分别修改为 NSCalendarUnitDay NSCalendarUnitWeekOfYear NSCalendarUnitYear
             if (ok) {
                 endDate = [beginDate dateByAddingTimeInterval:interval-1];
             }else {
                 return;
             }

             NSString *beginString = [myDateFormatter stringFromDate:beginDate];
             NSString *endString = [myDateFormatter stringFromDate:endDate];
             NSLog(@"所在月:%@-%@",beginString,endString);
            _eDate = endString;
    }else{
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];// 设置日期格式 为了转换成功
//        format.dateFormat = @"yyyy-MM-dd";
//        NSDate *newDate = [format dateFromString:Nowdate];
        // 推迟天数
        int daysLate = [type intValue];
        NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
        NSDate *appointDate = [newDate initWithTimeIntervalSinceNow: oneDay * daysLate];
        NSString *LastdateStr = [NSString stringWithFormat:@"%@",[myDateFormatter stringFromDate:appointDate]];
        NSLog(@"days:%@", LastdateStr);
        _eDate = kString(LastdateStr);
    }
}

-(void)serviceEndTime:(NSString *)time serviceTime:(NSString *)length timeUnit:(NSString *)unit{
    NSString * h; // 时
    NSString * m; // 分
    NSString * s; // 秒
    NSArray * arrTime = [time componentsSeparatedByString:@":"];
    h  = [NSString stringWithFormat:@"%@",arrTime[0]];
    m  = [NSString stringWithFormat:@"%@",arrTime[1]];
    s  = [NSString stringWithFormat:@"%@",arrTime[2]];
    
    if ([unit isEqualToString:@"1"]) { // 小时
        _eTime= [NSString stringWithFormat:@"%d:%@:%@",[h intValue]+[length intValue],m,s];
    }else{ // 分钟
        _eTime= [NSString stringWithFormat:@"%@:%d:%@",h,[m intValue]+[length intValue],s];
    }
}

#pragma mark - view did load
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B2");
    strAddress = [[NSString alloc] init];
    strArea = [[NSString alloc] init];
    strRemark = [[NSString alloc] init];
    [self setNavTitle:@"添加工单"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    
    [self initTableview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
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
            _Date = [[NSString stringWithFormat:@"%@",_servicepojInfo.serviceBegin] substringToIndex:10];
            _eDate = [[NSString stringWithFormat:@"%@",_servicepojInfo.serviceEnd] substringToIndex:10];
            
            _bTime = [NSString stringWithFormat:@"%@",_servicepojInfo.serviceBegin];
            _eTime = [NSString stringWithFormat:@"%@",_servicepojInfo.serviceEnd];
        }
        [_tableview reloadData];
    }else{
        _Date = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceDate)];
        _eDate = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceEnd)];
        _bTime = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceBegin)];
        _eTime = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceEnd)];
    }
    */
    
    _money = @"0";
    if (_servicepojInfo) { // 选择服务项目
        _Date = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceDate)];
        [self serviceEndDate:_Date Validity:kString(self.servicepojInfo.serviceValidity)]; // 结束日期
        _bTime = [NSString stringWithFormat:@"%@",[kString(self.dofInfo.serviceBegin) substringWithRange:NSMakeRange(11, 8)]];
        [self serviceEndTime:_bTime serviceTime:self.servicepojInfo.serviceTime timeUnit:self.servicepojInfo.timeUnit];
        [_tableview reloadData]; // 结束 时间
    }else{
        _Date = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceDate)];
        _eDate = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceDate)];
        _bTime = [NSString stringWithFormat:@"%@",[kString(self.dofInfo.serviceBegin) substringWithRange:NSMakeRange(11, 8)]];
        _eTime = [NSString stringWithFormat:@"%@",[kString(self.dofInfo.serviceEnd) substringWithRange:NSMakeRange(11, 8)]];
    }
    
}

#pragma mark - init datepickeview
-(void)initDatePick:(NSString *)selectTime{
    
    self.timePickerView = [[DateAndTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withTimeShowMode:ShowAllTime withIsShowTodayDate:YES selectTime:selectTime];
    self.timePickerView.delegate = self;
    self.timePickerView.hidden = YES;
    self.timePickerView.layer.masksToBounds = YES;
    self.timePickerView.layer.cornerRadius = 5;
    self.timePickerView.tag = 104;
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

//-(long)computehour{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate *bdate = [formatter dateFromString:_bTime];
//    NSDate *edate = [formatter dateFromString:_eTime];
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//
//    NSDateComponents *cmps = [calendar components:unit fromDate:edate toDate:bdate options:0];
//    long jg = cmps.day*24+cmps.hour;
//    return jg;
//}

-(int)compareDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *bdate = [formatter dateFromString:_Date];
    NSDate *edate = [formatter dateFromString:_eDate];
    NSComparisonResult result = [bdate compare:edate];
    NSLog(@"date1 : %@, date2 : %@", bdate, edate);
    if (result == NSOrderedDescending) { // bdate>edate
        return 1;
    }else if (result == NSOrderedAscending){ // bdate<edate
        return -1;
    }
        return 0;
}

#pragma mark - init
-(void)initTableview{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.bounces = NO;
}

#pragma mark - nav back
-(void)LeftBarClick{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 提交工单
-(void)SubmitBtnClick{
    
    int ok = [self compareDate];
    if(ok == 1){
        [[AppDelegate sharedDelegate] showTextOnly:@"日期格式不符合要求"];
        return;
    }
    
    if(kString(_servicepojInfo.fullName).length==0){
        [[AppDelegate sharedDelegate] showTextOnly:@"请选择服务项目"];
        return;
    }
    if(kString(_Date).length==0){
        [[AppDelegate sharedDelegate] showTextOnly:@"请选择服务日期"];
        return;
    }
    if(kString(_bTime).length==0){
        [[AppDelegate sharedDelegate] showTextOnly:@"请选择服务开始时间"];
        return;
    }
    if(kString(_eTime).length==0){
        [[AppDelegate sharedDelegate] showTextOnly:@"请选择服务结束时间"];
        return;
    }

//    if(strArea.length==0){
//        [[AppDelegate sharedDelegate] showTextOnly:@"服务区域不能为空"];
//        return;
//    }
//    if(strAddress.length==0){
//        [[AppDelegate sharedDelegate] showTextOnly:@"服务地址不能为空"];
//        return;
//    }
//    NSArray * bg =  [_bTime componentsSeparatedByString:@" "];;
//    NSString * btstr = bg[0];
//    if(![_Date isEqualToString:btstr]){
//        [[AppDelegate sharedDelegate] showTextOnly:@"服务日期与服务开始时间不相符"];
//        return;
//    }
    NSLog(@"点击下单按钮");
    [self requestSubmit];
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"提交中"];
}

-(void)requestSubmit{
    NSMutableDictionary *paremeter = [NSMutableDictionary dictionary];
    [paremeter addUnEmptyString:_customerUkey forKey:@"customerUkey"];
    [paremeter addUnEmptyString:_servicepojInfo.id forKey:@"serviceItemId"];
    [paremeter addUnEmptyString:_servicepojInfo.showName forKey:@"serviceItemName"];
    [paremeter addUnEmptyString:_dofInfo.serviceAddress forKey:@"serviceAddress"];
    [paremeter addUnEmptyString:_Date forKey:@"serviceDate"];
    [paremeter addUnEmptyString:_bTime forKey:@"serviceBegin"];
    [paremeter addUnEmptyString:_eTime forKey:@"serviceEnd"];
    [paremeter addUnEmptyString:strRemark forKey:@"serviceContent"]; // 服务内容
    [paremeter addUnEmptyString:_money forKey:@"serviceMoney"];//_money 传空值
    [paremeter addUnEmptyString:[UserInfo getsUser].uuid forKey:@"waiterId"];
    [paremeter addUnEmptyString:[UserInfo getsUser].name forKey:@"waiterName"];
    [paremeter addUnEmptyString:[UserInfo getsUser].tenantId forKey:@"tenantsId"];
    /**4.0新增字段**/
    [paremeter addUnEmptyString:_eDate forKey:@"serviceDateEnd"]; // 服务日期结束
    [paremeter addUnEmptyString:_servicepojInfo.processId forKey:@"processId"];
    
    [[AFNetWorkingRequest sharedTool] requestsubmitOrder:paremeter type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
//        NSLog(@"%@",dic[@"message"]);
//        NSNumber * code = dic[@"code"];
//        if([code longValue] == 1){
//            [[AppDelegate sharedDelegate] showTextOnly:dic[@"message"]];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                for(UIView * view in self.view.subviews){
//                    [view removeFromSuperview];
//                }
//
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                 [[AppDelegate sharedDelegate] hidHUD];
//
//            });
//        }
        [[AppDelegate sharedDelegate] showAlertView:@"" des:dic[@"message"] cancel:@"" action:@"确定" acHandle:^(UIAlertAction *action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
              [[AppDelegate sharedDelegate] hidHUD];
        }];
    } failure:^(NSError *error) {
             [[AppDelegate sharedDelegate] hidHUD];
            [[AppDelegate sharedDelegate] showTextOnly:error.domain];
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
    return section==1?5:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section==1?53:(indexPath.section == 2?150.0f:163.f);
}

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
            cell.labValue.text = _servicepojInfo.fullName;
        }else if (indexPath.row == 1){
            cell.labValue.text = _Date;
        }else if (indexPath.row == 2){ // 结束日期
            cell.labValue.text = _eDate;
        }else if (indexPath.row == 3){
//            NSArray *array = [_bTime componentsSeparatedByString:@":"];
            cell.labValue.text = [NSString stringWithFormat:@"%@",_bTime]; // 开始时间
        }else{
//            NSArray *eTimeArray = [_eTime componentsSeparatedByString:@":"];
            cell.labValue.text = [NSString stringWithFormat:@"%@",_eTime];// 结束时间
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        if(indexPath.row==0){
            ServicePojController * spController = [[ServicePojController alloc] init];
            spController.DoContoller = self;
            spController.selectInfo = self.servicepojInfo;
            [self.navigationController pushViewController:spController animated:YES];
        }else if(indexPath.row==1){ // 开始日期
            _type = 1;
            [self initDatePick:[NSString stringWithFormat:@"%@ %@",self.Date,self.bTime]];
            self.timePickerView.hidden = NO;
             [[UIApplication sharedApplication].keyWindow addSubview:self.timePickerView];
        }else if(indexPath.row==2){ // 结束日期
            _type = 2;
            [self initDatePick:[NSString stringWithFormat:@"%@ %@",self.eDate,self.eTime]];
            self.timePickerView.hidden = NO;
             [[UIApplication sharedApplication].keyWindow addSubview:self.timePickerView];
        }else if(indexPath.row==3){ // 开始时间
            _type = 3;
            [self initDatePick:[NSString stringWithFormat:@"%@ %@",self.Date,self.bTime]];
            self.timePickerView.hidden = NO;
             [[UIApplication sharedApplication].keyWindow addSubview:self.timePickerView];
        }else if(indexPath.row==4){ // 结束时间
            _type = 4;
            [self initDatePick:[NSString stringWithFormat:@"%@ %@",self.eDate,self.eTime]];
             self.timePickerView.hidden = NO;
             [[UIApplication sharedApplication].keyWindow addSubview:self.timePickerView];
        }else { // 结束日期
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - remark cell delegate
-(void)remarkChangeDelegateText:(NSString *)remak{
    strRemark = remak;
}
-(void)didPostInfo{
    [self SubmitBtnClick];
}

#pragma mark - time pickerview
-(void)DateAndTimePickerView:(NSString *)year withMonth:(NSString *)month withDay:(NSString *)day withHour:(NSString *)hour withMinute:(NSString *)minute withDate:(NSString *)date withTag:(NSInteger)tag{
    if (tag == 1001) {
        if (_type == 3) { // 开始时间
            _bTime = [NSString stringWithFormat:@"%@:%@:00",hour,minute];
//            if ([minute integerValue]+5>59) { // 当分数大于60的时候 小时加一
//                _eTime = [NSString stringWithFormat:@"%ld:%ld:59",[hour integerValue]+1,[minute integerValue]+5-60];
//            }else{
//               _eTime = [NSString stringWithFormat:@"%@:%ld:59",hour,[minute integerValue]+5];
//            }
            if (self.servicepojInfo) {
                [self serviceEndTime:_bTime serviceTime:self.servicepojInfo.serviceTime timeUnit:self.servicepojInfo.timeUnit];
            }else{
               _eTime = [NSString stringWithFormat:@"%@:%@:59",hour,minute];
            }
        }else if(_type == 4){ // 结束时间
            if (self.servicepojInfo) {
                [self serviceEndTime:_bTime serviceTime:self.servicepojInfo.serviceTime timeUnit:self.servicepojInfo.timeUnit];
            }else{
               _eTime = [NSString stringWithFormat:@"%@:%@:59",hour,minute];
            }
        }else if (_type == 1){ // 开始日期
            _Date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            if (self.servicepojInfo) {
                [self serviceEndDate:_Date Validity:kString(self.servicepojInfo.serviceValidity)];
            }else{
                _eDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            }
        }else{ // 结束日期
             _eDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            if (self.servicepojInfo) {
                [self serviceEndDate:_eDate Validity:kString(self.servicepojInfo.serviceValidity)];
            }else{
                _eDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            }
            
        }
         [self.tableview reloadData];
    }else{//1002：取消
        
    }
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:104] removeFromSuperview];
}

@end
