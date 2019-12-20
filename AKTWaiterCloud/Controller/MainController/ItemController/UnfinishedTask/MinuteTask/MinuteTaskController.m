//
//  MinuteTaskController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/1.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MinuteTaskController.h"
#import "OrderTaskFmdb.h"
#import "PlanTaskCell.h"
#import "SignInCell.h"
#import "SignoutController.h"
#import "DateUtil.h"
#import "EditOrderController.h"
#import "VisitCell.h"
#import "NoDateCell.h"
@interface MinuteTaskController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,PlanTaskPhoneDelegate>
@property(nonatomic,strong) OrderTaskFmdb * orderfmdb;
@property(nonatomic,strong) OrderInfo * orderinfo;
@property(weak,nonatomic) IBOutlet UITableView * minuteTaskTableView;

@property(nonatomic,strong) UILabel * signinDateLabel;//签入日期
@property(nonatomic,strong) UILabel * signoutDateLabel;//签出日期
@property(nonatomic,strong) UILabel * signoutDateLengthLabel;//签出服务时长
@property(nonatomic,strong) SignoutController * sgController;

@property (weak, nonatomic) IBOutlet UIButton *btnSingInOrSingOut;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewTop;

@end

@implementation MinuteTaskController

-(id)initMinuteTaskControllerwithOrderInfo:(OrderInfo *)orderinfo{
    if(self = [super init]){
        self.orderinfo = orderinfo;
        return self;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"任务详情"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    self.tableTop.constant = AktNavAndStatusHight;
    self.bgviewTop.constant = AktNavAndStatusHight+200;
    
    self.netWorkErrorView.hidden = YES;
    self.minuteTaskTableView.delegate = self;
    self.minuteTaskTableView.dataSource = self;
    
    if([self.type isEqualToString:@"1"]){ // 我的-工单任务
        self.viewHeightConstraint.constant = 0;
    }else{ // 任务
        self.viewHeightConstraint.constant = 84;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _sgController = [[SignoutController alloc] init];
    if([self.orderinfo.workStatus isEqualToString:@"4"]){
        _sgController.type = 1;
         [self.btnSingInOrSingOut setTitle:@"任务签出" forState:UIControlStateNormal];
    }else if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]){
        _sgController.type = 0;
         [self.btnSingInOrSingOut setTitle:@"任务签入" forState:UIControlStateNormal];
    }
}

#pragma mark - showUserMoney
-(void)showUserMoney{ //显示用户余额
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"请求中..."];
    NSDictionary * param = @{@"customerId":_orderinfo.customerId,@"customerName":_orderinfo.customerName,@"tenantsId":appDelegate.userinfo.tenantsId};
    [[AFNetWorkingRequest sharedTool] requestWithGetCustomerBalanceParameters:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        NSString * message = @"";
        if([code intValue] == 1){
            NSString * object = dic[@"object"];
            message = [[object componentsSeparatedByString:@"："] objectAtIndex:1];
            [self showMessageAlertWithController:self title:@"" Message:message canelBlock:^{
                
            }];
        }else{
            message = [dic objectForKey:@"message"];
            [self showMessageAlertWithController:self Message:message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)clickEdit{
    EditOrderController * eoController = [[EditOrderController alloc] init];
    eoController.serviceid = self.orderinfo.serviceItemId;
    eoController.untype = self.orderinfo.unitType;
    eoController.oldmoney = self.orderinfo.serviceMoney;
    eoController.oldBeginTime = self.orderinfo.serviceBegin;
    eoController.workstuats = self.orderinfo.workStatus;
    eoController.oldEndTime = self.orderinfo.serviceEnd;
    eoController.workid = self.orderinfo.id;
    eoController.workNo = self.orderinfo.workNo;
    eoController.stationId = self.orderinfo.stationId;
    eoController.oldService = self.orderinfo.serviceItemName;
    [self.navigationController pushViewController:eoController animated:YES];
}

#pragma mark - nav back
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
/**行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([Vaildate dx_isNullOrNilWithObject:self.orderinfo]){
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 200;
    }else if(indexPath.section==1){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
            return 105.5;
        }else{
            return 180;
        }
    }else if(indexPath.section==2){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"4"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
            return 105.5;
        }else{
            return 240;
        }
    }else if(indexPath.section==3){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"4"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
            return 105.5;
        }else{
            return 177;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
       return 0.01;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"PlanTaskCell";
    static NSString *cellidentify1 = @"SignInCell";
    static NSString *cellidentify3 = @"VisitCell";
    static NSString *cellidentify4 = @"NoDateCell";

    if(indexPath.section==0){
        PlanTaskCell * cell;
        cell = (PlanTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellidentify owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self;
        [cell setOrderList:self.orderinfo];
        return cell;
    }else if(indexPath.section==1){

        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"11"]){

            NoDateCell * sCell;
            sCell = (NoDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify4];
            if (sCell == nil) {
                sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify4 owner:self options:nil] objectAtIndex:0];
            }
            sCell.leftLabel.text = @"签入情况";
            return sCell;
        }else{
            SignInCell * sCell;
            sCell = (SignInCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify1];
            if (sCell == nil) {
                sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify1 owner:self options:nil] objectAtIndex:0];
            }
            [sCell setSignInInfo:self.orderinfo];
            
            UITapGestureRecognizer *openSinImageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageIn)];
            openSinImageTapGestureRecognizer.delegate = self;
            [sCell.photoview addGestureRecognizer:openSinImageTapGestureRecognizer];
            return sCell;
        }
    }else if(indexPath.section==2){
        if([self.orderinfo.workStatus isEqualToString:@"3"]||[self.orderinfo.workStatus isEqualToString:@"7"]||[self.orderinfo.workStatus isEqualToString:@"4"]||[self.orderinfo.workStatus isEqualToString:@"11"]){
        
            NoDateCell * sCell;
            sCell = (NoDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify4];
            if (sCell == nil) {
                sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify4 owner:self options:nil] objectAtIndex:0];
            }
            sCell.leftLabel.text = @"签出情况";
            return sCell;
        }else{
            SignInCell * soutCell;
            soutCell = (SignInCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify1];
            if (soutCell == nil) {
                soutCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify1 owner:self options:nil] objectAtIndex:0];
            }
            [soutCell setSignOutInfo:self.orderinfo];
            
            UITapGestureRecognizer *openSinImageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageOut)];
            openSinImageTapGestureRecognizer.delegate = self;
            [soutCell.photoview addGestureRecognizer:openSinImageTapGestureRecognizer];
            
            return soutCell;
        }
    }else if(indexPath.section==3){
            
            if([self.orderinfo.workStatus isEqualToString:@"6"]||[self.orderinfo.workStatus isEqualToString:@"8"]||[self.orderinfo.workStatus isEqualToString:@"10"]){
              VisitCell * visitCell;
              visitCell = (VisitCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify3];
              if (visitCell == nil) {
                  visitCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify3 owner:self options:nil] objectAtIndex:0];
              }
                [visitCell setVisitInfo:self.orderinfo];
                return visitCell;
            }else{
                NoDateCell * sCell;
                sCell = (NoDateCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify4];
                if (sCell == nil) {
                    sCell = [[[NSBundle mainBundle] loadNibNamed:cellidentify4 owner:self options:nil] objectAtIndex:0];
                }
                sCell.leftLabel.text = @"回访情况";
                return sCell;
            }
        }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.minuteTaskTableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 签入  签出
- (IBAction)orderSingInOrSingOutClick:(UIButton *)sender {
    NSLog(@"点击签入 签出按钮");
    _sgController.orderinfo = self.orderinfo;
       [self.navigationController pushViewController:_sgController animated:YES];
}

#pragma mark - showImageIn
-(void)showImageIn{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"加载中..."];
    NSDictionary * param = @{@"workOrderId":self.orderinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"signType":@"101"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = dic[@"object"];
            if(obj.count>0){
                NSDictionary * object = obj[0];
                NSString * affixName = object[@"affixUrl"];
                NSString * imagebaseStr = [NSString stringWithFormat:@"%@",affixName];
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imagebaseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIView * popview = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                popview.backgroundColor = [UIColor grayColor];
                //popview.alpha=0.7;
                UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [popview setTag:10];
                
                UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [popview addSubview:photoImageView];
                photoImageView.image = [UIImage imageWithData:imageData];
                
                [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
                [closeBtn addTarget:self action:@selector(closedPopview) forControlEvents:UIControlEventTouchUpInside];
                [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [popview addSubview: closeBtn];
                
                [self.view addSubview:popview];
                
                [popview mas_makeConstraints:^(MASConstraintMaker *make) {
                    if(KIsiPhoneX){
                        make.top.mas_equalTo(128);
                    }else{
                        make.top.mas_equalTo(104);
                    }
                    make.left.mas_equalTo(40);
                    make.right.mas_equalTo(-40);
                    make.bottom.mas_equalTo(-80);
                }];
                
                [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(popview.mas_right).offset(0);
                    make.top.equalTo(popview.mas_top).offset(0);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(30);
                }];
                
                [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.bottom.mas_equalTo(0);
                }];
            }
        }else{
            [self showMessageAlertWithController:self Message:@"没有图片"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)closedPopview{
    for(UIView * v in self.view.subviews){
        if(v.tag == 10){
            [v removeFromSuperview];
        }
    }
}

-(void)showImageOut{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:@"加载中..."];
    NSDictionary * param = @{@"workOrderId":self.orderinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"signType":@"102"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = dic[@"object"];
            NSDictionary * object = obj[0];
            NSString * affixName = object[@"affixUrl"];
            NSString * imagebaseStr = [NSString stringWithFormat:@"%@",affixName];
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imagebaseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIView * popview = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            popview.backgroundColor = [UIColor grayColor];
            //popview.alpha=0.7;
            UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [popview setTag:10];
            
            UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [popview addSubview:photoImageView];
            photoImageView.image = [UIImage imageWithData:imageData];
            
            [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closedPopview) forControlEvents:UIControlEventTouchUpInside];
            [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [popview addSubview: closeBtn];
            
            [self.view addSubview:popview];
            
            [popview mas_makeConstraints:^(MASConstraintMaker *make) {
                if(KIsiPhoneX){
                    make.top.mas_equalTo(128);
                }else{
                    make.top.mas_equalTo(104);
                }
                make.left.mas_equalTo(40);
                make.right.mas_equalTo(-40);
                make.bottom.mas_equalTo(-80);
            }];
            
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(popview.mas_right).offset(0);
                make.top.equalTo(popview.mas_top).offset(0);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(30);
            }];
            
            [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.mas_equalTo(0);
            }];
        }else{
            [self showMessageAlertWithController:self Message:@"没有图片"];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - call phone
-(void)didSelectPhonecomster:(NSString *)phone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}

//日期比较
-(int)compareDate:(NSDate *)btime endtime:(NSDate *)etime{
    NSComparisonResult result = [btime compare:etime];
    NSLog(@"date1 : %@, date2 : %@", btime, etime);
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}
@end
