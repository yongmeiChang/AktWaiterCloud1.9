//
//  AktDateSearchVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/9/20.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktDateSearchVC.h"
#import "FilterController.h"

@interface AktDateSearchVC ()<UITextFieldDelegate>
{
    NSInteger istype;
    NSMutableArray *aryTitle;
    NSString *startTime;
    NSString *endTime;
}
@property (weak, nonatomic) IBOutlet UITextField *tfStartDate;
@property (weak, nonatomic) IBOutlet UITextField *tfEndDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *viewBgBlack;
@property (weak, nonatomic) IBOutlet UIView *viewPickerBg;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;


@end

@implementation AktDateSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBarItem];
     self.netWorkErrorView.hidden = YES;
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
}
-(void)setLeftBarItem{
    [self setTitle:@"筛选日期"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(LeftBarClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 60, 40)];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [leftButton.titleLabel setTextColor:[UIColor whiteColor]];
    leftButton.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0];
    UIEdgeInsets titlecg = leftButton.titleEdgeInsets;
    titlecg.left = 10;
    leftButton.titleEdgeInsets = titlecg;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIButton Action

- (IBAction)todayDate:(UIButton *)sender {
    NSLog(@" 今天");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate * tdate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [formatter stringFromDate:tdate];
    
    startTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    endTime = [NSString stringWithFormat:@"%@ 23:59:59",currentDateStr];
}
- (IBAction)toWeekDate:(UIButton *)sender {
    NSLog(@"本周");
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    // 得到星期几
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:lastDayOfWeek];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * str = [formater stringFromDate:lastDay];
    str = [[str componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString * lastdayStr = [NSString stringWithFormat:@"%@ 23:59:59", str];
    startTime = [formater stringFromDate:firstDayOfWeek];
    endTime = lastdayStr;
}
- (IBAction)toMounceDate:(UIButton *)sender {
    NSLog(@"本月");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate * tdate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *currentDateStr = [formatter stringFromDate:tdate];
    // 判断日期
    NSString *y;
    NSString *m;
    NSArray * arr = [currentDateStr componentsSeparatedByString:@"-"];
    for(int i = 0; i< arr.count; i++){
        if(i==0){
            y  = [NSString stringWithFormat:@"%@",arr[i]];
        }else if(i==1){
            m  = [NSString stringWithFormat:@"%@",arr[i]];
        }
    }
    if([m isEqualToString:@"1"]||[m isEqualToString:@"3"]||[m isEqualToString:@"5"]||[m isEqualToString:@"7"]||[m isEqualToString:@"8"]||[m isEqualToString:@"10"]||[m isEqualToString:@"12"]){
        endTime = [NSString stringWithFormat:@"%@-31 23:59:59",currentDateStr];
    }else if([m isEqualToString:@"2"]){
        endTime = [NSString stringWithFormat:@"%@-28 23:59:59",currentDateStr];
    }else{
        endTime = [NSString stringWithFormat:@"%@-30 23:59:59",currentDateStr];
    }
    
    startTime = [NSString stringWithFormat:@"%@-01 00:00:00",currentDateStr];
    
}

- (IBAction)searchDate:(UIButton *)sender {
    NSLog(@"----%@----%@",startTime,endTime);
    if(!startTime){
        [self showMessageAlertWithController:self Message:@"请输入开始时间"];
        return;
    }
    if([startTime isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入开始时间"];
        return;
    }
    if(!endTime){
        [self showMessageAlertWithController:self Message:@"请输入结束时间"];
        return;
    }
    if([endTime isEqualToString:@""]){
        [self showMessageAlertWithController:self Message:@"请输入结束时间"];
        return;
    }
    if([self compareDate]==1){
        [self showMessageAlertWithController:self Message:@"开始日期必须小于结束日期"];
        return;
    }
    
    NSDictionary * parameters =@{@"type":@"done",@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"beginDate":startTime,@"endDate":endTime};
    /*
    [[AFNetWorkingRequest sharedTool] requestgetWorkListByDay:parameters type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            arr = [dic objectForKey:@"object"];
            if(arr&&arr.count>0){
                FilterController * filetcontroller = [[FilterController alloc] init];
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
                    orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                    orderinfo.tid = orderinfo.id;
                    
                    filetcontroller.titleStr=@"筛选已完成任务";
                    
                    [filetcontroller.dataArray addObject:orderinfo];
                }
                [self.navigationController pushViewController:filetcontroller animated:YES];
            }else{
                [self showMessageAlertWithController:self Message:@"暂无数据"];
            }
        }else{
            [self showMessageAlertWithController:self Message:@"暂无数据"];
        }
        if(appDelegate.netWorkType == Off_line){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showOffLineAlertWithTime:0.7  message:NetWorkSuccess DoSomethingBlock:^{
                }];
                appDelegate.netWorkType = On_line;
            });
        }
        [SVProgressHUD dismiss];
    }
                                                      failure:^(NSError *error) {
                                                          [SVProgressHUD dismiss];
                                                          [self showMessageAlertWithController:self Message:@"查询错误，请重新操作!"];
                                                      }];
    */
}
- (IBAction)cancelPicke:(UIButton *)sender {
    [self.viewBgBlack setHidden:YES];
    [self.viewPickerBg setHidden:YES];
}
- (IBAction)surePicke:(id)sender {
    [self.viewBgBlack setHidden:YES];
    [self.viewPickerBg setHidden:YES];
    if (istype == 1) {
        self.tfStartDate.text = startTime;
    }if(istype == 2){
        self.tfEndDate.text = endTime;
    }
}
- (IBAction)starDate:(UIButton *)sender {
    istype = 1;
    [self.viewBgBlack setHidden:NO];
    [self.viewPickerBg setHidden:NO];
}
- (IBAction)endDate:(UIButton *)sender {
    istype = 2;
    [self.viewBgBlack setHidden:NO];
    [self.viewPickerBg setHidden:NO];
}

#pragma mark - PickeView delegate

- (IBAction)ValueChage:(UIDatePicker *)sender {
     NSLog(@"Selected date = %@", sender.date);
    NSString *date;
    NSString *time;
    if (sender.tag ==1) {
        date = [NSString stringWithFormat:@"%@",sender.date];
    }else{
        time = [NSString stringWithFormat:@"%@",sender.date];
    }
    if (istype == 1) {
        startTime = [NSString stringWithFormat:@"%@",date];
    }if(istype == 2){
        endTime = [NSString stringWithFormat:@"%@",date];
    }
}

#pragma mark - uitextFild delegate


//比较日期大小
-(int)compareDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *bdate = [formatter dateFromString:startTime];
    NSDate *edate = [formatter dateFromString:endTime];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
