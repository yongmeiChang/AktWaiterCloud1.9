//
//  ServicePojController.h
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/7.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownOrderController;
@interface ServicePojController : BaseControllerViewController
@property(nonatomic,strong) DownOrderController * DoContoller;
@property(nonatomic,strong) ServicePojInfo*selectInfo;
@end
