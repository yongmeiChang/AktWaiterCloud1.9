//
//  AktServiceRemarkCell.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/17.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktServiceRemarkCell.h"

@implementation AktServiceRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tvRemark.delegate = self;
    
    // 绘制圆角 需设置的圆角 使用"|"来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewBg.bounds byRoundingCorners:UIRectCornerTopLeft |
    UIRectCornerTopRight cornerRadii:CGSizeMake(7.5, 7.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];

    // 设置大小
    maskLayer.frame = self.viewBg.bounds;

    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.viewBg.layer.mask = maskLayer;
    [self.contentView addSubview:self.viewBg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
     NSLog(@"shouldChangeTextInRange%@",textView.text);
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing%@",textView.text);
    if (_delegate && [_delegate respondsToSelector:@selector(remarkChangeDelegateText:)]) {
        [_delegate remarkChangeDelegateText:textView.text];
    }
    return YES;
}
@end
