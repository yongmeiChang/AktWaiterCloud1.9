//
//  SignInCell.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/4.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "SignInCell.h"

@implementation SignInCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setSignInInfo:(OrderInfo *)orderinfo{
    self.singOutServiceLengthLab.hidden = YES;
    self.remarklab.hidden = YES;
    // 时间
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时间：%@",kString(orderinfo.actrueBegin).length == 0 ? @"无":orderinfo.actrueBegin] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
    [strTime addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInDateLabel.attributedText = strTime;
    // 距离
    NSMutableAttributedString *strDis = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离：%@米",kString(orderinfo.signInDistance).length == 0 ? @"无":orderinfo.signInDistance] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: kColor(@"C1")}];
    [strDis addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInDistanceLabel.attributedText = strDis;
    // 状态
    NSMutableAttributedString *strStatus = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"状态：%@",kString(orderinfo.signInStatus).length == 0 ? @"无":orderinfo.signInStatus] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: kColor(@"C1")}];
    [strStatus addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInStatusLabel.attributedText = strStatus;
    // 地址
    NSMutableAttributedString *stAddress = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"地址：%@",kString(orderinfo.signInLocation).length==0 ? @"无":orderinfo.signInLocation] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];

    [stAddress addAttributes:@{NSForegroundColorAttributeName: kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInAddressLabel.attributedText = stAddress;
}

-(void)setSignOutInfo:(OrderInfo *)orderinfo{
    self.singOutServiceLengthLab.hidden = NO;
    self.remarklab.hidden = NO;
    self.titleLabel.text = @"签出情况";
    
    // 时间
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时间：%@",kString(orderinfo.actrueEnd).length == 0 ? @"无":orderinfo.actrueEnd] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
    [strTime addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInDateLabel.attributedText = strTime;
    // 距离
    NSMutableAttributedString *strDis = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离：%@米",kString(orderinfo.signOutDistance).length == 0 ? @"无":orderinfo.signOutDistance] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: kColor(@"C1")}];
    [strDis addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInDistanceLabel.attributedText = strDis;
    // 状态
    NSMutableAttributedString *strStatus = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"状态：%@",kString(orderinfo.signOutStatus).length == 0 ? @"无":orderinfo.signOutStatus] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: kColor(@"C1")}];
    [strStatus addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInStatusLabel.attributedText = strStatus;
    // 地址
    NSMutableAttributedString *stAddress = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"地址：%@",kString(orderinfo.signOutLocation).length==0 ? @"无":orderinfo.signOutLocation] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];

    [stAddress addAttributes:@{NSForegroundColorAttributeName: kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInAddressLabel.attributedText = stAddress;
    
    // 服务时长
    NSMutableAttributedString *strserviceTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"服务时长：%@",kString(orderinfo.serviceLength).length==0 ? @"无":orderinfo.serviceLength] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];

    [strserviceTime addAttributes:@{NSForegroundColorAttributeName: kColor(@"C7")} range:NSMakeRange(0, 4)];
    
    self.singOutServiceLengthLab.attributedText = strserviceTime;
    
    // 备注
    NSMutableAttributedString *strRemark = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"备注：%@",kString(orderinfo.serviceResult).length==0 ? @"无":orderinfo.serviceResult] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];

       [strRemark addAttributes:@{NSForegroundColorAttributeName: kColor(@"C7")} range:NSMakeRange(0, 2)];
       self.remarklab.attributedText = strRemark;
    
}

@end
