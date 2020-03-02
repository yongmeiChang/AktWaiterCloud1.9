//
//  ZHAttributeTextView.m
//  ZHAttributeTextView
//
//  Created by ZH on 2018/9/18.
//  Copyright © 2018年 张豪. All rights reserved.
//

#import "ZHAttributeTextView.h"

@implementation ZHAttributeTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 左侧是否选中按钮
        self.leftAgreeBtn = [UIButton buttonWithType:0];
//        self.leftAgreeBtn.backgroundColor = [UIColor cyanColor];
        self.leftAgreeBtn.frame = CGRectMake(35, 0, 35, self.bounds.size.height);
        [self.leftAgreeBtn addTarget:self action:@selector(leftAgreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftAgreeBtn setImage:[UIImage imageNamed:@"duihao_normal.png"] forState:UIControlStateNormal];
        [self.leftAgreeBtn setImage:[UIImage imageNamed:@"duihao_select.png"] forState:UIControlStateSelected];
        [self addSubview:self.leftAgreeBtn];

        // 右侧的富文本
        _myTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.leftAgreeBtn.frame.origin.x+self.leftAgreeBtn.frame.size.width, 0, self.bounds.size.width - 35, self.bounds.size.height)];
//        _myTextView.backgroundColor = [UIColor brownColor];
        _myTextView.delegate = self;
        _myTextView.editable = NO;        // 禁止输入，否则会弹出输入键盘
        _myTextView.scrollEnabled = NO;   // 可选的，视具体情况而定
        [self addSubview:_myTextView];
    }
    return self;
    
}
- (void)setTitleTapColor:(UIColor *)titleTapColor{
    // 设置可点击富文本字体颜色
    _myTextView.linkTextAttributes = @{NSForegroundColorAttributeName:titleTapColor};
}
// 字符串内容
- (void)setContent:(NSString *)content{
    _content = content;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
    // 如果有三个点击事件在下面添加
    if (self.numClickEvent == 1) {
        [attStr addAttribute:NSLinkAttributeName value:@"click://" range:NSMakeRange(self.oneClickLeftBeginNum, self.oneTitleLength)];
        [attStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]} range:NSMakeRange(self.oneClickLeftBeginNum, self.oneTitleLength)];
        
    }else if (self.numClickEvent == 2){
        
        [attStr addAttribute:NSLinkAttributeName value:@"click://" range:NSMakeRange(self.oneClickLeftBeginNum, self.oneTitleLength)];
        [attStr addAttribute:NSLinkAttributeName value:@"click1://" range:NSMakeRange(self.twoClickLeftBeginNum, self.twoTitleLength)];
        [attStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]} range:NSMakeRange(self.oneClickLeftBeginNum, self.oneTitleLength)];
        
        [attStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]} range:NSMakeRange(self.twoClickLeftBeginNum, self.twoTitleLength)];
    }
    _myTextView.attributedText = attStr;
    _myTextView.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1.0];
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([[URL scheme] isEqualToString:@"click"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        if (self.eventblock) {
            self.eventblock(abStr);
        }
        return NO;
    }
    if ([[URL scheme] isEqualToString:@"click1"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        if (self.eventblock) {
            self.eventblock(abStr);
        }
        return NO;
    }
    return YES;
}
// 按钮点击事件
- (void)leftAgreeBtnClick:(UIButton *)sender{
    if (self.agreeBtnClick) {
        self.agreeBtnClick(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end