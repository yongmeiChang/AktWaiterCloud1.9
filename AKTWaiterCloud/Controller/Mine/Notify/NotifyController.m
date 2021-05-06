//
//  NotifyController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "NotifyController.h"
#import "NotifyCell.h"
#import "MinuteTaskController.h"

@interface NotifyController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic) IBOutlet UITableView * tabeleview;

@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation NotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除没有数据时的分割线
    self.tabeleview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tabeleview.delegate = self;
    self.tabeleview.dataSource = self;
    self.dataArray = [[NSMutableArray alloc] init];
    [self setNavTitle:@"通知"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    [self.view bringSubviewToFront:self.netWorkErrorView];
    self.tabeleview.hidden = YES;
    self.netWorkErrorView.hidden = YES;
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self getPushRecordService];
}

#pragma mark - request
-(void)getPushRecordService{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    NSDictionary * dic = @{@"waiterId":[LoginModel gets].uuid,@"tenantsId":[LoginModel gets].tenantId};
    [[AktVipCmd sharedTool] requestgetPushRecordService:dic type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;

        if([dic[@"code"] intValue]==1){
            if(![dic objectForKey:ResponseData]){
                [[AppDelegate sharedDelegate] hidHUD];
                return;
            }
            NSArray * arr = [dic objectForKey:ResponseData];
          if(arr && arr.count>0){
              self.tabeleview.hidden = NO;
              self.netWorkErrorView.hidden = YES;
              for(NSDictionary * dic in arr){
                    [self.dataArray addObject:dic];
                }
                [self.tabeleview reloadData];
            }else{
                self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
                self.netWorkErrorView.hidden = NO;
                self.netWorkErrorView.userInteractionEnabled = YES;
                [self.tabeleview setHidden:YES];
            }
        }else{
            [self showMessageAlertWithController:self Message:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]]];
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        [self showMessageAlertWithController:self Message:error.domain];
        self.netWorkErrorView.userInteractionEnabled = YES;
        self.netWorkErrorView.hidden = NO;
    }];
}

#pragma mark - tableview设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"NotifyCell";
    NotifyCell *cell = (NotifyCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotifyCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setNoticeListInfo:self.dataArray Indexpath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section];
    NSString * workid = dic[@"workId"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(workid){
        NSDictionary * dic = @{@"workOrderId":workid,@"tenantsId":[LoginModel gets].tenantId};
        [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
        [[AktVipCmd sharedTool] requestgetWorkOrder:dic type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary * dic = responseObject;
            if([dic[@"code"] intValue]==1){
                NSMutableDictionary * dicc = [dic objectForKey:ResponseData];
                NSDictionary * objdic = (NSDictionary*)dicc;
                OrderInfo * orderinfo = [[OrderInfo alloc] initWithDictionary:objdic error:nil];
                MinuteTaskController * mtController = [[MinuteTaskController alloc] initMinuteTaskControllerwithOrderInfo:orderinfo];
                [self.navigationController pushViewController:mtController animated:YES];
            }
            [[AppDelegate sharedDelegate] hidHUD];
        } failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
        }];
    }
}

#pragma mark -
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)labelClick{
    DDLogInfo(@"点击了刷新按钮");
    self.netWorkErrorView.userInteractionEnabled = false;
    [self getPushRecordService];
}

@end
