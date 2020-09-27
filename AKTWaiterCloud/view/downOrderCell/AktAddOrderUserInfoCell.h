//
//  AktAddOrderUserInfoCell.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/16.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AktAddOrderUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UILabel *labArea;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIView *viewBg;

@end

NS_ASSUME_NONNULL_END
