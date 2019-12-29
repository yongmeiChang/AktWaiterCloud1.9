//
//  NotifyCell.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/3/13.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import "NotifyCell.h"

@implementation NotifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setNoticeListInfo:(NSArray *)noticeAry Indexpath:(NSIndexPath *)index{
    
    NSDictionary * dic = noticeAry[index.section];
    self.dateLabel.text = dic[@"createDate"];
    self.contentLabel.text = dic[@"content"];
       
}

@end
