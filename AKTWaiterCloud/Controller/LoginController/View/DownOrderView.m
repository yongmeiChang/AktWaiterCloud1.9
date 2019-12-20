//
//  DownOrderView.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "DownOrderView.h"

@implementation DownOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(219, 226, 235);
        /* 添加子控件的代码*/
        _handCodeBtn = [[UIButton alloc] init];
        [self addSubview:_handCodeBtn];
        _sreachBtn = [[UIButton alloc] init];
        [self addSubview:_sreachBtn];
    }
    return self;
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    self.handCodeBtn.frame = CGRectMake(0, 0, 100, 100);
    [self.handCodeBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    [self.handCodeBtn setTintColor:[UIColor blackColor]];
    [self.handCodeBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    self.handCodeBtn.layer.masksToBounds=YES;
    self.handCodeBtn.layer.cornerRadius = 10.0;
    [self.handCodeBtn addTarget:self action:@selector(ClickHandCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.handCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-40);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
    
    self.sreachBtn.frame = CGRectMake(0, 0, 100, 100);
    [self.sreachBtn setTitle:@"查询搜索" forState:UIControlStateNormal];
    [self.sreachBtn setTintColor:[UIColor blackColor]];
    [self.sreachBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    self.sreachBtn.layer.masksToBounds=YES;
    self.sreachBtn.layer.cornerRadius = 10.0;
    [self.sreachBtn addTarget:self action:@selector(ClickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.sreachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.handCodeBtn.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
}

-(void)ClickHandCodeBtn{
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_hdelegate respondsToSelector:@selector(pushHandView)]) {
        [self.hdelegate pushHandView];
    }
}

-(void)ClickSearchBtn{
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_sdelegate respondsToSelector:@selector(pushSearchView)]) {
        [self.sdelegate pushSearchView];
    }
}
@end
