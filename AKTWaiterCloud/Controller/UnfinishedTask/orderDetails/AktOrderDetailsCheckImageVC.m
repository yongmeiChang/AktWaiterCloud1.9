//
//  AktOrderDetailsCheckImageVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/18.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktOrderDetailsCheckImageVC.h"

@interface AktOrderDetailsCheckImageVC ()

@end

@implementation AktOrderDetailsCheckImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"查看图片";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    if ([self.imgtype isEqualToString:@"1"]) {
        [self showImageIn];
    }else if ([self.imgtype isEqualToString:@"2"]){
        [self showImageOut];
    }
}
#pragma mark - back
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 查看签入图片
-(void)showImageIn{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"加载中..."];
    NSDictionary * param = @{@"workOrderId":self.orderId,@"tenantsId":[LoginModel gets].tenantId,@"signType":@"101"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = [dic objectForKey:ResponseData];
            if(obj.count>0){
                
                UIView * popview = [[UIView alloc] init];
                popview.backgroundColor = [UIColor grayColor];
                [popview setTag:10];
                [self.view addSubview:popview];

                UIScrollView *scollBg = [[UIScrollView alloc] init];
                scollBg.contentSize = CGSizeMake(SCREEN_WIDTH*obj.count, SCREEN_WIDTH);
                scollBg.pagingEnabled = YES;
                [popview addSubview:scollBg];
                
                for (int i = 0; i<obj.count; i++) {
                    NSDictionary * object = obj[i];
                    NSString * affixName = object[@"affixUrl"];
                    UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, 0, 0)];
                    photoImageView.clipsToBounds = YES;
                    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
                     photoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kString(affixName)]]]];
                    [scollBg addSubview:photoImageView];
                    
                }
                [popview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(SCREEN_HEIGHT);
                }];
                [scollBg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.mas_equalTo(0);
                }];
            }
        }else{
            [self showMessageAlertWithController:self Message:@"没有图片"];
        }
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
    }];
}
#pragma mark - 查看签出图片
-(void)showImageOut{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"加载中..."];
    NSDictionary * param = @{@"workOrderId":self.orderId,@"tenantsId":[LoginModel gets].tenantId,@"signType":@"102"};
    [[AFNetWorkingRequest sharedTool] requestgetWorkOrderImages:param type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = dic[@"code"];
        if([code intValue]==1){
            NSArray * obj = [dic objectForKey:ResponseData];
            
            UIView * popview = [[UIView alloc] init];
            popview.backgroundColor = [UIColor grayColor];
            [self.view addSubview:popview];
            
            UIScrollView *scollBg = [[UIScrollView alloc] init];
            scollBg.contentSize = CGSizeMake(SCREEN_WIDTH*obj.count, SCREEN_HEIGHT-AktNavAndStatusHight);
            scollBg.pagingEnabled = YES;
            [popview addSubview:scollBg];
            
            for (int i = 0; i<obj.count; i++) {
                NSDictionary * object = obj[i];
                NSString * affixName = object[@"affixUrl"];
                UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-AktNavAndStatusHight)];
                photoImageView.clipsToBounds = YES;
                photoImageView.contentMode = UIViewContentModeScaleAspectFit;
                photoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kString(affixName)]]]];
                [scollBg addSubview:photoImageView];
            }
            [popview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(SCREEN_HEIGHT);
            }];
            [scollBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            
        }else{
            [[AppDelegate sharedDelegate] showTextOnly:@"没有图片"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
