//
//  QRCodeService.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "QRCodeService.h"
#import "DownOrderController.h"
#import "UnfinifshController.h"
#import "QRCodeViewController.h"
#import "MinuteTaskController.h"

@implementation QRCodeService

-(void)QRorderRequest:(BaseControllerViewController *)controller Code:(NSString *)str{
    [[AppDelegate sharedDelegate] showLoadingHUD:controller.view msg:Loading];
    LoginModel *model = [LoginModel gets];
    if(self.type == 0){//扫码查询工单 签入 签出
        QRCodeViewController * qv = (QRCodeViewController *)controller;
        qv.unfinishController.strCustmerUkey = kString(str);
        qv.unfinishController.pushType=@"1";
        [qv.navigationController popViewControllerAnimated:YES];
 
    }else if(self.type==1){//扫码添加工单
        NSDictionary * param = @{@"customerUkey":str,@"tenantsId":kString(model.tenantId)};
        [[AFNetWorkingRequest sharedTool] requestWithStartOrderFormParameters:param type:HttpRequestTypeGet success:^(id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber * code = dic[@"code"];
            if([code intValue] == 2){
                [[AppDelegate sharedDelegate] hidHUD];
                [controller showMessageAlertWithController:controller title:@"提示" Message:dic[@"message"] canelBlock:^{
                    QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                    [qvcontroller.session startRunning];
                }];
                return;
            }
            NSDictionary * object = [dic objectForKey:ResponseData];
            DowOrderData *font = [[DowOrderData alloc]initWithDictionary:object error:nil];
            DownOrderController * doController = [[DownOrderController alloc] initDownOrderControllerWithCustomerUkey:font customerUkey:str];
            [controller.navigationController pushViewController:doController animated:YES];
            doController.hidesBottomBarWhenPushed = YES;
            [[AppDelegate sharedDelegate] hidHUD];
        } failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
            [controller showMessageAlertWithController:controller title:@"提示" Message:@"操作失败，请稍后再试" canelBlock:^{
                QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                [qvcontroller.session startRunning];
            }];
        }];
        
    }else if(self.type==2){//手动添加工单
        NSDictionary * param = @{@"customerUkey":str,@"tenantsId":kString(model.tenantId)};
        [[AFNetWorkingRequest sharedTool] requestWithStartOrderFormParameters:param type:HttpRequestTypeGet success:^(id responseObject) {
            [[AppDelegate sharedDelegate] hidHUD];
            NSDictionary *dic = responseObject;
            NSNumber * code = dic[@"code"];
            NSDictionary * object = [dic objectForKey:ResponseData];
            if([code intValue] == 1){
                DowOrderData *font = [[DowOrderData alloc]initWithDictionary:object error:nil];
                DownOrderController * doController = [[DownOrderController alloc] initDownOrderControllerWithCustomerUkey:font customerUkey:str];
                [controller.navigationController pushViewController:doController animated:YES];
                doController.hidesBottomBarWhenPushed = YES;
            }else{
                [[AppDelegate sharedDelegate] showTextOnly:dic[@"message"]];
                return;
            }
           
        } failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
            [controller showMessageAlertWithController:controller Message:@"操作失败，请稍后再试"];
        }];
    }
}
@end
