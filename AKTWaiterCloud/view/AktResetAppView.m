//
//  AktResetAppView.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktResetAppView.h"

@interface AktResetAppView ()
{
    UILabel *labSubName;
}
@end

@implementation AktResetAppView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        return self;
    }else{
        return nil;
    }
}

-(void)setInitView:(NSString *)updateInfo{
    
    UIView *alView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alView.backgroundColor = kColor(@"C4");
    alView.alpha = 0.6;
    [self addSubview:alView];
    
    // 白色 背景
    UIView *Wbg = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-260)/2, 209, 260, 226)];
    Wbg.backgroundColor = kColor(@"C3");
    [self addSubview:Wbg];
    Wbg.layer.masksToBounds = YES;
    Wbg.layer.cornerRadius = 5;
    
    UILabel *labTilte = [[UILabel alloc] init];
    labTilte.text = @"发现新版本";
    labTilte.font = [UIFont systemFontOfSize:17];
    labTilte.textColor = kColor(@"C1");
    labTilte.textAlignment = NSTextAlignmentCenter;
    [Wbg addSubview:labTilte];
    [labTilte mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(17);
    }];
    
    labSubName = [[UILabel alloc] init];
    labSubName.text = updateInfo;
    labSubName.font = [UIFont systemFontOfSize:12];
    labSubName.textColor = kColor(@"C7");
    labSubName.textAlignment = NSTextAlignmentLeft;
    labSubName.numberOfLines = 0;
    [Wbg addSubview:labSubName];
    [labSubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTilte.mas_bottom);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
    }];
    
    UILabel *labLine = [[UILabel alloc] init];
    labLine.backgroundColor = kColor(@"C12");
    [Wbg addSubview:labLine];
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labSubName.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(Wbg);
    }];
    
    UIButton *btnLoginReset = [[UIButton alloc] init];
    [btnLoginReset setTitle:@"忽略" forState:UIControlStateNormal];
    btnLoginReset.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLoginReset setTitleColor:kColor(@"C11") forState:UIControlStateNormal];
    [btnLoginReset addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    btnLoginReset.tag = 0;
    [Wbg addSubview:btnLoginReset];
    [btnLoginReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labLine.mas_top);
        make.left.mas_equalTo(Wbg.mas_left);
        make.width.mas_equalTo(Wbg.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(Wbg.mas_bottom);
        make.height.mas_equalTo(47.5);
    }];

    UIButton *btnClose = [[UIButton alloc] init];
    [btnClose addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitle:@"立即更新" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnClose setTitleColor:kColor(@"C10") forState:UIControlStateNormal];
    btnClose.tag = 1;
    [Wbg addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labLine.mas_top);
        make.right.mas_equalTo(Wbg.mas_right);
        make.width.mas_equalTo(Wbg.mas_width).multipliedBy(0.5);
        make.bottom.mas_equalTo(Wbg.mas_bottom);
    }];
    
    UILabel *labLinev = [[UILabel alloc] init];
    labLinev.backgroundColor = kColor(@"C12");
    [Wbg addSubview:labLinev];
    [labLinev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labLine.mas_top);
        make.bottom.mas_equalTo(Wbg.mas_bottom);
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(btnClose.mas_left);
    }];
    
    // 头部图片
    UIImageView *imagTop = [[UIImageView alloc] init];
    imagTop.image = [UIImage imageNamed:@"reset"];
    [self addSubview:imagTop];
    [imagTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(148);
        make.width.mas_equalTo(217);
        make.height.mas_equalTo(147);
        make.centerX.mas_equalTo(self);
    }];
    
}
#pragma mark -
-(void)setStrContent:(NSString *)strContent{
    NSLog(@"-%@",strContent);
    [self setInitView:strContent];
}

#pragma mark - btn click
-(void)btnCloseViewClick:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(didNoResetAppClose:)]) {
        [_delegate didNoResetAppClose:sender.tag];
    }
}

@end
