//
//  AktTitleCell.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/10.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktTitleCell.h"

@implementation AktTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageValue.layer.masksToBounds = YES;
    self.imageValue.layer.cornerRadius = self.imageValue.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - user info
-(void)setUserInfoDetails:(UserInfo *)userInfo indexPath:(NSIndexPath *)indexpath IconImage:(UIImage *)iconIamge{
    self.labvalue.hidden = NO;
    self.imageValue.hidden = YES;
    switch (indexpath.row) {
        case 0:{
            self.labName.text = @"头像";
            self.labvalue.hidden = YES;
            self.imageValue.hidden = NO;

               if (iconIamge) {
                  [self.imageValue setImage:iconIamge];
               }else{
                   if ([kString(userInfo.icon) containsString:@"http"] && kString(userInfo.icon).length>5) {
                       self.imageValue.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userInfo.icon]]]];
                   }
               }
         }
            break;
        case 1:{
            self.labName.text = @"姓名";
            self.labvalue.text = kString(userInfo.waiterName);
            self.accessoryType = UITableViewCellAccessoryNone;
            self.labValueConstraint.constant = 43.5;
        }
            break;
        case 2:{
          
            self.labName.text = @"性别";
            self.labvalue.text = kString(userInfo.sexName);
        }
            break;
        case 3:{
            self.accessoryType = UITableViewCellAccessoryNone;
            self.labValueConstraint.constant = 43.5;
            self.labName.text = @"唯一码";
            self.labvalue.text = kString(userInfo.waiterUkey); 
        }
            break;
        case 4:{
            self.accessoryType = UITableViewCellAccessoryNone;
            self.labValueConstraint.constant = 43.5;
            self.labName.text = @"手机号";
            self.labvalue.text = kString(userInfo.mobile);
        }
            break;
        default:
            break;
    }
}

@end
