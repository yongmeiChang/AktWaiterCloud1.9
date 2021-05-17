//
//  VisitCell.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/28.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UILabel * namelabel;
@property(weak,nonatomic) IBOutlet UILabel * timelabel;
@property(weak,nonatomic) IBOutlet UILabel * satisfactorylabel;
@property(weak,nonatomic) IBOutlet UILabel * visitaboutlabel;

-(void)setVisitInfo:(OrderListModel *)orderinfo; // 任务详情 回访情况
@end
