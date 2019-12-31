//
//  NotifyController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "NotifyController.h"
#import "NotifyCell.h"
#import "Vaildate.h"
#import "MinuteTaskController.h"
@interface NotifyController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic) IBOutlet UITableView * tabeleview;
@property (weak, nonatomic) IBOutlet UIButton *noDateImage;
@property (weak, nonatomic) IBOutlet UIButton *noDatelab;


@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation NotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除没有数据时的分割线
    self.tabeleview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tabeleview.delegate = self;
    self.tabeleview.dataSource = self;
    self.dataArray = [NSMutableArray array];
    [self setNavTitle:@"通知"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    [self getPushRecordService];
}

-(void)getPushRecordService{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"请求中..."];
    NSDictionary * dic = @{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId};
    [[AFNetWorkingRequest sharedTool] requestgetPushRecordService:dic type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;

        if([dic[@"code"] intValue]==1){
            if(![dic objectForKey:@"object"]){
                [[AppDelegate sharedDelegate] hidHUD];
                return;
            }
            NSArray * arr = dic[@"object"];
          if(arr && arr.count>0){
              [self.tabeleview setHidden:NO];
                for(NSDictionary * dic in arr){
                    [self.dataArray addObject:dic];
                }
                [self.tabeleview reloadData];
            }else{
                [self.tabeleview setHidden:YES];
            }
        }else{
            [self showMessageAlertWithController:self title:@""
                                         Message:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]] canelBlock:^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
        }
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
        [self showMessageAlertWithController:self title:@""
                                     Message:error.domain canelBlock:^{
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
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
        NSDictionary * dic = @{@"workOrderId":workid,@"tenantsId":appDelegate.userinfo.tenantsId};
        [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
        [[AFNetWorkingRequest sharedTool] requestgetWorkOrder:dic type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary * dic = responseObject;
            if([dic[@"code"] intValue]==1){
                NSMutableDictionary * dicc = dic[@"object"];
                NSDictionary * createBydic = [dicc objectForKey:@"createBy"];
                NSDictionary * updateBydic = [dicc objectForKey:@"updateBy"];
                NSString * createBy = [createBydic objectForKey:@"id"];
                NSString * updateBy = [updateBydic objectForKey:@"id"];
                [dicc removeObjectForKey:@"createBy"];
                [dicc removeObjectForKey:@"updateBy"];
                [dicc setObject:createBy forKeyedSubscript:@"createBy"];
                [dicc setObject:updateBy forKeyedSubscript:@"updateBy"];
                NSDictionary * objdic = (NSDictionary*)dicc;
                OrderInfo * orderinfo = [[OrderInfo alloc] initWithDictionary:objdic error:nil];
                MinuteTaskController * mtController = [[MinuteTaskController alloc] initMinuteTaskControllerwithOrderInfo:orderinfo];
                [self.navigationController pushViewController:mtController animated:YES];
            }
            [[AppDelegate sharedDelegate] hidHUD];
        } failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
        }];
    }else{
        return;
    }
}

#pragma mark -
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNullCKEL123:(UIButton *)sender {
    [self getPushRecordService];
}


@end
