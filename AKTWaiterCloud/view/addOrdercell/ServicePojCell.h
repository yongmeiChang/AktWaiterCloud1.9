//
//  ServicePojCell.h
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/9.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AktServiceStationDelegate <NSObject>

-(void)didSelectStationClick:(NSInteger)path;

@end

@interface ServicePojCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property(nonatomic,strong) IBOutlet UILabel * leftlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;

@property (weak, nonatomic)id<AktServiceStationDelegate>delegate;

-(void)setCellInfo:(ServicePojInfo *)cellInfo selectCellInf:(ServicePojInfo *)select IndexPath:(NSIndexPath *)indexpath;

-(void)setSigninDetailsCellInfo:(SigninDetailsInfo *)cellInfo selectCellInfo:(SigninDetailsInfo *)select; // 选择租户

-(void)setStationCellInfo:(ServiceStationInfo *)cellInfo selectCellInf:(ServiceStationInfo *)select IndexPath:(NSIndexPath *)indexpath; // 选择服务站点

@end
