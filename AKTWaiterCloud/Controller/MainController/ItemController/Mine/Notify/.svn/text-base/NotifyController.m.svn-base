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
    [self initNavItem];
    [self getPushRecordService];
}

-(void)getPushRecordService{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"请求中..."];
    NSDictionary * dic = @{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId};
    [[AFNetWorkingRequest sharedTool] requestgetPushRecordService:dic type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;

        if([dic[@"code"] intValue]==1){
            if(![dic objectForKey:@"object"]){
                [SVProgressHUD dismiss];
                return;
            }
            NSArray * arr = dic[@"object"];
            if([arr isKindOfClass:[NSNull class]]){
                [self showMessageAlertWithController:self title:@""
                                             Message:@"没有查询到信息" canelBlock:^{
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
            }else if(arr && arr.count>0){
                for(NSDictionary * dic in arr){
                    [self.dataArray addObject:dic];
                }
                [self.tabeleview reloadData];
            }else{
                [self showMessageAlertWithController:self title:@""
                                             Message:@"没有查询到信息" canelBlock:^{
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD dismiss];
            [self showMessageAlertWithController:self title:@""
                                         Message:@"查询失败请重新查询" canelBlock:^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showMessageAlertWithController:self title:@""
                                     Message:@"查询失败请重新查询" canelBlock:^{
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
    }];
}

-(void)initNavItem{
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
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //设置导航栏字体颜色
    //    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

#pragma mark ======= tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"NotifyCell";
    NotifyCell *cell = (NotifyCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotifyCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataArray[indexPath.section];
    cell.dateLabel.text = dic[@"createDate"];
    cell.contentLabel.text = dic[@"content"];
    
    cell.layer.masksToBounds = NO;
    
    cell.layer.contentsScale = [UIScreen mainScreen].scale;
    
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    cell.layer.shadowOpacity = 0.4f;
    
    cell.layer.shadowRadius = 3.f;
    
    cell.layer.shadowOffset = CGSizeMake(4,4);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section];
    NSString * workid = dic[@"workId"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(workid){
        NSDictionary * dic = @{@"workOrderId":workid,@"tenantsId":appDelegate.userinfo.tenantsId};
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setStatus:Loading];
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
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f;
}
@end
