//
//  EditUserInfoController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/18.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "EditUserInfoController.h"
#import "MineController.h"
#import "AktTitleCell.h"
#import "AktSexView.h"
#import "AktUserImageVC.h" // 放大头像

@interface EditUserInfoController ()<UITableViewDelegate,UITableViewDataSource,AktSexSelectDelegate>{
        NSMutableArray *_selectedAssets;//选择的图片
        BOOL _isSelectOriginalPhoto;
    AktSexView*sexView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet UITableView *tableUser;

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *nowdate;

@property(nonatomic,strong) UIImage * himage;
@property(nonatomic,strong) NSString * headBaseStr;//图片转base64字符串



@end

@implementation EditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.netWorkErrorView.hidden = YES;
    [self setNavTitle:@"个人信息"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@"保存"];
    
    self.tableUser.delegate = self;
    self.tableUser.dataSource = self;

    // 性别
    sexView=[[AktSexView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_HEIGHT)];
    sexView.tag = 100;
    sexView.delegate = self;
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageUserImage:) name:@"chageUserImage" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserFmdb * userdb = [[UserFmdb alloc] init];
    appDelegate.userinfo = [userdb findByrow:0];
    NSLog(@"头像----%@",appDelegate.userinfo.icon);
}

#pragma mark - tableview datesouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

////设置分割线上下去边线，顶头缩进15
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableUser respondsToSelector:@selector(setSeparatorInset:)]) {

            [self.tableUser setSeparatorInset:UIEdgeInsetsMake(0, 41.5, 0, 9.5)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"settingscell";
    AktTitleCell *cell = (AktTitleCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AktTitleCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setUserInfoDetails:appDelegate.userinfo indexPath:indexPath IconImage:self.himage];
    return cell;
}
#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AktUserImageVC *imgVC = [[AktUserImageVC alloc] init];
        imgVC.strImg = [NSString stringWithFormat:@"%@",appDelegate.userinfo.icon];
        [self.navigationController pushViewController:imgVC animated:YES];
    }else if (indexPath.row == 2){
        [[UIApplication sharedApplication].keyWindow addSubview:sexView];
        [sexView selectSexTypeNomal:appDelegate.userinfo];
    }
}

#pragma mark - notice
-(void)chageUserImage:(NSNotification *)chageImage{
    self.himage = [[chageImage userInfo] valueForKey:@"userImage"];
    [self.tableUser reloadData];
}

#pragma mark - save
-(void)saveClick{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"提交中"];
    _headBaseStr = [self imageToBaseString:self.himage];
 
    NSDictionary * params = @{@"id":kString(appDelegate.userinfo.uuid),@"sex":appDelegate.userinfo.sex,@"iconData":kString(_headBaseStr),@"tenantsId":kString(appDelegate.userinfo.tenantsId)};
    [[AktVipCmd sharedTool] requestedSaveUserInfo:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"object"];
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        self.minecontroller.headimage = self.himage;
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        if ([code integerValue] == 1) {
            appDelegate.userinfo.icon = kString([dic objectForKey:@"icon"]);
            appDelegate.userinfo.sex = [dic objectForKey:@"sex"];
            UserFmdb * userdb = [[UserFmdb alloc] init];
            [userdb updateObject:appDelegate.userinfo];
            [self.tableUser reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
        
    }];
}

#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    //    NSString * mimeType = @"image/jpeg";
    //    NSString *encodedImageStr = [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,[data base64EncodedStringWithOptions: 0]];
    //NSLog(@"%@",encodedImageStr);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
#pragma mark - nav click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SearchBarClick{
     [self saveClick];
}
#pragma mark - sex delegate
-(void)theSexviewClose{
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:100] removeFromSuperview];
}
-(void)theSexviewSureTypeEnd:(NSInteger)type{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:100] removeFromSuperview];
    appDelegate.userinfo.sex = [NSString stringWithFormat:@"%ld",(long)type];
    if (type ==0) {
        appDelegate.userinfo.sexName = @"男";
    }else{
        appDelegate.userinfo.sexName = @"女";
    }
    [self.tableUser reloadData];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
