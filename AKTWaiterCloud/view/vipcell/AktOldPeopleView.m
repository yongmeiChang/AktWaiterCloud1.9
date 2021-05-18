//
//  AktOldPeopleView.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/5/18.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import "AktOldPeopleView.h"

@interface AktOldPeopleView ()
{
    UIView *Wbg; // 白色背景
    UILabel *labTilte;// 标题
    UILabel *labLine;
    UIButton *btnReset; // 图片
    UIButton *btnClose; // 关闭
    UILabel *labLinev;
}
@end

@implementation AktOldPeopleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setInitView];
    }
    return self;
}

-(void)setInitView{
    
    UIView *alView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alView.backgroundColor = kColor(@"C4");
    alView.alpha = 0.6;
    [self addSubview:alView];
  
    // 白色 背景
    Wbg = [[UIView alloc] init];
    Wbg.backgroundColor = kColor(@"C3");
    [self addSubview:Wbg];
    Wbg.layer.masksToBounds = YES;
    Wbg.layer.cornerRadius = 5;
    [Wbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(285);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self);
    }];
    
    labTilte = [[UILabel alloc] init];
    labTilte.text = @"提示";
    labTilte.font = [UIFont systemFontOfSize:17];
    labTilte.textColor = kColor(@"C1");
    labTilte.textAlignment = NSTextAlignmentCenter;
    [Wbg addSubview:labTilte];
    [labTilte mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(17);
    }];
    
    labLine = [[UILabel alloc] init];
    labLine.backgroundColor = kColor(@"C12");
    [Wbg addSubview:labLine];
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTilte.mas_bottom).mas_offset(20.5);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(Wbg);
    }];
    
    // 图片
    btnReset = [[UIButton alloc] init];
    [btnReset setImage:[UIImage imageNamed:@"oldPeople_No"] forState:UIControlStateNormal];
    [Wbg addSubview:btnReset];
    [btnReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labLine.mas_top).mas_offset(12);
        make.left.right.mas_equalTo(Wbg);
        make.height.mas_equalTo(86);
    }];
    
    
    labLinev = [[UILabel alloc] init];
    labLinev.textColor = kColor(@"C18");
    labLinev.text = @"当前功能开发中";
    labLinev.font = [UIFont systemFontOfSize:14];
    labLinev.textAlignment = NSTextAlignmentCenter;
    [Wbg addSubview:labLinev];
    [labLinev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnReset.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(18);
        make.left.right.mas_equalTo(Wbg);
    }];
    
    // 按钮
    btnClose = [[UIButton alloc] init];
    [btnClose addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleColor:kColor(@"C3") forState:UIControlStateNormal];
    [btnClose setTitle:@"知道了" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    btnClose.tag = 1;
    [Wbg addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(labLinev.mas_bottom).offset(8);
        make.bottom.mas_equalTo(Wbg.mas_bottom).mas_offset(-15);
    }];
    
}

#pragma mark - btn click
-(void)btnCloseViewClick:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(didOldInfoCancelAppClose:)]) {
        [_delegate didOldInfoCancelAppClose:sender.tag];
    }
}


@end
