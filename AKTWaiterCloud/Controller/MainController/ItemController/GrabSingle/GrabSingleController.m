//
//  SendOrdersController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/9.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "GrabSingleController.h"
#import "PlanTaskCell.h"
#import <MJRefresh.h>
@interface GrabSingleController ()<UITableViewDelegate,UITableViewDataSource>{
    //int pageSize;//当前分页
}
@property (nonatomic,strong) IBOutlet UITableView * tableview;
@property (nonatomic,strong) NSMutableArray * dataArray;

//@property(nonatomic,strong) MJRefreshAutoGifFooter *footer;
@property(nonatomic,strong) MJRefreshGifHeader * header;

//@property(nonatomic,assign) long pagecount;//分页总数
//@property(nonatomic,assign) int requestype;//0下拉 1上拉
@end

@implementation GrabSingleController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogInfo(@"点击了抢单item");
    [self initWithNavLeftImageName:@"logo" RightImageName:@""];
    self.navigationItem.title = @"抢单";
    
    //刷新抢单页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"grabSingle" object:nil];
    self.dataArray = [NSMutableArray array];
    [self initTaskTableView];
    //[self locationManager];
    [self requestGrabWorkOrder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//   [self.view bringSubviewToFront:self.netWorkErrorView];
//    self.tableview.hidden = YES;
//    self.netWorkErrorView.hidden = YES;

}

//让section的头部跟着一起滑动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableview)
//    {
//        CGFloat sectionHeaderHeight = 20;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

-(void)initTaskTableView{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //去除没有数据时的分割线
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //去除右侧滚动条
    self.tableview.showsVerticalScrollIndicator = NO;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [_header setTitle:@"按住下拉" forState:MJRefreshStateIdle];
    [_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片 (idleImages 是图片)
    [_header setImages:self.imageArrs forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [_header setImages:self.imageArrs forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [_header setImages:self.imageArrs forState:MJRefreshStateRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    _footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置刷新图片
    //[footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    //[_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    //[_footer setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
    //_footer.triggerAutomaticallyRefreshPercent = 50.0;
    self.tableview.mj_header = _header;
    //self.tableview.mj_footer = _footer;
}

-(void)checkNetWork{
    //判断网络状态
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        if([appDelegate.userinfo.isclickOff_line isEqualToString:@"0"]){
            if(appDelegate.netWorkType==Off_line){
                [self showMessageAlertWithController:self Message:ContinueError];
            }else{
                [self showMessageAlertWithController:self Message:LoadingError];
            }
            appDelegate.netWorkType = Off_line;
//            self.orderfmdb = [[OrderTaskFmdb alloc] init];
//            _dataArray = [self.orderfmdb findAllOrderInfo];
            if(_dataArray.count==0){
                self.netWorkErrorView.hidden = NO;
            }else{
                self.netWorkErrorView.hidden = YES;
                [self.tableview reloadData];
            }
        }else{
            [self showMessageAlertWithController:self Message:NetWorkMessage];
        }
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setStatus:Loading];
        [self requestGrabWorkOrder];
    }
}

//获取可以抢的工单
-(void)requestGrabWorkOrder{
    //记录上拉加载的分页
    //pageSize++;
    //NSString * pagenum = @"0";
    //第一次请求以及下拉刷新为pagesize = 1
//    if(self.requestype == 0){
//        pageSize=1;
//        pagenum = [NSString stringWithFormat:@"%d",pageSize];
//        //刷新前清空数据源
//        [self.dataArray removeAllObjects];
//        [_footer resetNoMoreData];
//    }
//    if(self.requestype == 1){
//        pagenum = [NSString stringWithFormat:@"%d",pageSize];
//    }
    
    NSDictionary * params = @{@"tenantsId":appDelegate.userinfo.tenantsId,@"stationId":appDelegate.userinfo.stationNo};
    [[AFNetWorkingRequest sharedTool] requestgetGrapWorkList:params type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSString * message = [dic objectForKey:@"message"];
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue]==1){
            NSArray * arr = [NSArray array];
            if([[dic objectForKey:@"object"] isKindOfClass:[NSDictionary class]]){
                arr = dic[@"object"][@"object"];
            }else{
                arr = dic[@"object"];
            }
            
            //NSNumber * pages = obj[@"pages"];
            //_pagecount = [pages longValue];

            if([message isEqualToString:@"当前没有工单任务!"]){
                [self showOffLineAlertWithTime:1.0  message:@"当前没有工单任务!" DoSomethingBlock:^{
                    self.netWorkErrorView.hidden = NO;
                    self.netWorkErrorView.userInteractionEnabled = YES;
                }];
                return ;
            }else{
                if(arr&&arr.count>0){
                    self.tableview.hidden = NO;
                    self.netWorkErrorView.hidden = YES;
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

                        if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil){
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            [_dataArray addObject:orderinfo];
                        }else{
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            [_dataArray addObject:orderinfo];
                        }
                    }
                    [self.tableview reloadData];
                }else{
//                    if(self.requestype==1){
//                        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
//                    }else{
                        [self showMessageAlertWithController:self Message:@"暂无数据"];
                        self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
                        self.netWorkErrorView.hidden = NO;
                        [SVProgressHUD dismiss];
                        self.netWorkErrorView.userInteractionEnabled = YES;
                    //}
                }
            }
//            if(pageSize ==_pagecount){
//                [_footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
//                [_footer endRefreshing];
//            }
        }else{
            self.netWorkErrorLabel.text = @"暂无数据,轻触重新加载";
            [self showMessageAlertWithController:self Message:@"暂无数据"];
            self.tableview.hidden = YES;
            self.netWorkErrorView.hidden = NO;
            self.netWorkErrorView.userInteractionEnabled = YES;
        }
        if(appDelegate.netWorkType == Off_line){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showOffLineAlertWithTime:0.7  message:NetWorkSuccess DoSomethingBlock:^{
                }];
                appDelegate.netWorkType = On_line;
            });
        }
        [SVProgressHUD dismiss];
        //if(self.requestype == 0){
            [self.tableview.mj_header endRefreshing];
        //}else{
            //[self.tableview.mj_footer endRefreshing];
        //}
        
    }
    failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        self.netWorkErrorView.hidden = NO;
        self.netWorkErrorView.userInteractionEnabled = YES;
        self.netWorkErrorLabel.text = @"暂无数据,请轻触重新加载";
        //if(self.requestype == 0){
            [self.tableview.mj_header endRefreshing];
        //}else{
            //[self.tableview.mj_footer endRefreshing];
        //}
   }];
}

//-(void)loadMoreData{
//    if(pageSize==_pagecount){
//        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
//        [self.tableview.mj_footer endRefreshing];
//        [_footer endRefreshingWithNoMoreData];
//        return;
//    }
//    [self.tableview.mj_footer beginRefreshing];
//    self.requestype = 1;
//    [self checkNetWork];
//}

-(void)loadNewData{
    // 马上进入刷新状态
    [self.tableview.mj_header beginRefreshing];
    //self.requestype = 0;
    [self.dataArray removeAllObjects];
    [self checkNetWork];
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
     if(SCREEN_WIDTH<375){
         return 190.0f;
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
    cell.grabSingleBtn.hidden = NO;
    [cell.grabSingleBtn setTag:indexPath.section];
    [cell.grabSingleBtn.layer setMasksToBounds:YES];
    [cell.grabSingleBtn.layer setCornerRadius:10.0f];
    [cell.grabSingleBtn addTarget:self action:@selector(GrabSingleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 
    if(_dataArray.count>0){
        OrderInfo * orderinfo = _dataArray[indexPath.section];
        [cell setOrderList:orderinfo];
//        cell.namelabel.text = orderinfo.customerName;
//        cell.phonelabel.text = orderinfo.customerPhone;
//        NSString * serviceBeg = [orderinfo.serviceBegin substringToIndex:16];
//        NSString * serviceEn = [orderinfo.serviceEnd substringToIndex:16];
//        cell.datelabel.text = [NSString stringWithFormat:@"%@ —— %@",serviceBeg,serviceEn];
//       
//        cell.workNolabel.text = [NSString stringWithFormat:@"%@",orderinfo.workNo];
//        NSString * itemName = orderinfo.serviceItemName;
//        itemName = [itemName stringByReplacingOccurrencesOfString:@"->" withString:@"  >  "];
//        
//        if([orderinfo.workStatus isEqualToString:@"3"]||[orderinfo.workStatus isEqualToString:@"7"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"undo"];
//        }else if([orderinfo.workStatus isEqualToString:@"4"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"doing"];
//        }else if([orderinfo.workStatus isEqualToString:@"6"]){
//            cell.bgimageview.image = [UIImage imageNamed:@"finish"];
//        }
//        
//        cell.titlelabel.text = itemName;
//        cell.addresslabel.text = orderinfo.serviceAddress;
    }
    return cell;
}

-(void)labelClick{
    DDLogInfo(@"点击了刷新按钮");
    //pageSize=0;
    if([[ReachbilityTool internetStatus] isEqualToString:@"notReachable"]){
        if([appDelegate.userinfo.isclickOff_line isEqualToString:@"0"]){
            if(appDelegate.netWorkType==Off_line){
                [self showMessageAlertWithController:self title:@"提示" Message:ContinueError canelBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }else{
                [self showMessageAlertWithController:self title:@"提示" Message:LoadingError canelBlock:^{
                    self.netWorkErrorView.hidden = NO;
                }];
            }
            appDelegate.netWorkType = Off_line;
            return;
        }else{
            [self showMessageAlertWithController:self Message:@"网络状态不佳,请稍后再试!"];
        }
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:Loading];
    self.netWorkErrorLabel.text = Loading;
    [self requestGrabWorkOrder];
    self.netWorkErrorView.userInteractionEnabled = false;
}

-(void)GrabSingleBtnClick:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    OrderInfo * orderinfo = self.dataArray[sender.tag];
    NSDictionary * params = @{@"tenantsId":appDelegate.userinfo.tenantsId,@"workOrderId":orderinfo.id,@"waiterId":appDelegate.userinfo.id};
    [[AFNetWorkingRequest sharedTool] requestUpdateGrabWorkOrder:params type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        int code = [dic[@"code"] intValue];
        if(code == 1){
            appDelegate.unfinishOrderRf = YES;
            appDelegate.planTaskOrderRf = YES;
            [self showMessageAlertWithController:self Message:@"抢单成功"];
        }else{
            [self showMessageAlertWithController:self Message:@"抢单失败"];
        }
    } failure:^(NSError *error) {
        [self showMessageAlertWithController:self Message:@"请求失败"];
    }];
}
@end
