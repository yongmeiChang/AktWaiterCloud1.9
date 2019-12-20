//
//  SignInCell.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/4.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel * titleLabel;//cell标题
@property (weak,nonatomic) IBOutlet UILabel * signInDateLabel;//签入 签出时间
@property (weak,nonatomic) IBOutlet UILabel * signInStatusLabel;//签入 签出状态
@property (weak,nonatomic) IBOutlet UILabel * signInAddressLabel;//签入 签出地点
@property (weak,nonatomic) IBOutlet UILabel * signInDistanceLabel;//签入 签出距离

@property (weak, nonatomic) IBOutlet UILabel *singOutServiceLengthLab; // 服务时长
@property (weak, nonatomic) IBOutlet UILabel *remarklab; // 备注

@property (weak,nonatomic) IBOutlet UIImageView * photoview;//签入签出右侧的图片按钮

-(void)setSignInInfo:(OrderInfo *)orderinfo; // 签入情况

-(void)setSignOutInfo:(OrderInfo *)orderinfo; // 签出情况


@end
