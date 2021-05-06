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
        NSDictionary * param = @{@"customerUkey":str,@"waiterId":model.uuid,@"tenantsId":kString(model.tenantId)};
        [[AFNetWorkingRequest sharedTool] requestWithScanWorkOrderParameters:param type:HttpRequestTypeGet success:^(id responseObject) {
            NSDictionary * dic = responseObject;
            NSString * message = [dic objectForKey:@"message"];
            NSNumber * code = [dic objectForKey:@"code"];
            if([code longValue]==1){

                NSArray * arr = [[NSArray alloc] init];
                arr = [dic objectForKey:ResponseData];
                if(arr.count==0){
                    [controller showMessageAlertWithController:controller title:@"提示" Message:@"当前没有工单!" canelBlock:^{
                        QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                        [qvcontroller.session startRunning];
                    }];
                }else if(arr.count==1){//getOrderTaskByWorkNo 当前用户只有一个工单 直接跳转到任务详情页面
                    OrderInfo * orderinfo;
                    NSMutableDictionary * object = [arr objectAtIndex:0];
                    orderinfo = [[OrderInfo alloc] initWithDictionary:object error:nil];
                    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc] initMinuteTaskControllerwithOrderInfo:orderinfo];
                    minuteTaskContoller.type = @"0";
                    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
                    [qv.unfinishController.navigationController pushViewController:minuteTaskContoller animated:YES];
                }else{
                    qv.unfinishController.taskTableview.hidden = NO;
                    qv.unfinishController.netWorkErrorView.hidden = YES;
                    NSMutableArray * editArray =[NSMutableArray array];
                    for (NSMutableDictionary * dicc in arr) {
                        NSDictionary * objdic = (NSDictionary*)dicc;
                        OrderInfo * orderinfo;
                        //判断工单是否本地有缓存,有缓存则更新，没缓存则添加至缓存
                        if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil){
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            [qv.unfinishController.dataArray addObject:orderinfo];
                        }else{
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            [qv.unfinishController.dataArray addObject:orderinfo];

                        }
                    }
                    if(editArray.count>0){
                        for(int i = 0; i< editArray.count; i++){
                            [qv.unfinishController.dataArray insertObject:editArray[i] atIndex:i];
                        }
                    }
                    qv.unfinishController.pushType=@"1";
                    [qv.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [controller showMessageAlertWithController:controller title:@"提示" Message:@"当前没有工单!" canelBlock:^{
                    QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                    [qvcontroller.session startRunning];
                }];
            }
            [[AppDelegate sharedDelegate] hidHUD];
        } failure:^(NSError *error) {
            [[AppDelegate sharedDelegate] hidHUD];
            [controller showMessageAlertWithController:controller title:@"提示" Message:@"当前没有工单!" canelBlock:^{
                QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                [qvcontroller.session startRunning];
            }];
        }];
        
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
