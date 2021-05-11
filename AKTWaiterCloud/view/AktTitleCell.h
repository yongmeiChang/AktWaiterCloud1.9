//
//  AktTitleCell.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/10.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AktOldPeoplePhoneDelegate <NSObject>
-(void)didSelectCallPhone:(NSString *)phone;

@end

@interface AktTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labvalue;
@property (weak, nonatomic) IBOutlet UIImageView *imageValue;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labValueConstraint;
@property(weak,nonatomic)id <AktOldPeoplePhoneDelegate> delegate;

-(void)setUserInfoDetails:(UserInfo *)userInfo indexPath:(NSIndexPath *)indexpath IconImage:(UIImage *)iconIamge;
-(void)setOldpeopleCallPhone:(NSString *)phone oldName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
