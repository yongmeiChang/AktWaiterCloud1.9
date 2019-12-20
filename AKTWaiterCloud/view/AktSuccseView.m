//
//  AktSuccseView.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktSuccseView.h"

@implementation AktSuccseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setInitView];
        return self;
    }else{
        return nil;
    }
}

-(void)setInitView{
    
    UIView *alView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alView.backgroundColor = kColor(@"C4");
    alView.alpha = 0.6;
    [self addSubview:alView];
    // 白色 背景
    UIView *sexbg = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, 155, 270, 320)];
    sexbg.backgroundColor = kColor(@"C3");
    [self addSubview:sexbg];
    sexbg.layer.masksToBounds = YES;
    sexbg.layer.cornerRadius = 5;
    
    UIImageView *imagBg = [[UIImageView alloc] init];
    imagBg.image = [UIImage imageNamed:@"pwd_succse"];
    [sexbg addSubview:imagBg];
    [imagBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.width.mas_equalTo(145);
        make.height.mas_equalTo(90);
        make.centerX.mas_equalTo(sexbg);
    }];
    
    UILabel *labMessage = [[UILabel alloc] init];
    labMessage.text = @"修改成功";
    labMessage.font = [UIFont systemFontOfSize:17];
    labMessage.textColor = kColor(@"C4");
    labMessage.textAlignment = NSTextAlignmentCenter;
    [sexbg addSubview:labMessage];
    [labMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imagBg.mas_bottom).offset(26);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *labSubName = [[UILabel alloc] init];
    labSubName.text = @"您的密码已修改生效，请重新登录";
    labSubName.font = [UIFont systemFontOfSize:14];
    labSubName.textColor = kColor(@"C9");
    labSubName.textAlignment = NSTextAlignmentCenter;
    [sexbg addSubview:labSubName];
    [labSubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labMessage.mas_bottom).offset(17);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *btnLoginReset = [[UIButton alloc] init];
    [btnLoginReset setTitle:@"登 录" forState:UIControlStateNormal];
    [btnLoginReset setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    btnLoginReset.titleLabel.font = [UIFont systemFontOfSize:16];
    btnLoginReset.titleLabel.textColor = kColor(@"C3");
    [btnLoginReset addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [sexbg addSubview:btnLoginReset];
    [btnLoginReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labSubName.mas_bottom).offset(20);
        make.height.mas_equalTo(71);
        make.left.mas_equalTo(5.5);
        make.right.mas_equalTo(3);
    }];
    
    // 关闭按钮
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 00, 0, 0)];
    [btnClose setImage:[UIImage imageNamed:@"view_close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sexbg.mas_bottom).offset(21);
        make.width.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self);
    }];
    
}

#pragma mark - btn click
-(void)btnCloseViewClick:(UIButton *)sender{
   if ([_delegate respondsToSelector:@selector(didSelectClose)]) {
        [_delegate didSelectClose];
    }
}


@end
