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
    self.leftlabel.text = cellInfo.fullName;
    if ([cellInfo.id isEqualToString:select.id]) {
        self.btnSelect.selected = YES;
    }
}

-(void)setSigninDetailsCellInfo:(SigninDetailsInfo *)cellInfo selectCellInfo:(SigninDetailsInfo *)select;{ // 选择租户
    self.leftlabel.text = cellInfo.name;
    self.leftlabel.font = [UIFont systemFontOfSize:13];
    self.leftlabel.textColor = kColor(@"C1");
    [self.btnSelect setImage:[UIImage imageNamed:@"duihao_normal"] forState:UIControlStateNormal];
    [self.btnSelect setImage:[UIImage imageNamed:@"duihao_select"] forState:UIControlStateSelected];
    self.btnTopConstraint.constant =9;
    
  if ([cellInfo.id isEqualToString:select.id]) {
        self.btnSelect.selected = YES;
    }
}


@end
