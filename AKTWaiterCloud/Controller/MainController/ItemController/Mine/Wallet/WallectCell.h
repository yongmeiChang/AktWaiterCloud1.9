//
//  TableViewCell.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/25.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallectCell : UITableViewCell
@property(weak,nonatomic) IBOutlet UILabel * dateLabel;
@property(weak,nonatomic) IBOutlet UILabel * finishedCountLabel;
@property(weak,nonatomic) IBOutlet UILabel * moneyLabel;
@end
