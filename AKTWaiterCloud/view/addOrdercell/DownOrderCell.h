//
//  DownOrderCell.h
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/6.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownOrderCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel * leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *labValue;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UILabel *labLine;

-(void)setOrderInfo:(NSIndexPath *)path; // 添加工单

@end
