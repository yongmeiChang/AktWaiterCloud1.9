//
//  DownOrderCell.m
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/6.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import "DownOrderCell.h"

@implementation DownOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderInfo:(NSIndexPath *)path{
    if (path.row == 0) {
        // 绘制圆角 需设置的圆角 使用"|"来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-20, 53) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7.5, 7.5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        // 设置大小
        maskLayer.frame = self.viewBg.bounds;
        // 设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.viewBg.layer.mask = maskLayer;
        
        self.leftLabel.text = @"服务项目";
    }else if (path.row == 4){
        // 绘制圆角 需设置的圆角 使用"|"来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-20, 53) byRoundingCorners:UIRectCornerBottomLeft |
        UIRectCornerBottomRight cornerRadii:CGSizeMake(7.5, 7.5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        // 设置大小
        maskLayer.frame = self.viewBg.bounds;
        // 设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.viewBg.layer.mask = maskLayer;
        
        self.leftLabel.text = @"结束时间";
        [self.labLine setHidden:YES];
    }else if (path.row == 1){
        self.leftLabel.text = @"开始日期";
    }else if (path.row == 2){
        self.leftLabel.text = @"结束日期";
    }else{
        self.leftLabel.text = @"开始时间";
    }
    
}


#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
