//
//  AktOldPeopelCell.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/5/18.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import "AktOldPeopelCell.h"

@implementation AktOldPeopelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOldpeopleCallPhone:(NSString *)phone oldName:(NSString *)name{
    self.LabName.text = kString(name);
    self.labValue.text = kString(phone);
    self.btnValue.tag = [phone integerValue];
}

- (IBAction)btnClick:(UIButton *)sender {
    NSString *strphone = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([_delegate respondsToSelector:@selector(didSelectCallPhone:)]) {
        [_delegate didSelectCallPhone:strphone];
     }
}


@end
