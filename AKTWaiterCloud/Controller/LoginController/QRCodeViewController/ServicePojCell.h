//
//  ServicePojCell.h
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/9.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicePojCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property(nonatomic,strong) IBOutlet UILabel * leftlabel;
-(void)setCellInfo:(ServicePojInfo *)cellInfo selectCellInf:(ServicePojInfo *)select IndexPath:(NSIndexPath *)indexpath;
@end
