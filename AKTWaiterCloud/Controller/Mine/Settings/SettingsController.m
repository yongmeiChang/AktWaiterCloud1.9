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
#import "AktFeedBackVC.h"

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
        self.itemArray=@[@"密码修改",@"清除缓存",@"当前版本",@"关于我们",@"意见反馈"];
    }
    [self setNavTitle:@"设置"];
    
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];

}

#pragma mark - left click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    float size = [[SDImageCache sharedImageCache]getSize]/1024.0/1024.0;
    [cell setuserSetInfo:self.itemArray Index:indexPath CacheSize:[NSString stringWithFormat:@"%.1lf",size]];
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
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清除缓存?" preferredStyle:UIAlertControllerStyleAlert];
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
        case 4:{
            AktFeedBackVC *feedback = [[AktFeedBackVC alloc] init];
            [self.navigationController pushViewController:feedback animated:YES];
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
    [[AktLoginCmd sharedTool] requestAppVersionParameters:@{@"appKind":@"1",@"appType":@"2"} type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = [responseObject objectForKey:ResponseData];
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            // 最新版本号
            NSString *iTunesVersion = dic[@"versions"];
            // 应用程序介绍网址(用户升级跳转URL)
            NSString *trackViewUrl = [NSString stringWithFormat:@"%@",dic[@"downloadUrl"]];
            
            if ([AktUtil serviceOldCode:iTunesVersion serviceNewCode:versionValueStringForSystemNow]) {
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
              [self showMessageAlertWithController:self Message:@"当前为最新版本"];
            }
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
        //注销登录删除用户数据
        [[SaveDocumentArray sharedInstance] removefmdb];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:Token];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AKTName];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AKTPwd];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:ChangeRootViewController object:nil];

    }];
    [alertController addAction:canelAction];
    [alertController addAction:okAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
