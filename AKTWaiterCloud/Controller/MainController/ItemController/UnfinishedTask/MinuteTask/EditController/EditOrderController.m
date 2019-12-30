//
//  EditOrderController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/22.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "EditOrderController.h"
#import "ServicePojController.h"
#import "ZYInputAlertView.h"
@interface EditOrderController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger currentYear;
    NSInteger currentMonth;
    NSInteger currentday;
    NSInteger hour;
    NSInteger minute;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    NSString *selectecDay;
    NSString *strhour;
    NSString *strminute;
    
    Boolean ischangeTimeType;//每次修改过时间 计算金额按钮就需要重新再点击一次
    Boolean ischangeserviceType;//是否点击服务项目更变
}
@property(nonatomic,strong) IBOutlet UIView * moneyview;

@property(nonatomic,strong) IBOutlet UILabel * moneyLabel;
@property(nonatomic,strong) IBOutlet UILabel * newmoneyLabel;
@property(nonatomic,strong) IBOutlet UIButton * datebeginbtn;//开始按钮
@property(nonatomic,strong) IBOutlet UIButton * dateendbtn;//结束按钮
@property(nonatomic,strong) IBOutlet UIButton * servicebtn;//服务按钮
@property(nonatomic,strong) IBOutlet UIButton * submitbtn;//修改按钮
@property(nonatomic,strong) IBOutlet UIButton * comparebtn;//计算金额按钮

@property (nonatomic,strong) UIPickerView * datePickView;//日期选择器
@property (nonatomic,strong) UIView * bottomView;//日期选择器顶部视图

@property(nonatomic,strong) NSMutableArray * yearArr;
@property(nonatomic,strong) NSMutableArray * monthArr;
@property(nonatomic,strong) NSMutableArray * dayArr;
@property(nonatomic,strong) NSMutableArray * AllArr;

@property(nonatomic,strong) NSMutableArray * hourArr;
@property(nonatomic,strong) NSMutableArray * minuteArr;
@property(nonatomic,strong) NSMutableArray * hmAllArr;


@property(nonatomic,strong) NSString * Date;//给后台
@property(nonatomic,strong) NSString * bTime;//给后台
@property(nonatomic,strong) NSString * eTime;//给后台
@property(nonatomic,strong) NSString * serviceDate;//服务日期
@property(nonatomic,strong) NSString * serviceBeginTime;//服务开始时间
@property(nonatomic,strong) NSString * serviceEndTime;//服务结束时间
@property(nonatomic,strong) NSString * nmoney;//最新金额
@property(nonatomic,strong) NSString * remarks;//变更原因
@property(nonatomic,strong) NSString * changetype;//变更类型
@property(nonatomic,strong) NSString * newservicemoney;//变更服务项目的金额

@property(nonatomic,assign) int dateType;//1开始时间 2结束时间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toplabellayout;

@end

@implementation EditOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.netWorkErrorView.hidden = YES;
    self.servicepojInfo = nil;
    [self.submitbtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    [self initNavItem];
    if(KIsiPhoneX){
        _toplabellayout.constant = 108;
    }
    ischangeTimeType =true;
    [self.comparebtn addTarget:self action:@selector(compareMoney) forControlEvents:UIControlEventTouchUpInside];
    self.comparebtn.layer.masksToBounds = true;
    self.comparebtn.layer.cornerRadius=10.0f;

    _bTime = @"";
    _eTime = @"";
    _changetype = @"";
    if([self.workstuats isEqualToString:@"11"]){
        self.submitbtn.enabled = false;
        [self.submitbtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.submitbtn.backgroundColor = [UIColor lightGrayColor];
        [self.submitbtn setTitle:@"变更审核中" forState:UIControlStateNormal];
    }
    //默认显示
    NSString * beginDate = [[self.oldBeginTime componentsSeparatedByString:@" "] objectAtIndex:1];
    NSString * bdate = [[self.oldBeginTime componentsSeparatedByString:@" "] objectAtIndex:0];
    beginDate = [beginDate substringToIndex:5];
    
    NSString * endDate = [[self.self.oldEndTime componentsSeparatedByString:@" "] objectAtIndex:1];
    NSString * edate = [[self.oldEndTime componentsSeparatedByString:@" "] objectAtIndex:0];
    endDate = [endDate substringToIndex:5];
    self.showdatebegin.text = [NSString stringWithFormat:@"%@ %@:00",bdate,beginDate];
    self.showdateend.text = [NSString stringWithFormat:@"%@ %@:00",edate,endDate];
    self.showservice.text = self.oldService;
    if(![self.oldmoney isEqualToString:@"免费"]){
        NSString * servicemoney = [NSString stringWithFormat:@"¥%@.0",self.oldmoney];
        self.moneyLabel.text = servicemoney;
        self.newmoneyLabel.text = servicemoney;
    }else{
        self.moneyLabel.text = self.oldmoney;
        self.newmoneyLabel.text = self.oldmoney;
    }

    //初始化日期选择器的内容
    [self initDateArray];
    [self initDateBeginTime];
    [self initDataPicker];
    
    self.bottomView.hidden = YES;
    self.datePickView.hidden = YES;
}

-(void)initNavItem{
    [self setTitle:@"工单变更"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 60, 40)];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftButton.titleLabel setTextColor:[UIColor whiteColor]];
    leftButton.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0];
    UIEdgeInsets titlecg = leftButton.titleEdgeInsets;
    titlecg.left = 10;
    leftButton.titleEdgeInsets = titlecg;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickDateBtn:(id)sender{
    UIView * view = (UIView *)sender;
    if(view.tag==0){
        _dateType=1;
        self.bottomView.hidden = NO;
        self.datePickView.hidden = NO;
    }else{
        _dateType=2;
        self.bottomView.hidden = NO;
        self.datePickView.hidden = NO;
    }
}

-(IBAction)clickServiceBtn:(id)sender{
    ServicePojController * spController = [[ServicePojController alloc] init];
    spController.EoController = self;
    [self.navigationController pushViewController:spController animated:YES];
}

-(IBAction)submitBtnClick:(id)sender{
    _datePickView.hidden = YES;
    _bottomView.hidden = YES;
    if([self.showservice.text isEqualToString:@""]&&[self.showdateend.text isEqualToString:@""]&&[self.showdatebegin.text isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入需要修改的内容"];
        return;
    }
    
    if([self.showdatebegin.text isEqualToString:@""]&&![self.showdateend.text isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入开始时间"];
        return;
    }
    
    if(![self.showdatebegin.text isEqualToString:@""]&&[self.showdateend.text isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入结束时间"];
        return;
    }
    if([self compareDate]==1||[self compareDate]==0){
        [self showMessageAlertWithController:self Message:@"开始时间必须早于结束日期"];
        return;
    }
    if(ischangeTimeType){
        [self showMessageAlertWithController:self Message:@"请重新计算金额后再提交变更"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.confirmBgColor = [UIColor blueColor];
    alertView.placeholder = @"请输入变更原因";
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        weakSelf.remarks = inputString;
        if(!weakSelf.remarks){
            [self showMessageAlertWithController:weakSelf Message:@"请输入变更原因"];
        }else{
            if(![self.showdatebegin.text isEqualToString:self.oldBeginTime]||![self.showdateend.text isEqualToString:self.oldEndTime]){
                self.changetype=@"1";
            }
            if(![self.showservice.text isEqualToString:self.oldService]){
                self.changetype=@"2";
            }
            if(![self.showdatebegin.text isEqualToString:self.oldBeginTime]||![self.showdateend.text isEqualToString:self.oldEndTime]||![self.showservice.text isEqualToString:self.oldService]){
                self.changetype=@"";
            }
            
            [self requestaskForWorkChange];
        }
    }];
    [alertView show];
}

-(void)requestaskForWorkChange{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"提交中..."];
    NSString * newserviceid = @"";
    if(self.servicepojInfo){
        newserviceid = self.servicepojInfo.id;
    }else{
        newserviceid = self.serviceid;
    }
    NSString * Money = [self.newmoneyLabel.text stringByReplacingOccurrencesOfString:@"¥"withString:@""];
    NSDictionary * params = @{@"workId":self.workid,@"tenantsId":appDelegate.userinfo.tenantsId,@"workNo":self.workNo,@"changeType":self.changetype,@"serviceBeginBefore":self.oldBeginTime,@"serviceBeginAfter":self.bTime,@"serviceEndBefore":self.oldEndTime,@"serviceEndAfter":self.eTime,@"serviceTypeNameBefore":self.oldService,@"serviceTypeNameAfter":self.showservice.text,@"stationId":self.stationId,@"remarks":self.remarks,@"serviceMoney":Money,@"serviceTypeBefore":self.serviceid,@"serviceTypeAfter":newserviceid};
    [[AFNetWorkingRequest sharedTool] requestaskForWorkChange:params type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            [self showMessageAlertWithController:self Message:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changerootview" object:nil userInfo:nil];
        }else{
            [self showMessageAlertWithController:self Message:@"提交失败,请稍后再试"];
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
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
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",i];
        [_yearArr addObject:yearStr];
    }
    
    _monthArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",i];
        [_monthArr addObject:monthStr];
    }
    
    _dayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 30; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld日",i];
        [_dayArr addObject:dayStr];
    }
    _AllArr = [NSMutableArray arrayWithCapacity:3];
    [_AllArr addObject:_yearArr];
    [_AllArr addObject:_monthArr];
    [_AllArr addObject:_dayArr];
}

-(void)initDataPicker{
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
    [_bottomView addSubview:canelBtn];
    [_bottomView addSubview:okBtn];
    
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
}

-(void)canelBtnClick{
    self.datePickView.hidden = YES;
    self.bottomView.hidden = YES;
    ischangeTimeType = YES;
    if(_dateType==1){
        self.showdatebegin.text = @"";
    }else{
        self.showdateend.text = @"";
    }
}

-(void)okBtnClick{
    self.datePickView.hidden = YES;
    self.bottomView.hidden = YES;
    ischangeTimeType = YES;
    if(_dateType==1){
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
//
//        NSInteger hrow=[_datePickView selectedRowInComponent:3];
//        NSString *subStringHour=[_hourArr objectAtIndex:hrow];
//        NSString *hours =[subStringHour substringToIndex:[subStringHour length] - 1];
//
//        NSInteger minuterow=[_datePickView selectedRowInComponent:4];
//        NSString *subStringMinute=[_minuteArr objectAtIndex:minuterow];
//        NSString *minutes =[subStringMinute substringToIndex:[subStringMinute length] - 1];
        
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
        _bTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hours,minutes];
        NSString * dstr =[[_bTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString * str = [[_bTime componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString * hstr = [[str componentsSeparatedByString:@":"] objectAtIndex:0];
        NSString * mstr = [[str componentsSeparatedByString:@":"] objectAtIndex:1];
        if(hstr.length==1){
            hstr = [NSString stringWithFormat:@"0%@",hstr];
        }
        if(mstr.length==1){
            mstr = [NSString stringWithFormat:@"0%@",mstr];
        }
        _bTime = [NSString stringWithFormat:@"%@ %@:%@:00",dstr,hstr,mstr];
        _showdatebegin.text = _bTime;
        //[self compareMoney];

    }else if(_dateType ==2){
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
        _eTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hours,minutes];
        NSString * dstr =[[_eTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString * str = [[_eTime componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString * hstr = [[str componentsSeparatedByString:@":"] objectAtIndex:0];
        NSString * mstr = [[str componentsSeparatedByString:@":"] objectAtIndex:1];
        if(hstr.length==1){
            hstr = [NSString stringWithFormat:@"0%@",hstr];
        }
        if(mstr.length==1){
            mstr = [NSString stringWithFormat:@"0%@",mstr];
        }
        _eTime = [NSString stringWithFormat:@"%@ %@:%@:00",dstr,hstr,mstr];
        _showdateend.text = _eTime;
        //[self compareMoney];
    }
}

-(void)compareMoney{
    ischangeTimeType = false;
    if([self compareDate]==1){
        self.newmoneyLabel.text = @"";
        return;
    }else{
        if(!ischangeserviceType){
            if([self.oldmoney isEqualToString:@"免费"]){
                return;
            }
            //按次计算
            if(![_untype isEqualToString:@"1"]){
                NSString * Money = [NSString stringWithFormat:@"¥%@.0",self.oldmoney];
                self.newmoneyLabel.text = Money;
                return;
            }else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                //开始时间
                NSDate *date = [formatter dateFromString:self.showdatebegin.text];
                // 截止时间data格式
                NSDate *expireDate = [formatter dateFromString:self.showdateend.text];
                // 当前日历
                NSCalendar *calendar = [NSCalendar currentCalendar];
                // 需要对比的时间数据
                NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
                | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                // 对比时间差
                NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:expireDate options:0];
                if(dateCom.second>0){
                    return;//开始时间大于结束时间 不计算
                }else{//开始计算原始的分钟的金额
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    //开始时间
                    NSDate *odate = [formatter dateFromString:self.oldBeginTime];
                    // 截止时间data格式
                    NSDate *oexpireDate = [formatter dateFromString:self.oldEndTime];
                    // 当前日历
                    NSCalendar *ocalendar = [NSCalendar currentCalendar];
                    // 需要对比的时间数据
                    NSCalendarUnit ounit = NSCalendarUnitYear | NSCalendarUnitMonth
                    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                    // 对比时间差
                    NSDateComponents *odateCom = [ocalendar components:ounit fromDate:odate toDate:oexpireDate options:0];
                    float  hour = 0.0;//总服务时间
                    if(odateCom.year>0){
                        hour += (float)odateCom.year*[self getNumberOfDaysInYear]*24;
                    }
                    if(odateCom.month>0){
                        hour += (float)odateCom.month*[self getNumberOfDaysInMonth]*24;
                    }
                    if(odateCom.day>0){
                        hour += (float)odateCom.day*24;
                    }
                    if(odateCom.hour>0){
                        hour += (float)odateCom.hour;
                    }
                    if(odateCom.minute>0){
                        hour += (float)odateCom.minute*0.0166;
                    }
                    //平均每小时的时间
                    float nm = [self.oldmoney intValue]/hour;
                    //更改后的服务时间
                    //开始时间
                    NSDateFormatter *nformatter = [[NSDateFormatter alloc]init];
                    [nformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSDate *ndate = [nformatter dateFromString:self.showdatebegin.text];
                    // 截止时间data格式
                    NSDate *nexpireDate = [nformatter dateFromString:self.showdateend.text];
                    // 当前日历
                    NSCalendar *ncalendar = [NSCalendar currentCalendar];
                    // 需要对比的时间数据
                    NSCalendarUnit nunit = NSCalendarUnitYear | NSCalendarUnitMonth
                    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                    // 对比时间差
                    NSDateComponents *ndateCom = [ncalendar components:nunit fromDate:ndate toDate:nexpireDate options:0];
                    float  nhour = 0.0;//修改后总服务时间
                    if(ndateCom.year>0){
                        nhour += (float)ndateCom.year*[self getNumberOfDaysInYear]*24;
                    }
                    if(ndateCom.month>0){
                        nhour += (float)ndateCom.month*[self getNumberOfDaysInMonth]*24;
                    }
                    if(ndateCom.day>0){
                        nhour += (float)ndateCom.day*24;
                    }
                    if(ndateCom.hour>0){
                        nhour += (float)ndateCom.hour;
                    }
                    if(ndateCom.minute>0){
                        nhour += (float)ndateCom.minute*0.0166;
                    }
                    self.nmoney = [NSString stringWithFormat:@"%0.1f",nhour*nm];
                    NSString * servicemoney = [NSString stringWithFormat:@"¥%@",self.nmoney];
                    self.newmoneyLabel.text = servicemoney;
                }
            }
        }else{
            if([self.newservicemoney isEqualToString:@"免费"]){
                return;
            }
            //按次计算
            if(![_untype isEqualToString:@"1"]){
                NSString * Money = [NSString stringWithFormat:@"¥%@.0",self.newservicemoney];
                self.newmoneyLabel.text = Money;
                return;
            }else{
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                //开始时间
                NSDate *date = [formatter dateFromString:self.showdatebegin.text];
                // 截止时间data格式
                NSDate *expireDate = [formatter dateFromString:self.showdateend.text];
                // 当前日历
                NSCalendar *calendar = [NSCalendar currentCalendar];
                // 需要对比的时间数据
                NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
                | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                // 对比时间差
                NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:expireDate options:0];
                if(dateCom.second>0){
                    return;//开始时间大于结束时间 不计算
                }else{//开始计算原始的分钟的金额
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    //开始时间
                    NSDate *odate = [formatter dateFromString:self.oldBeginTime];
                    // 截止时间data格式
                    NSDate *oexpireDate = [formatter dateFromString:self.oldEndTime];
                    // 当前日历
                    NSCalendar *ocalendar = [NSCalendar currentCalendar];
                    // 需要对比的时间数据
                    NSCalendarUnit ounit = NSCalendarUnitYear | NSCalendarUnitMonth
                    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                    // 对比时间差
                    NSDateComponents *odateCom = [ocalendar components:ounit fromDate:odate toDate:oexpireDate options:0];
                    float  hour = 0.0;//总服务时间
                    if(odateCom.year>0){
                        hour += (float)odateCom.year*[self getNumberOfDaysInYear]*24;
                    }
                    if(odateCom.month>0){
                        hour += (float)odateCom.month*[self getNumberOfDaysInMonth]*24;
                    }
                    if(odateCom.day>0){
                        hour += (float)odateCom.day*24;
                    }
                    if(odateCom.hour>0){
                        hour += (float)odateCom.hour;
                    }
                    if(odateCom.minute>0){
                        hour += (float)odateCom.minute*0.0166;
                    }
                    //平均每小时的时间
                    float nm = [self.newservicemoney intValue]/hour;
                    //更改后的服务时间
                    //开始时间
                    NSDateFormatter *nformatter = [[NSDateFormatter alloc]init];
                    [nformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSDate *ndate = [nformatter dateFromString:self.showdatebegin.text];
                    // 截止时间data格式
                    NSDate *nexpireDate = [nformatter dateFromString:self.showdateend.text];
                    // 当前日历
                    NSCalendar *ncalendar = [NSCalendar currentCalendar];
                    // 需要对比的时间数据
                    NSCalendarUnit nunit = NSCalendarUnitYear | NSCalendarUnitMonth
                    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                    // 对比时间差
                    NSDateComponents *ndateCom = [ncalendar components:nunit fromDate:ndate toDate:nexpireDate options:0];
                    float  nhour = 0.0;//修改后总服务时间
                    if(ndateCom.year>0){
                        nhour += (float)ndateCom.year*[self getNumberOfDaysInYear]*24;
                    }
                    if(ndateCom.month>0){
                        nhour += (float)ndateCom.month*[self getNumberOfDaysInMonth]*24;
                    }
                    if(ndateCom.day>0){
                        nhour += (float)ndateCom.day*24;
                    }
                    if(ndateCom.hour>0){
                        nhour += (float)ndateCom.hour;
                    }
                    if(ndateCom.minute>0){
                        nhour += (float)ndateCom.minute*0.0166;
                    }
                    self.nmoney = [NSString stringWithFormat:@"%0.1f",nhour*nm];
                    NSString * servicemoney = [NSString stringWithFormat:@"¥%@",self.nmoney];
                    self.newmoneyLabel.text = servicemoney;
                }
            }
        }
        
    }
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
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",i];
        [_yearArr addObject:yearStr];
    }
    
    _monthArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",i];
        [_monthArr addObject:monthStr];
    }
    
    _dayArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 30; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%ld日",i];
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
        NSString *yearStr = [NSString stringWithFormat:@"%ld时",i];
        [_hourArr addObject:yearStr];
    }
    
    _minuteArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= 59 ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld分",i];
        [_minuteArr addObject:yearStr];
    }
    
    _hmAllArr = [NSMutableArray array];
    [_hmAllArr addObject:_yearArr];
    [_hmAllArr addObject:_monthArr];
    [_hmAllArr addObject:_dayArr];
    [_hmAllArr addObject:_hourArr];
    [_hmAllArr addObject:_minuteArr];
}


#pragma mark =====pickview代理
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(_dateType==1){
        return _AllArr.count;
    }else{
        return _hmAllArr.count;
    }
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *items = self.hmAllArr[component];
    return items.count;
}
// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.hmAllArr[component][row];
}


//滑动事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
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


//比较日期大小
-(int)compareDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *bdate;
    NSDate *edate;
    if([_showdatebegin.text isEqualToString:@""]){
        bdate = [formatter dateFromString:_bTime];
    }else{
        bdate = [formatter dateFromString:self.showdatebegin.text];
    }
    
    if([_showdateend.text isEqualToString:@""]){
        edate = [formatter dateFromString:_eTime];
    }else{
        edate = [formatter dateFromString:self.showdateend.text];
    }
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


-(void)viewWillAppear:(BOOL)animated{
    if(self.servicepojInfo){
        ischangeTimeType=true;
        ischangeserviceType = true;
        self.showservice.text = self.servicepojInfo.name;
        _untype = self.servicepojInfo.unitType;
        //按时计算
        if([_servicepojInfo.unitType intValue]==1){
            if([self.servicepojInfo.serviceMoney isEqualToString:@"0"]||[
                self.servicepojInfo.serviceMoney isEqualToString:@""]){
                self.newmoneyLabel.text = @"免费";
                return;
            }
            int isbig = [self compareDate];
            if(isbig==-1){
                float m =[_servicepojInfo.serviceMoney floatValue];
                long jg = [self computehour];
                float mon = m*jg;
                self.newmoneyLabel.text =  [NSString stringWithFormat:@"%f",mon];
            }
        }else if([_servicepojInfo.unitType intValue]== 2){ //按次计算
            self.newmoneyLabel.text = _servicepojInfo.serviceMoney;
            if([self.newmoneyLabel.text isEqualToString:@""]){
                self.newmoneyLabel.text = @"免费";
            }
        }
        
        
//        if([self.servicepojInfo.serviceMoney isEqualToString:@"0"]||[
//           self.servicepojInfo.serviceMoney isEqualToString:@""]){
//            self.newmoneyLabel.text = @"免费";
//        }else{
//            if(self.servicepojInfo.serviceMoney>0){
//                NSString * servicemoney = [NSString stringWithFormat:@"¥%@.0",self.servicepojInfo.serviceMoney];
//                self.newmoneyLabel.text = servicemoney;
//                self.newservicemoney = self.servicepojInfo.serviceMoney;
//            }else{
//                self.newmoneyLabel.text = self.servicepojInfo.serviceMoney;
//                self.newservicemoney = self.servicepojInfo.serviceMoney;
//            }
//        }
    }
}

// 获取当年的天数
- (NSInteger)getNumberOfDaysInYear
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSDate * currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitYear //NSMonthCalendarUnit - ios 8
                                  forDate:currentDate];
    return range.length;
}
// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSDate * currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:currentDate];
    return range.length;
}
@end
