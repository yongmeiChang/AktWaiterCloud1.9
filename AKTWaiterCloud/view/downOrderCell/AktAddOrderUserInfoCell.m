//
//  AktAddOrderUserInfoCell.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/16.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktAddOrderUserInfoCell.h"

@implementation AktAddOrderUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 7.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
