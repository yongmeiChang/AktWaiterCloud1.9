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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setStatus:Loading];
    
    if(self.type == 0){//扫码查询工单 签入 签出
        QRCodeViewController * qv = (QRCodeViewController *)controller;
        NSDictionary * param = @{@"customerUkey":str,@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId};
        [[AFNetWorkingRequest sharedTool] requestWithScanWorkOrderParameters:param type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary * dic = responseObject;
            NSString * message = [dic objectForKey:@"message"];
            NSNumber * code = [dic objectForKey:@"code"];
            if([code longValue]==1){

                NSArray * arr = [[NSArray alloc] init];
//                NSDictionary * obj = [dic objectForKey:@"object"];
//                arr = obj[@"result"];
                arr = [dic objectForKey:@"object"];
                if(arr.count==0){
                    [controller showMessageAlertWithController:controller title:@"提示" Message:@"当前没有工单!" canelBlock:^{
                        QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                        [qvcontroller.session startRunning];
                    }];
                }else if(arr.count==1){//getOrderTaskByWorkNo
                    OrderInfo * orderinfo;
                    NSMutableDictionary * object = [arr objectAtIndex:0];
                    [object setObject:[[object objectForKey:@"createBy"] objectForKey:@"id"] forKey:@"createBy"];// 数据解析-替换
                    [object setObject:[[object objectForKey:@"updateBy"] objectForKey:@"id"] forKey:@"updateBy"];
                 
                    orderinfo = [[OrderInfo alloc] initWithDictionary:object error:nil];
                    MinuteTaskController * minuteTaskContoller = [[MinuteTaskController alloc] initMinuteTaskControllerwithOrderInfo:orderinfo];
                    minuteTaskContoller.type = @"0";
                    minuteTaskContoller.hidesBottomBarWhenPushed = YES;
                    if([AppInfoDefult sharedClict].islongLocation == 1){
                        minuteTaskContoller.lm = qv.unfinishController.locationManager;
                    }
                    [qv.unfinishController.navigationController pushViewController:minuteTaskContoller animated:YES];
                }else{
                    qv.unfinishController.taskTableview.hidden = NO;
                    qv.unfinishController.netWorkErrorView.hidden = YES;
                    NSMutableArray * editArray =[NSMutableArray array];
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
                        //self.orderfmdb = [[OrderTaskFmdb alloc]init];
                        OrderInfo * orderinfo;
                        //判断工单是否本地有缓存,有缓存则更新，没缓存则添加至缓存
                        orderinfo = [qv.unfinishController.orderfmdb findByWorkNo:[objdic objectForKey:@"workNo"]];
                        if([orderinfo.tid isEqualToString:@"nil"]||orderinfo.tid == nil){
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            if([orderinfo.workStatus isEqualToString:@"11"]){
                                [editArray addObject:orderinfo];
                            }else{
                                [qv.unfinishController.dataArray addObject:orderinfo];
                            }
                            [qv.unfinishController.orderfmdb saveOrderTask:orderinfo];
                        }else{
                            orderinfo=[[OrderInfo alloc] initWithDictionary:objdic error:nil];
                            orderinfo.tid = orderinfo.id;
                            if([orderinfo.workStatus isEqualToString:@"11"]){
                                [editArray addObject:orderinfo];
                            }else{
                                [qv.unfinishController.dataArray addObject:orderinfo];
                            }
                            [qv.unfinishController.orderfmdb updateObject:orderinfo];
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
                //[controller.navigationController popToRootViewControllerAnimated:YES];
                [controller showMessageAlertWithController:controller title:@"提示" Message:@"当前没有工单!" canelBlock:^{
                    QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                    [qvcontroller.session startRunning];
                }];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            //[controller.navigationController popToRootViewControllerAnimated:YES];
            [controller showMessageAlertWithController:controller title:@"提示" Message:@"当前没有工单!" canelBlock:^{
                QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                [qvcontroller.session startRunning];
            }];
        }];
        
    }else if(self.type==1){//扫码添加工单
        NSDictionary * param = @{@"customerUkey":str,@"tenantsId":appDelegate.userinfo.tenantsId};
        [[AFNetWorkingRequest sharedTool] requestWithStartOrderFormParameters:param type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber * code = dic[@"code"];
            if([code intValue] == 2){
                [SVProgressHUD dismiss];
                [controller showMessageAlertWithController:controller title:@"提示" Message:dic[@"message"] canelBlock:^{
                    QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                    [qvcontroller.session startRunning];
                }];
                return;
            }
            NSDictionary * object = dic[@"object"];
            DownOrderFirstInfo *font = [[DownOrderFirstInfo alloc]initWithDictionary:object error:nil];
            DownOrderController * doController = [[DownOrderController alloc] initDownOrderControllerWithCustomerUkey:font customerUkey:str];
            [controller.navigationController pushViewController:doController animated:YES];
            doController.hidesBottomBarWhenPushed = YES;
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [controller showMessageAlertWithController:controller title:@"提示" Message:@"操作失败，请稍后再试" canelBlock:^{
                QRCodeViewController * qvcontroller = (QRCodeViewController *)controller;
                [qvcontroller.session startRunning];
            }];
        }];
        
    }else if(self.type==2){//手动添加工单
        NSDictionary * param = @{@"customerUkey":str,@"tenantsId":appDelegate.userinfo.tenantsId};
        [[AFNetWorkingRequest sharedTool] requestWithStartOrderFormParameters:param type:HttpRequestTypePost success:^(id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber * code = dic[@"code"];
            if([code intValue] == 2){
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:dic[@"message"]];
                return;
            }
            NSDictionary * object = dic[@"object"];
            DownOrderFirstInfo *font = [[DownOrderFirstInfo alloc]initWithDictionary:object error:nil];
            DownOrderController * doController = [[DownOrderController alloc] initDownOrderControllerWithCustomerUkey:font customerUkey:str];
            [controller.navigationController pushViewController:doController animated:YES];
            doController.hidesBottomBarWhenPushed = YES;
         
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [controller showMessageAlertWithController:controller Message:@"操作失败，请稍后再试"];
        }];
    }
}
@end
