//
//  SettingsTableViewCell.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/10.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell
@property(weak,nonatomic) IBOutlet UILabel * titleLabel;
@property(weak,nonatomic) IBOutlet UIImageView * headImageView;
@property (weak, nonatomic) IBOutlet UILabel *labserviceCode;

-(void)setuserSetInfo:(NSArray *)ary Index:(NSIndexPath *)index;
@end
