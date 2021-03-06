//
//  SettingsTableViewCell.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/10.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setFrame:(CGRect)frame{
//    frame.origin.y += 10;
//    frame.size.height -= 10;  
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setuserSetInfo:(NSArray *)ary Index:(NSIndexPath *)index CacheSize:(NSString *)cache{
    self.titleLabel.text = [ary objectAtIndex:index.row];
    switch (index.row) {
        case 0:
            {
                self.headImageView.image = [UIImage imageNamed:@"password.png"];
            }
            break;
        case 1:
        {
            self.headImageView.image = [UIImage imageNamed:@"clean.png"];
//            self.accessoryType = UITableViewCellAccessoryNone;
//            self.labserviceCode.hidden = NO;
//            self.labserviceCode.text = [NSString stringWithFormat:@"%@MB",cache];
        }
            break;
        case 2:{
            self.headImageView.image = [UIImage imageNamed:@"seiviceCode"];
            self.accessoryType = UITableViewCellAccessoryNone;
            self.labserviceCode.hidden = NO;
            self.labserviceCode.text = [NSString stringWithFormat:@"V%@",[AktUtil GetAppVersion]];
        }
            break;
            case 3:
             self.headImageView.image = [UIImage imageNamed:@"aboutus.png"];
            break;
            case 4:
            self.headImageView.image = [UIImage imageNamed:@"feedback.png"];
            break;
        default:
            break;
    }
}
@end
