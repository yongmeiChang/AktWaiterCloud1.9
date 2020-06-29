//
//  AktSexView.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/11.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktSexView.h"


@implementation AktSexView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setInitViewSex];
        return self;
    }else{
        return nil;
    }
}

-(void)setInitViewSex{
    UIView *alView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alView.backgroundColor = kColor(@"C4");
    alView.alpha = 0.6;
    [self addSubview:alView];
    // 白色 背景
    UIView *sexbg = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, 155, 270, 273)];
    sexbg.backgroundColor = kColor(@"C3");
    [self addSubview:sexbg];
    sexbg.layer.masksToBounds = YES;
    sexbg.layer.cornerRadius = 5;
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sexbg.frame.size.width, 58)];
    labTitle.text = @"选择性别";
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:16];
    [sexbg addSubview:labTitle];
    
    UILabel *labLine = [[UILabel alloc] initWithFrame:CGRectMake(0, labTitle.frame.origin.y+labTitle.frame.size.height, SCREEN_WIDTH, 1)];
    [labLine setBackgroundColor:kColor(@"C5")];
    [sexbg addSubview:labLine];
    
    // men
    btnMen = [[UIButton alloc] initWithFrame:CGRectMake(64.5, (labLine.frame.origin.y+labLine.frame.size.height)+30, 50, 50)];
    [btnMen addTarget:self action:@selector(btnSelectSex:) forControlEvents:UIControlEventTouchUpInside];
    btnMen.tag = 0;
    [btnMen setBackgroundColor:kColor(@"B1")];
    [btnMen setImage:[UIImage imageNamed:@"men"] forState:UIControlStateNormal];
    [btnMen setImage:[UIImage imageNamed:@"men_select"] forState:UIControlStateSelected];
    [sexbg addSubview:btnMen];
    btnMen.layer.masksToBounds = YES;
    btnMen.layer.cornerRadius = btnMen.frame.size.width/2;
    
    UILabel *labMen = [[UILabel alloc] initWithFrame:CGRectMake(64.5, (btnMen.frame.origin.y+btnMen.frame.size.height), 50, 20)];
    labMen.text = @"男";
    labMen.font = [UIFont systemFontOfSize:16];
    labMen.textAlignment = NSTextAlignmentCenter;
    [sexbg addSubview:labMen];
    
    // women
     btnWomen = [[UIButton alloc] initWithFrame:CGRectMake(156.5, (labLine.frame.origin.y+labLine.frame.size.height)+30, 50, 50)];
     [btnWomen addTarget:self action:@selector(btnSelectSex:) forControlEvents:UIControlEventTouchUpInside];
     btnWomen.tag = 1;
     [btnWomen setBackgroundColor:kColor(@"B1")];
     [btnWomen setImage:[UIImage imageNamed:@"women"] forState:UIControlStateNormal];
     [btnWomen setImage:[UIImage imageNamed:@"women_select"] forState:UIControlStateSelected];
     [sexbg addSubview:btnWomen];
    btnWomen.layer.masksToBounds = YES;
    btnWomen.layer.cornerRadius = btnWomen.frame.size.width/2;
     
     UILabel *labWomen = [[UILabel alloc] initWithFrame:CGRectMake(156.5, (btnWomen.frame.origin.y+btnWomen.frame.size.height), 50, 20)];
     labWomen.text = @"女";
     labWomen.font = [UIFont systemFontOfSize:16];
     labWomen.textAlignment = NSTextAlignmentCenter;
     [sexbg addSubview:labWomen];
    
    // sure
    UIButton *btnSure = [[UIButton alloc] initWithFrame:CGRectMake(5, sexbg.frame.size.height-90, sexbg.frame.size.width-10, 71)];
    [btnSure setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [btnSure addTarget:self action:@selector(btnSureSexType:) forControlEvents:UIControlEventTouchUpInside];
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    btnSure.titleEdgeInsets = UIEdgeInsetsMake(0, -(sexbg.frame.size.width-10), 0, 0);
    [btnSure setTitleColor:kColor(@"C3") forState:UIControlStateNormal];
    [sexbg addSubview:btnSure];
    
    // 关闭
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-30)/2, sexbg.frame.origin.y+sexbg.frame.size.height+20, 30, 30)];
    [btnClose addTarget:self action:@selector(btnCloseView) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self addSubview:btnClose];
    
}
-(void)selectSexTypeNomal:(UserInfo *)info{
    NSLog(@"%@",info.sex);
    if ([info.sex integerValue] == 0) {
        btnMen.selected = YES;
        btnWomen.selected = NO;
        btnMen.backgroundColor = kColor(@"C6");
        btnWomen.backgroundColor = kColor(@"B1");
    }else{
        btnMen.selected = NO;
        btnWomen.selected = YES;
        btnMen.backgroundColor = kColor(@"B1");
        btnWomen.backgroundColor = kColor(@"C6");
    }
    sextypeIndex = [info.sex integerValue];
}
#pragma mark - click
-(void)btnCloseView{
    if ([_delegate respondsToSelector:@selector(theSexviewClose)]) {
        [_delegate theSexviewClose];
    }
}
-(void)btnSelectSex:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.tag ==0) {
         btnMen.selected = sender.selected;
        btnWomen.selected = !sender.selected;
        if (sender.selected) {
                  [btnMen setBackgroundColor:kColor(@"C6")];
                  [btnWomen setBackgroundColor:kColor(@"B1")];
              }else{
                  [btnMen setBackgroundColor:kColor(@"B1")];
                  [btnWomen setBackgroundColor:kColor(@"C6")];
              }
    }else{
        btnWomen.selected = sender.selected;
        btnMen.selected = !sender.selected;
        if (sender.selected) {
                  [btnMen setBackgroundColor:kColor(@"B1")];
                  [btnWomen setBackgroundColor:kColor(@"C6")];
              }else{
                  [btnMen setBackgroundColor:kColor(@"C6")];
                  [btnWomen setBackgroundColor:kColor(@"B1")];
              }
    }
    
    sextypeIndex = sender.tag;
}
-(void)btnSureSexType:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(theSexviewSureTypeEnd:)]) {
        [_delegate theSexviewSureTypeEnd:sextypeIndex];
    }
}

@end
