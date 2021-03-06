//
//  VisitCell.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/28.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "VisitCell.h"

@implementation VisitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setVisitInfo:(OrderListModel *)orderinfo{
    // 回访人
    NSMutableAttributedString *strName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回访人：%@",kString(orderinfo.visitUserName).length == 0 ? @"无":orderinfo.visitUserName] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
       [strName addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 3)];
       self.namelabel.attributedText = strName;
    // 满意度
    NSString *strSatisfaction;
    if ([orderinfo.customerSatisfactionName intValue] == 1) {
        strSatisfaction = [NSString stringWithFormat:@"非常满意"];
    }else if ([orderinfo.customerSatisfactionName intValue] == 2){
        strSatisfaction = [NSString stringWithFormat:@"满意"];
    }else if ([orderinfo.customerSatisfactionName intValue] == 3){
        strSatisfaction = [NSString stringWithFormat:@"一般"];
    }else{
        strSatisfaction = [NSString stringWithFormat:@"不满意"];
    }
    NSMutableAttributedString *strSatis = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满意度：%@",kString(orderinfo.customerSatisfactionName).length == 0 ? @"无":strSatisfaction] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
       [strSatis addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 3)];
       self.satisfactorylabel.attributedText = strSatis;
    // 回访时间
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回访时间：%@",kString(orderinfo.visitDate).length == 0 ? @"无":orderinfo.visitDate] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
    [strTime addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 4)];
    self.timelabel.attributedText = strTime;
    // 回访情况
    NSMutableAttributedString *strVisit = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回访情况：%@",kString(orderinfo.serviceVisit).length == 0 ? @"无":orderinfo.serviceVisit] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
    [strVisit addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 4)];
    self.visitaboutlabel.attributedText = strVisit;

}
@end
