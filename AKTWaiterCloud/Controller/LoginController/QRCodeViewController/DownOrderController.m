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
#import "DownOrderView.h"
#import "AktAddOrderUserInfoCell.h" // 用户信息
#import "AktServiceRemarkCell.h" // 服务内容
#import "DatePickerView.h"
#import "DateAndTimePickerView.h"

@interface DownOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AktServiceRemarkCellDelegate,DatePickerViewDelegate,DateAndTimePickerViewDelegate>
{
    NSString *strAddress; // 详细地址
    NSString *strArea; //  市区
    NSString *strRemark; // 服务内容
}
@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong) NSString * money; // 金额
@property(nonatomic,strong) NSString * Date;//给后台
@property(nonatomic,strong) NSString * bTime;//给后台
@property(nonatomic,strong) NSString * eTime;//给后台

@property (nonatomic,strong) DownOrderView * doView;
@property(nonatomic,strong) NSDictionary * addressDic;
@property(nonatomic) int type;
// 服务日期选项
//@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic, strong) DateAndTimePickerView *timePickerView;

@end

@implementation DownOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B2");
    strAddress = [[NSString alloc] init];
    strArea = [[NSString alloc] init];
    strRemark = [[NSString alloc] init];
    [self setNavTitle:@"添加工单"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    
    [self initTableview];
    [self initDatePick];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
            _bTime = [NSString stringWithFormat:@"%@",_servicepojInfo.serviceBegin];
            _eTime = [NSString stringWithFormat:@"%@",_servicepojInfo.serviceEnd];
        }
        [_tableview reloadData];
    }else{
        _Date = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceDate)];
        _bTime = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceBegin)];
        _eTime = [NSString stringWithFormat:@"%@",kString(self.dofInfo.serviceEnd)];
    }
}
#pragma mark - init datepickeview
-(void)initDatePick{
    
    self.timePickerView = [[DateAndTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withTimeShowMode:ShowAllTime withIsShowTodayDate:YES];
    self.timePickerView.delegate = self;
    self.timePickerView.hidden = YES;
    self.timePickerView.layer.masksToBounds = YES;
    self.timePickerView.layer.cornerRadius = 5;
    self.timePickerView.tag = 104;
    
    /*
    self.datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-269)/2, (SCREEN_HEIGHT-246)/2, 269, 246) withDateShowMode:ShowAllDate withIsShowTodayDate:YES];
    self.datePickerView.backgroundColor = [UIColor whiteColor];
    self.datePickerView.delegate = self;
    [self.view addSubview:self.datePickerView];
    self.datePickerView.hidden = YES;
    self.datePickerView.layer.masksToBounds = YES;
    self.datePickerView.layer.cornerRadius = 5;
    */
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
    NSDate *bdate = [formatter dateFromString:_bTime];
    NSDate *edate = [formatter dateFromString:_eTime];
    
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

#pragma mark - init
-(void)initTableview{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, AktNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-123) style:UITableViewStyleGrouped];
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
    if(ok!=-1){
        [[AppDelegate sharedDelegate] showTextOnly:@"日期格式不符合要求"];
        return;
    }
    
    if(kString(_servicepojInfo.name).length==0){
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
//    if(_phoneTfield.text==nil){
//        [[AppDelegate sharedDelegate] showTextOnly:@"用户电话不能为空"];
//        return;
//    }
    if(strArea.length==0){
        [[AppDelegate sharedDelegate] showTextOnly:@"服务区域不能为空"];
        return;
    }
    if(strAddress.length==0){
        [[AppDelegate sharedDelegate] showTextOnly:@"服务地址不能为空"];
        return;
    }
    NSArray * bg =  [_bTime componentsSeparatedByString:@" "];;
    NSString * btstr = bg[0];
    if(![_Date isEqualToString:btstr]){
        [[AppDelegate sharedDelegate] showTextOnly:@"服务日期与服务开始时间不相符"];
        return;
    }
    NSLog(@"点击下单按钮");
    [self requestSubmit];
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"提交中"];
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
    [paremeter addUnEmptyString:appDelegate.userinfo.tenantsId forKey:@"tenantsId"];
    
    [[AFNetWorkingRequest sharedTool] requestsubmitOrder:paremeter type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSLog(@"%@",dic[@"message"]);
        NSNumber * code = dic[@"code"];
        if([code longValue] == 1){
            [[AppDelegate sharedDelegate] showTextOnly:dic[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for(UIView * view in self.view.subviews){
                    [view removeFromSuperview];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changerootview" object:nil userInfo:nil];
                 [[AppDelegate sharedDelegate] hidHUD];;
                
            });
        }else{
             [[AppDelegate sharedDelegate] hidHUD];;
            [[AppDelegate sharedDelegate] showTextOnly:dic[@"message"]];
            }
    } failure:^(NSError *error) {
             [[AppDelegate sharedDelegate] hidHUD];;
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
    return section==1?4:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section==1?53:(indexPath.section == 2?150.0f:183.f);
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
            cell.labValue.text = _servicepojInfo.name;
        }else if (indexPath.row == 1){
            cell.labValue.text = _Date;
        }else if (indexPath.row == 2){
             cell.labValue.text = _bTime;
        }else{
            cell.labValue.text = _eTime;
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
        }else if(indexPath.row==1){
            //            _type = 1;
        }else if(indexPath.row==2){
            _type = 2;
            self.timePickerView.hidden = NO;
             [[UIApplication sharedApplication].keyWindow addSubview:self.timePickerView];
        }else if(indexPath.row==3){
            _type = 3;
             self.timePickerView.hidden = NO;
             [[UIApplication sharedApplication].keyWindow addSubview:self.timePickerView];
        }else if(indexPath.row==4){
            
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
#pragma mark - click
-(void)ClickReload{
    NSLog(@"点击了重新计算");
    [self showMessageAlertWithController:self Message:@"计算完毕"];
}

#pragma mark - time pickerview
-(void)DateAndTimePickerView:(NSString *)year withMonth:(NSString *)month withDay:(NSString *)day withHour:(NSString *)hour withMinute:(NSString *)minute withDate:(NSString *)date withTag:(NSInteger)tag{
    if (tag == 1001) {
        if (_type == 2) {
            _Date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            
            _bTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
        }else if(_type == 3){
            _eTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
        }
         [self.tableview reloadData];
    }else{//1002：取消
        
    }
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:104] removeFromSuperview];
}
/*
#pragma mark - DatePickerViewDelegate
- (void)DatePickerView:(NSString *)year withMonth:(NSString *)month withDay:(NSString *)day withDate:(NSString *)date withTag:(NSInteger)tag{
    //确定
    if (tag == 1001) {
         [self.tableview reloadData];
    }else{//1002：取消
    }
    [self lightGrayViewSingleTapFromAction];
    NSLog(@"选择确认日期：%@", date);
}
*/
@end
