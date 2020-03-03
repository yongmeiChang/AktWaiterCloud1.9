//
//  PlanTaskCell.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/27.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "PlanTaskCell.h"
@implementation PlanTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)continuityLocationBtn:(id)sender{
    self.continuityLocation(sender);
}
#pragma mark - 任务列表
-(void)setOrderList:(OrderInfo *)orderinfo{
    
    [self.namelabel setText:orderinfo.customerName]; // 姓名
    
    aryPhone = [[NSArray alloc] init];
    aryPhone = [orderinfo.customerPhone componentsSeparatedByString:@","];
    
    for (int i =0; i<aryPhone.count; i++) {// 手机号
        UIButton *btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(100*i, 0, 100, 20)];
        [btnPhone addTarget:self action:@selector(btnPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnPhone setTitle:[aryPhone objectAtIndex:i] forState:UIControlStateNormal];
        [btnPhone setTitleColor:kColor(@"C7") forState:UIControlStateNormal];
        btnPhone.titleLabel.font = [UIFont systemFontOfSize:14];
        btnPhone.tag = i;
        [self.viewPhone addSubview:btnPhone];
    }
    
    NSString * serviceBeg = [orderinfo.serviceBegin substringToIndex:16];
    NSString * serviceEn = [orderinfo.serviceEnd substringToIndex:16];
    self.datelabel.text = [NSString stringWithFormat:@"%@ —— %@",serviceBeg,serviceEn]; // 开始 结束时间
    self.workNolabel.text = [NSString stringWithFormat:@"%@",orderinfo.workNo];// 工单号
    NSString * itemName = orderinfo.serviceItemName;
    itemName = [itemName stringByReplacingOccurrencesOfString:@"->" withString:@"  >  "];//▶
    self.titlelabel.text = itemName; // 服务项目名称
    if([orderinfo.workStatus isEqualToString:@"3"]||[orderinfo.workStatus isEqualToString:@"7"]){
        self.bgimageview.image = [UIImage imageNamed:@"undo"];
    }else if([orderinfo.workStatus isEqualToString:@"4"]){
        self.bgimageview.image = [UIImage imageNamed:@"doing"];
    }else if([orderinfo.workStatus isEqualToString:@"6"]){
        self.bgimageview.image = [UIImage imageNamed:@"finish"];
    }else if([orderinfo.workStatus isEqualToString:@"11"]){
        self.bgimageview.image = [UIImage imageNamed:@"editorder"];
    }
    self.addresslabel.text = orderinfo.serviceAddress; // 服务地址
           
}

#pragma mark - click
-(void)btnPhoneClick:(UIButton *)sender{
    NSString *phone = [aryPhone objectAtIndex:sender.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectPhonecomster:)]) {
        [_delegate didSelectPhonecomster:phone];
    }
}

- (IBAction)btnAddressClickMap:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAddressMap)]) {
        [_delegate didSelectAddressMap];
    }
}

@end
