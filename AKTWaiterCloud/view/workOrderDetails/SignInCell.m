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
-(void)setSignInInfo:(OrderListModel *)orderinfo{
    self.singOutServiceLengthLab.hidden = YES;
    self.remarklab.hidden = YES;
    // 时间
    if ([orderinfo.isLate integerValue] == 1) {
        self.lateLabel.textColor = kColor(@"C14");
        self.lateLabel.text = @"迟到";
    }else{
        self.lateLabel.textColor = kColor(@"C15");
        self.lateLabel.text = @"正常";
    }
    
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时间：%@",kString(orderinfo.actualBegin).length == 0 ? @"无":orderinfo.actualBegin] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
    [strTime addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInDateLabel.attributedText = strTime;
    // 距离
    NSString *strDistance;
    if (kString(orderinfo.signInDistance).length == 0) {
        strDistance = [NSString stringWithFormat:@"无"];
    }else{
        strDistance = [NSString stringWithFormat:@"%@米",kString(orderinfo.signInDistance)];
    }
    NSMutableAttributedString *strDis = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离：%@",strDistance] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: kColor(@"C1")}];
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

-(void)setSignOutInfo:(OrderListModel *)orderinfo{
    self.singOutServiceLengthLab.hidden = NO;
    self.remarklab.hidden = NO;
    self.titleLabel.text = @"签出情况";
    
    // 时间
    if ([orderinfo.isEarly integerValue] == 1) {
          self.lateLabel.textColor = kColor(@"C14");
          self.lateLabel.text = @"早退";
      }else{
          self.lateLabel.textColor = kColor(@"C15");
          self.lateLabel.text = @"正常";
      }
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时间：%@",kString(orderinfo.actualEnd).length == 0 ? @"无":orderinfo.actualEnd] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName:kColor(@"C1")}];
    [strTime addAttributes:@{NSForegroundColorAttributeName:kColor(@"C7")} range:NSMakeRange(0, 2)];
    self.signInDateLabel.attributedText = strTime;
    // 距离
    NSString *strDistance;
    if (kString(orderinfo.signInDistance).length == 0) {
        strDistance = [NSString stringWithFormat:@"无"];
    }else{
        strDistance = [NSString stringWithFormat:@"%@米",kString(orderinfo.signInDistance)];
    }
    NSMutableAttributedString *strDis = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离：%@",strDistance] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: kColor(@"C1")}];
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
