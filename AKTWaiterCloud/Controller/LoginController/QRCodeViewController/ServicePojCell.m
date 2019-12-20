//
//  ServicePojCell.m
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/9.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import "ServicePojCell.h"

@implementation ServicePojCell

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
-(void)setCellInfo:(ServicePojInfo *)cellInfo selectCellInf:(ServicePojInfo *)select IndexPath:(NSIndexPath *)indexpath{
    self.leftlabel.text = cellInfo.name;
    if ([cellInfo.id isEqualToString:select.id]) {
        self.btnSelect.selected = YES;
    }
}
@end
