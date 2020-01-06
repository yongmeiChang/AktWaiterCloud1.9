//
//  NotifyCell.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/3/13.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel * dateLabel;
@property (weak,nonatomic) IBOutlet UILabel * contentLabel;

-(void)setNoticeListInfo:(NSArray *)noticeAry Indexpath:(NSIndexPath *)index; // 通知列表

@end
