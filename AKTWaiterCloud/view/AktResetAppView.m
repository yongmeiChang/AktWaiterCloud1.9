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
    UIView *Wbg; // 白色背景
    UILabel *labTilte;
    UILabel *labSubName; // 更新的内容
    UILabel *labLine;
    UIButton *btnLoginReset; // 忽略按钮
    UIButton *btnClose; // 立即更新按钮
    UILabel *labLinev;
    UIImageView *imagTop;
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
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setInitView];
        _isUpdate = NO;
        _strContent = @"";
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
    
    labTilte = [[UILabel alloc] init];
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
    labSubName.font = [UIFont systemFontOfSize:12];
    labSubName.textColor = kColor(@"C7");
    labSubName.textAlignment = NSTextAlignmentLeft;
    labSubName.numberOfLines = 0;
    [Wbg addSubview:labSubName];

    
    labLine = [[UILabel alloc] init];
    labLine.backgroundColor = kColor(@"C12");
    [Wbg addSubview:labLine];
    
    btnLoginReset = [[UIButton alloc] init];
    [btnLoginReset setTitle:@"忽略" forState:UIControlStateNormal];
    btnLoginReset.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLoginReset setTitleColor:kColor(@"C11") forState:UIControlStateNormal];
    [btnLoginReset addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    btnLoginReset.tag = 0;
    [Wbg addSubview:btnLoginReset];
    
    btnClose = [[UIButton alloc] init];
    [btnClose addTarget:self action:@selector(btnCloseViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitle:@"立即更新" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnClose setTitleColor:kColor(@"C10") forState:UIControlStateNormal];
    btnClose.tag = 1;
    [Wbg addSubview:btnClose];
    
    labLinev = [[UILabel alloc] init];
    labLinev.backgroundColor = kColor(@"C12");
    [Wbg addSubview:labLinev];
    
    // 头部图片
    imagTop = [[UIImageView alloc] init];
    imagTop.image = [UIImage imageNamed:@"reset"];
    [self addSubview:imagTop];
    
}

#pragma mark -
-(void)setIsUpdate:(BOOL)isUpdate
{
    _isUpdate= isUpdate;
    [self initUpdateView:self.strContent Type:self.isUpdate];
}
-(void)setStrContent:(NSString *)strContent{
    _strContent = strContent;
    [self initUpdateView:self.strContent Type:self.isUpdate];
    
}

#pragma mark - 刷新页面
-(void)initUpdateView:(NSString *)details Type:(BOOL)istype{
    CGSize Fsize= [AktUtil getNewTextSize:details font:12 limitWidth:200];
    [Wbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(Fsize.height+180);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self);
    }];
    
    labSubName.text = details;
    [labSubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTilte.mas_bottom).offset(15.5);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
    }];
    
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labSubName.mas_bottom).mas_offset(35.5);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(Wbg);
    }];
    
    if (istype) {
        /**立即更新**/
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labLine.mas_top);
            make.right.mas_equalTo(Wbg.mas_right);
            make.width.mas_equalTo(Wbg.mas_width).multipliedBy(1);
            make.bottom.mas_equalTo(Wbg.mas_bottom);
            make.height.mas_equalTo(47.5);
        }];
        
    }else{
        /**非立即更新**/
        [btnLoginReset mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labLine.mas_top);
            make.left.mas_equalTo(Wbg.mas_left);
            make.width.mas_equalTo(Wbg.mas_width).multipliedBy(0.5);
            make.bottom.mas_equalTo(Wbg.mas_bottom);
            make.height.mas_equalTo(47.5);
        }];
        
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labLine.mas_top);
            make.right.mas_equalTo(Wbg.mas_right);
            make.width.mas_equalTo(Wbg.mas_width).multipliedBy(0.5);
            make.bottom.mas_equalTo(Wbg.mas_bottom);
        }];
    }
    
    [labLinev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labLine.mas_top);
        make.bottom.mas_equalTo(Wbg.mas_bottom);
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(btnClose.mas_left);
    }];
    
    [imagTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Wbg.mas_top).offset(-60);
        make.width.mas_equalTo(217);
        make.height.mas_equalTo(147);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark - btn click
-(void)btnCloseViewClick:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(didNoResetAppClose:)]) {
        [_delegate didNoResetAppClose:sender.tag];
    }
}

@end
