//
//  UnFinishedTaskController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/12.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseViewController.h"

@interface UnfinishOrderTaskController : WorkBaseViewController
@property(weak,nonatomic) IBOutlet UITableView * taskTableview;
@property(nonatomic,strong) NSMutableArray * dataArray;//数据源
@property(nonatomic,strong) NSString * pushType;//1为扫码有数据时跳转来

@end


