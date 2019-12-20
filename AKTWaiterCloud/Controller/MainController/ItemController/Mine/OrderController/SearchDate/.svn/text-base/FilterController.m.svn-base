//
//  FilterController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/22.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "FilterController.h"
#import "MinuteTaskController.h"
#import "PlanTaskCell.h"
#import <MJRefresh.h>
#import "MyTableView.h"
@interface FilterController ()<UITableViewDataSource,UITableViewDelegate>{
    int pageSize;
}
@property(weak,nonatomic) IBOutlet MyTableView * taskTableview;

@end

//日期筛选后的工单视图
@implementation FilterController

-(instancetype)init{
    if(self = [super init]){
        self.dataArray = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize = 1;
    //[self.taskTableview initImageArr];
    self.taskTableview.delegate = self;
    self.taskTableview.dataSource = self;
    self.netWorkErrorView.hidden = YES;
    if(self.dataArray&&self.dataArray.count>0){
        self.dataArray = (NSMutableArray *)[self.dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            OrderInfo * order1 = (OrderInfo *)obj1;
            OrderInfo * order2 = (OrderInfo *)obj2;
                
            NSDate *date1 = [formatter dateFromString:order1.serviceBegin];
            NSDate *date2 = [formatter dateFromString:order2.serviceBegin];
            NSComparisonResult result = [date1 compare:date2];
            return result == NSOrderedAscending;//升序  NSOrderedDescending; 降序
        }];
        [self.taskTableview reloadData];
    }
    [self setLeftBarItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
#pragma mark - nav click
-(void)setLeftBarItem{
    [self setTitle:self.titleStr];
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

#pragma mark ==========tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(SCREEN_WIDTH<375){return 190.0f;
         }else{
             return 220.0f;
         }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0;
    }
    return 20.0f;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"PlanTaskCell";
    PlanTaskCell *cell = (PlanTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSArray * arr = _dataArray;
    if(arr.count>0){
        OrderInfo * orderinfo = arr[indexPath.section];
        [cell setOrderList:orderinfo];
        
//        cell.namelabel.text = orderinfo.customerName;
//        [cell.namelabel setTag:indexPath.section+1];
//        cell.phonelabel.text = orderinfo.customerPhone;
////        cell.datelabel.text = orderinfo.serviceDate;
//        NSString * beginDate = [[orderinfo.serviceBegin componentsSeparatedByString:@" "] objectAtIndex:1];
//        beginDate = [beginDate substringToIndex:16];
//        NSString * endDate = [[orderinfo.serviceEnd componentsSeparatedByString:@" "] objectAtIndex:1];
//        endDate = [endDate substringToIndex:16];
//        cell.datelabel.text = [NSString stringWithFormat:@"%@ —— %@",beginDate,endDate];
//        cell.workNolabel.text = [NSString stringWithFormat:@"%@",orderinfo.workNo];
//        NSString * itemName = orderinfo.serviceItemName;
//        itemName = [itemName stringByReplacingOccurrencesOfString:@"->" withString:@"  >  "];
//
//        if([orderinfo.workStatus isEqualToString:@"3"]||[orderinfo.workStatus isEqualToString:@"7"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"undo"];
//        }else if([orderinfo.workStatus isEqualToString:@"4"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"doing"];
//        }else if([orderinfo.workStatus isEqualToString:@"6"]||[orderinfo.workStatus isEqualToString:@"8"]||[orderinfo.workStatus isEqualToString:@"10"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"finish"];
//        }else if([orderinfo.workStatus isEqualToString:@"11"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"editorder"];
//        }
//
//        cell.titlelabel.text = itemName;
//        cell.addresslabel.text = orderinfo.serviceAddress;
      
    }
    return cell;
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfo * orderinfo = [_dataArray objectAtIndex:indexPath.section];
    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc]initMinuteTaskControllerwithOrderInfo:self.dataArray[indexPath.section]];
    minuteTaskContoller.type = @"1";
    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:minuteTaskContoller animated:YES];
}

@end
