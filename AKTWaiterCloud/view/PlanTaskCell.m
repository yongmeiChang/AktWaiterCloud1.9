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
-(void)setOrderList:(OrderInfo *)orderinfo  Type:(NSInteger)type{
    NSString * itemName = orderinfo.serviceItemName;
    itemName = [itemName stringByReplacingOccurrencesOfString:@"->" withString:@"  >  "];//▶
    
//    self.itemNameH.constant = [AktUtil getNewTextSize:itemName font:14 limitWidth:(SCREEN_WIDTH-30)].height+14; // 项目名称的高度
    [self.namelabel setText:orderinfo.customerName]; // 姓名
    
    aryPhone = [[NSArray alloc] init];
    aryPhone = [orderinfo.customerPhone componentsSeparatedByString:@","];
    
    for (int i =0; i<aryPhone.count; i++) {// 手机号
        NSInteger btnw = [AktUtil getNewTextSize:[NSString stringWithFormat:@"%@",[aryPhone objectAtIndex:i]] font:15 limitWidth:0].width;
        UIButton *btnPhone = [[UIButton alloc] initWithFrame:CGRectMake((btnw)*i, 0, btnw, 20)];
        [btnPhone addTarget:self action:@selector(btnPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        btnPhone.tag = i;
        [self.viewPhone addSubview:btnPhone];
        
        UILabel *labPhone = [[UILabel alloc] initWithFrame:CGRectMake((btnw)*i, 0, btnw, 20)];
        labPhone.textColor = kColor(@"C7");
        labPhone.font = [UIFont systemFontOfSize:14];
        labPhone.textAlignment = NSTextAlignmentLeft;
        labPhone.text = [NSString stringWithFormat:@"%@",kString([aryPhone objectAtIndex:i])];
        [self.viewPhone addSubview:labPhone];

    }
    
//    NSString * serviceBeg = [kString(orderinfo.serviceBegin) substringToIndex:16];
//    NSString * serviceEn = [kString(orderinfo.serviceEnd) substringToIndex:16];
    self.datelabel.text = [NSString stringWithFormat:@"%@——%@",kString(orderinfo.serviceBegin),kString(orderinfo.serviceEnd)]; // 开始 结束时间
    self.workNolabel.text = [NSString stringWithFormat:@"%@",orderinfo.workNo];// 工单号

    self.titlelabel.text = itemName; // 服务项目名称
    NSString *strContent = [NSString stringWithFormat:@"%@", orderinfo.serviceContent]; // 服务内容
    if(type == 2){
        self.contentBottom.constant = 8;
        self.contentTitle.text = @"服务内容:";
        if (strContent.length>0) {
            self.contentLabel.text = strContent;
        }else{
            self.contentLabel.text = @"未填写";
        }
    }else{
        self.contentBottom.constant = 0;
    }
    if([orderinfo.workStatus isEqualToString:@"1"]){
        self.bgimageview.image = [UIImage imageNamed:@"undo"];
    }else if([orderinfo.workStatus isEqualToString:@"2"]){
        self.bgimageview.image = [UIImage imageNamed:@"doing"];
    }else {
        self.bgimageview.image = [UIImage imageNamed:@"finish"];
    }
    
    self.addresslabel.text = orderinfo.serviceAddress; // 服务地址
    
    self.dateLab.text = [NSString stringWithFormat:@"(有效期:%@——%@)",kString(orderinfo.serviceDate),kString(orderinfo.serviceDateEnd)];
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
