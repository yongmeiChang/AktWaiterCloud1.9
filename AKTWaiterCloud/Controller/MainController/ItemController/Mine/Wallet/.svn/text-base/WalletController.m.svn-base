//
//  WalletController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "WalletController.h"
#import "WallectCell.h"
@interface WalletController ()<UITableViewDataSource,UITableViewDelegate>
@property(weak,nonatomic) IBOutlet UITableView * dateTableview;
@property(weak,nonatomic) IBOutlet UIView * firstView;
@property(weak,nonatomic) IBOutlet UIView * secondView;
@property(weak,nonatomic) IBOutlet UILabel * secondLabel;
@property(weak,nonatomic) IBOutlet UILabel * integralLabel;
@property(weak,nonatomic) IBOutlet UIImageView * integralImageview;
@property(weak,nonatomic) IBOutlet UILabel * otherLabel;
@property(weak,nonatomic) IBOutlet UIImageView * firstBg;
@property(nonatomic,strong) NSMutableArray * moneyArray;
@end

@implementation WalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moneyArray = [NSMutableArray array];
    [self requestWorkMoney];
    [self initNavItem];
    [self initLayout];
    self.dateTableview.delegate=self;
    self.dateTableview.dataSource = self;
}

-(void)initNavItem{
    [self setTitle:@"我的钱包"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initLayout{
    CGRect rectStatus = appStatusBarFrame;
    float pjHeight = (SCREEN_HEIGHT-rectStatus.size.height-44)*0.2;
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rectStatus.size.height+44);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(pjHeight);
    }];
    
    [self.firstBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.firstView);
    }];
    
    [self.integralImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstView).offset(-20);
        make.centerX.equalTo(self.firstView).offset(-self.integralImageview.frame.size.width/4-10);
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstView).offset(-20);
        make.centerX.equalTo(self.firstView).offset(self.integralLabel.frame.size.width/4-10);
    }];
//    if(SCREEN_WIDTH<375){
//        self.integralLabel.font = [UIFont systemFontOfSize:19.0f];
//    }
    
    [self.otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.firstView).offset(-5);
        make.centerY.equalTo(self.firstView).offset(20);
    }];
//    if(SCREEN_WIDTH<375){
//        self.otherLabel.font = [UIFont systemFontOfSize:15.0f];
//    }
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(pjHeight/2);
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondView);
        if(SCREEN_WIDTH<375){
            make.left.mas_equalTo(35);
        }else{
            make.left.mas_equalTo(40);
        }
    }];

    
    [self.dateTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark  tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**行数*/;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _moneyArray.count;
}


//设置分割线上下去边线，顶头缩进15
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dateTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dateTableview setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 25)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 设置section背景颜色
    view.tintColor = [UIColor colorWithRed:226/255.0f green:231/255.0f blue:237/255.0f alpha:1];
}


//cell高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"WallectCell";
    WallectCell *cell = (WallectCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WallectCell" owner:self options:nil] objectAtIndex:0];
    }
    WorkMoneyInfo * wmInfo = [_moneyArray objectAtIndex:indexPath.row];
    cell.dateLabel.text = wmInfo.serviceBegin;
    cell.finishedCountLabel.text = [NSString stringWithFormat:@"完成%@个",wmInfo.workNo];
    //千位分隔符
    NSNumberFormatter *moneyFormatter = [[NSNumberFormatter alloc] init];
    moneyFormatter.positiveFormat = @"###,##0";
    NSNumber * money = @([wmInfo.serviceMoney integerValue]);
    NSString *formatString = [moneyFormatter stringFromNumber:money];
    if([wmInfo.serviceMoney isEqualToString:@"0"]){
        cell.moneyLabel.text = wmInfo.serviceMoney;
        [cell.moneyLabel setTextColor:[UIColor blackColor]];
    }else{
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@",formatString];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(void)requestWorkMoney{
    NSDictionary * dic = @{@"waiterId":appDelegate.userinfo.uuid,@"tenantsId":appDelegate.userinfo.tenantsId};
    NSString *url = @"statisticsWorkMoney";
    
    [[AFNetWorkingTool sharedTool] requestWithURLString:url parameters:dic type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:@"code"];
        if([code intValue] == 1){
            NSArray * objArr = [NSArray array];
            objArr = [dic objectForKey:@"object"];
            if(objArr.count>0){
                for (NSDictionary * dic in objArr) {
                    WorkMoneyInfo * workmoneyInfo = [[WorkMoneyInfo alloc] initWithDictionary:dic error:nil];
                    [_moneyArray addObject:workmoneyInfo];
                    self.secondLabel.hidden = NO;
                }
            }else{
                self.secondLabel.hidden = YES;
            }
            [self.dateTableview reloadData];
        }else{
            self.secondLabel.hidden = YES;
        }
    } failure:^(NSError *error) {
        self.secondLabel.hidden = YES;
    }];
      
}

@end
