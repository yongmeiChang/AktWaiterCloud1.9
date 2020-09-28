//
//  SinoutReasonView.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/31.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "SinoutReasonView.h"

@implementation SinoutReasonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIView];
    }
    return self;
}
-(void)initUIView{
    self.backgroundColor = [UIColor clearColor];
//    self.alpha = 0.6;
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    colorView.backgroundColor = [UIColor blackColor];
    colorView.alpha = 0.6;
    [self addSubview:colorView];
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-220)/2-30, SCREEN_WIDTH, 220)];
    viewBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBg];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    labTitle.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    labTitle.text = @"请填写原因";
    labTitle.textAlignment = NSTextAlignmentCenter;
    [viewBg addSubview:labTitle];
    
    UITextView *tfview = [[UITextView alloc] initWithFrame:CGRectMake(15, labTitle.frame.origin.y+labTitle.frame.size.height+20, viewBg.frame.size.width-30, 44)];
    tfview.delegate = self;
//    [tfview becomeFirstResponder];
    [viewBg addSubview:tfview];
    
    UIButton *btnleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 176, SCREEN_WIDTH/2, 44)];
    [btnleft setTitle:@"确定" forState:UIControlStateNormal];
    [btnleft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    [btnleft addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnleft.tag = 1;
    [viewBg addSubview:btnleft];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 176, SCREEN_WIDTH/2, 44)];
    [btnRight setTitle:@"取消" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnRight.tag = 2;
    [viewBg addSubview:btnRight];
}

#pragma mark - text View
-(void)textViewDidChange:(UITextView *)textView{
    strReasoninfo = textView.text;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    strReasoninfo = textView.text;
    return YES;
}
#pragma mark - UIButton
-(void)btnAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(didselectAction:textviewInfo:)])
        [_delegate didselectAction:sender textviewInfo:strReasoninfo];
}

@end
