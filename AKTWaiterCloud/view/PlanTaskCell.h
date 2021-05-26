//
//  PlanTaskCell.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/13.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlanTaskPhoneDelegate <NSObject>
-(void)didSelectPhonecomster:(NSString *)phone;
-(void)didSelectAddressMap;
@end

typedef void(^ContinuityLocation)(UIButton*);
@interface PlanTaskCell : UITableViewCell{
    NSArray *aryPhone; // 手机号
}
@property(weak,nonatomic) IBOutlet UIImageView * bgimageview;//背景图
@property (weak, nonatomic) IBOutlet UILabel *namelabel;//姓名
@property (weak, nonatomic) IBOutlet UIView *viewPhone; // 电话背景
@property(weak,nonatomic) IBOutlet UILabel * addresslabel;//地址
@property(weak,nonatomic) IBOutlet UILabel * datelabel;//服务日期
@property(weak,nonatomic) IBOutlet UILabel * titlelabel;//服务名称
@property (weak, nonatomic) IBOutlet UILabel *contentTitle; // 服务内容标题
@property (weak, nonatomic) IBOutlet UILabel *contentLabel; // 服务内容
@property(weak,nonatomic) IBOutlet UILabel * workNolabel;//订单号
@property(weak,nonatomic) IBOutlet UIView * bottomView;//底部视图
@property(weak,nonatomic) IBOutlet UIButton * grabSingleBtn;//抢单按钮(默认隐藏)
@property(nonatomic,copy)ContinuityLocation continuityLocation;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab; // 有效期
@property (weak, nonatomic)id<PlanTaskPhoneDelegate>delegate;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemNameH; // 服务项目名称高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottom; // 服务内容底部距离

-(void)setOrderList:(OrderListModel *)orderinfo Type:(NSInteger)type; // 任务列表 2任务详情 1 其他
@end
