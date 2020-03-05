//
//  SettingsController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/10.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "SettingsController.h"
#import "SettingsTableViewCell.h"
#import "LoginViewController.h"
#import "EditPassWordController.h"
#import "AboutUsController.h"
#import "SaveDocumentArray.h"
#import <SDImageCache.h>

@interface SettingsController ()<UITableViewDelegate,UITableViewDataSource>
@property(weak,nonatomic)IBOutlet UITableView * settingTableView;
@property(weak,nonatomic)IBOutlet UIButton * logoffBtn;//注销按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabletTOP;
@property(nonatomic,copy)NSArray * itemArray;
@property (nonatomic,strong)NSTimer *timer;//清楚缓存的定时器
@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B1");
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    
    if(!self.itemArray){
        self.itemArray = [NSArray array];
        self.itemArray=@[@"密码修改",@"清除缓存",@"当前版本",@"关于我们"];
    }
    [self setNavTitle:@"设置"];
    
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];

}

#pragma mark - left click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableview datesouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

////设置分割线上下去边线，顶头缩进15
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.settingTableView respondsToSelector:@selector(setSeparatorInset:)]) {

            [self.settingTableView setSeparatorInset:UIEdgeInsetsMake(0, 41.5, 0, 9.5)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"settingscell";
    SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setuserSetInfo:self.itemArray Index:indexPath];
    return cell;
}
#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            {
                EditPassWordController * editpwdController = [[EditPassWordController alloc] init];
                [self.navigationController pushViewController:editpwdController animated:YES];
            }
            break;
            case 1:
                     {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"警告提示" message:@"是否清除离线的工单信息?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //清除配置信息缓存
                        [[SaveDocumentArray sharedInstance] deleteDocumentArray];
                        [SVProgressHUD showProgress:0 status:@"开始清理"];
                        float size = [[SDImageCache sharedImageCache]getSize]/1024.0/1024.0;
                        if(size >=0 && size <= 10) {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(cleanDiskTimer) userInfo:nil repeats:YES];
                        }else {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(cleanDiskTimer) userInfo:nil repeats:YES];
                        }
                        
                        [[SDImageCache sharedImageCache] clearMemory];
                        [[SDImageCache
                          sharedImageCache]clearDiskOnCompletion:^{
//                            appDelegate.isclean = true;
                            
                        }];
                    }];
                    UIAlertAction * canelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertController addAction:okAction];
                    [alertController addAction:canelAction];
                    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:alertController animated:YES completion:nil];
                     }
                     break;
            case 2:
                     {
                       [self getTheCurrentVersion];
                     }
                     break;
            case 3:
                     {
                         AboutUsController *aboutUs =[[AboutUsController alloc] init];
                         [self.navigationController pushViewController:aboutUs animated:YES];
                     }
                     break;
        default:
            break;
    }
}

#pragma mark 检查更新
-(void)getTheCurrentVersion{
    //获取版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
    
    NSDictionary * dic = @{@"id":@"1294211974",@"appstore":@"appstore"};
    [[AFNetWorkingRequest sharedTool] requestgetversion:dic Url:@"lookup" type:HttpRequestTypePost success:^(id responseObject) {
        //返回信息
        //        minimumOsVersion = "8.0";         //App所支持的最低iOS系统
        //        fileSizeBytes = ;                 //应用的大小
        //        releaseDate = "";                 //发布时间
        //        trackCensoredName = "";           //审查名称
        //        trackContentRating = "";          //评级
        //        trackId = ;                       //应用程序ID
        //        trackName = "";                   //应用程序名称
        //        trackViewUrl = "";                //应用程序介绍网址 需要更新跳转的网址
        //        version = "4.0.3";                //版本号
        NSDictionary * dic = [responseObject[@"results"] firstObject];
        // 最新版本号
        NSString *iTunesVersion = dic[@"version"];
        // 应用程序介绍网址(用户升级跳转URL)
        NSString *trackViewUrl = dic[@"trackViewUrl"];
        
        if ([versionValueStringForSystemNow doubleValue]<[iTunesVersion doubleValue]) {
            NSLog(@"不是最新版本,需要更新");
            UIAlertController * alertview = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到有最新版本，点击跳转更新" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }];
            UIAlertAction * canel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertview addAction:ok];
            [alertview addAction:canel];
            alertview.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertview animated:YES completion:nil];

        } else {
            NSLog(@"已是最新版本,不需要更新!");
            [self showMessageAlertWithController:self Message:@"当前为最新版本"];
        }
    } failure:^(NSError *error) {
        [self showMessageAlertWithController:self Message:@"检测失败，稍后再试"];
    }];
}

- (void)cleanDiskTimer {
    static float value = 0;
    
    value += 0.25;
    if(value <1) {
        [SVProgressHUD showProgress:value status:@"正在清理"];
    }else if(value >= 1 ) {
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
        [self.timer invalidate];
        self.timer = nil;
    }
}

//注销
-(IBAction)logoffUser:(id)sender{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"用户退出登录");
        [self.navigationController popViewControllerAnimated:YES];
        //注销登录删除用户数据
        [[SaveDocumentArray sharedInstance] removefmdb];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AKTserviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BaseControllerViewController *login = [BaseControllerViewController createViewControllerWithName:@"LoginViewController" createArgs:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [[AppDelegate getCurrentVC] presentViewController:nav animated:YES completion:nil];
        
    }];
    [alertController addAction:canelAction];
    [alertController addAction:okAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
