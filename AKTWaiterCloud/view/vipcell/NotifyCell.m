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
    if (noticeAry.count>0) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createDate"]];
        self.contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    }
}

@end
