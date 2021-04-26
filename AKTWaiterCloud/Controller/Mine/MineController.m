//
//  MineController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/9.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MineController.h"
#import "MineCell.h"
#import "ButtonUtil.h"
#import "SettingsController.h"
#import "UnfinishOrderTaskController.h"
#import "UnfinifshController.h"
#import "EditUserInfoController.h"
#import "UIButton+Badge.h"
#import "NotifyController.h"
#import "AktServicOldPersonVC.h"

@interface MineController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UserInfo *modelUser;
}
@property (weak, nonatomic) IBOutlet UIButton *unfinishBtn;
@property (weak, nonatomic) IBOutlet UIButton *ongoingBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property(weak,nonatomic) IBOutlet UILabel * namelabel;//名称
@property(weak,nonatomic) IBOutlet UILabel * phoneNumberLabel;//电话
@property(weak,nonatomic) IBOutlet UILabel * levelLabel;//级别
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLab; // 服务站名称

@property(weak,nonatomic) IBOutlet UIView * secondView;//4个查询按钮的父视图
@property (weak, nonatomic) IBOutlet UIView *editView; // 编辑资料父视图
@property (weak, nonatomic) IBOutlet UIView *renZhengView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderWidthConstraint; // 工单所占宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firsViewtop; // 头部view高度
/** collection显示大标题 */
@property(weak,nonatomic) IBOutlet UICollectionView *collectionView;
/** collection布局*/
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property(nonatomic,strong) NSArray * dataSourceArray;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B2");
    self.renZhengView.layer.masksToBounds = YES;
    self.renZhengView.layer.cornerRadius = self.renZhengView.frame.size.height/2;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"个人资料";
    self.dataSourceArray = @[@"老人",@"通知",@"设置"];
    [self collectionViewinit];
    
    //给整个编辑资料视图添加手势以便用户点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEditUserInfo)];
    [_editView addGestureRecognizer:tapGesture];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    modelUser = [UserInfo getsUser];
    [self initLayout]; // 个人信息
    // 获取各类工单数量
    [self resetWorkNumber];
    // 获取个人信息
    [self requestUserInfoUserId:kString([LoginModel gets].uuid)];
}
#pragma mark - 获取个人信息
-(void)requestUserInfoUserId:(NSString *)userid{
    NSDictionary *parma = @{@"id":kString(userid)};
    [[[AktVipCmd alloc] init] requestUserInfo:parma type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:ResponseData];
        UserInfo * user = [[UserInfo alloc] initWithDictionary:dic error:nil];
        user.uuid = user.id;
        [user saveUser];
        //刷新当前页面头像
        if ([user.icon containsString:@"http"]) {
            self.headImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kString(modelUser.icon)]]]];
        }else{
            self.headImageView.image = [UIImage imageNamed:@"defaultuserhead"];
        }
        self.namelabel.text = user.name; // 用户名
        self.phoneNumberLabel.text = user.mobile; // 电话
        self.serviceNameLab.text = [NSString stringWithFormat:@": %@",user.tenantName]; // 所属服务站
        NSString *strLv;
        strLv = [NSString stringWithFormat:@"0"];
//        if ([modelUser.level integerValue] != 0) {
//            strLv = [NSString stringWithFormat:@"%@",user.level];// 等级
//        }
        self.levelLabel.text = [NSString stringWithFormat:@"LV.%@",strLv];
    
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
}
#pragma mark - 工单数量
-(void)resetWorkNumber{
    NSDictionary * params = @{@"waiterId":kString(modelUser.uuid),@"tenantsId":kString(modelUser.tenantId)};
       [[AktVipCmd sharedTool] requestfindToBeHandleCount:params type:HttpRequestTypeGet success:^(id responseObject) {} failure:^(NSError *error) {}];
       //显示登陆时请求的各状态工单数
       self.unfinishBtn.shouldHideBadgeAtZero = YES;
       self.ongoingBtn.shouldHideBadgeAtZero = YES;
       self.finishBtn.shouldHideBadgeAtZero = YES;
    NSString *strUnfinish;
    NSString *strDoing;
    NSString *strFinish;
       if ([appDelegate.unfinish integerValue]>99) { // 超过99 显示99+
           strUnfinish = [NSString stringWithFormat:@"99+"];
       }else{
           strUnfinish = [NSString stringWithFormat:@"%@",kString(appDelegate.unfinish)];
       }
       if ([appDelegate.doing integerValue]>99) {
           strDoing = [NSString stringWithFormat:@"99+"];
       }else{
           strDoing = [NSString stringWithFormat:@"%@",kString(appDelegate.doing)];
       }
       if ([appDelegate.finish integerValue]>99) {
           strFinish = [NSString stringWithFormat:@"99+"];
       }else{
           strFinish = [NSString stringWithFormat:@"%@",kString(appDelegate.finish)];
       }
    self.unfinishBtn.badgeValue = strUnfinish;
    self.ongoingBtn.badgeValue = strDoing;
    self.finishBtn.badgeValue = strFinish;

}
#pragma mark - 跳转编辑视图
//跳转编辑视图
-(void)clickEditUserInfo{
    EditUserInfoController * editController = [[EditUserInfoController alloc] init];
    editController.minecontroller = self;
    //push后隐藏底部导航栏
    editController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editController animated:YES];
}
#pragma mark - collection
//cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

//设置CELL样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCell" forIndexPath:indexPath];
    NSInteger index = indexPath.item;
    cell.titlelabel.text = self.dataSourceArray[index];
    switch (index) {
        case 0:
            cell.imageview.image = [UIImage imageNamed:@"notice"];
            break;
        case 1:
            cell.imageview.image = [UIImage imageNamed:@"notice"];
            break;
        case 2:
            cell.imageview.image = [UIImage imageNamed:@"system"];
            break;
        default:
            cell.imageview.image = nil;
            break;
        }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.item;
   switch (index) {
       case 0:{
           AktServicOldPersonVC *oldPerson = [[AktServicOldPersonVC alloc] init];
           oldPerson.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:oldPerson animated:YES];
       }
           break;
       case 1:{/*
           NotifyController * notifyController = [[NotifyController alloc]init];
           notifyController.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:notifyController animated:YES];*/
           [[AppDelegate sharedDelegate] showTextOnly:@"该功能正在开发中！敬请期待"];
       }
           break;
       case 2:{
           SettingsController * settingsController = [[SettingsController alloc]init];
           settingsController.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:settingsController animated:YES];
       }
           break;
           
       default:
           break;
   }
}
#pragma mark - layout
- (UICollectionViewFlowLayout *)flowLayout{

    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        // 定义大小
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH,53);
        // 设置最小行间距
        _flowLayout.minimumLineSpacing = 1;
        // 设置垂直间距
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        // 设置滚动方向（默认垂直滚动）
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

//注册cell
- (void)collectionViewinit{
    _collectionView.showsVerticalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:@"MineCell"
                                bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"MineCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = self.flowLayout;
}

-(void)initLayout{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    //背景图
    float firstviewHeight = (SCREEN_HEIGHT-60-rectStatus.size.height-44)/10;
    
    self.headImageView.layer.masksToBounds =YES;
    self.headImageView.layer.cornerRadius =35;
    //工单
    self.orderWidthConstraint.constant = SCREEN_WIDTH/4;
    //九宫格
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(firstviewHeight*4);
    }];

}

#pragma mark - click
-(IBAction)unfinshBtn:(id)sender
{
    UnfinifshController * ovcontroller = [[UnfinifshController alloc]init];
    //隐藏导航栏
    ovcontroller.hidesBottomBarWhenPushed = YES;
    UIButton * btn = (UIButton *)sender;
    ovcontroller.bid = btn.tag;
    [self.navigationController pushViewController:ovcontroller animated:YES];
}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

