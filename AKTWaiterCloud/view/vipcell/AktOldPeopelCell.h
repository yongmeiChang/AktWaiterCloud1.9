//
//  AktOldPeopelCell.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/5/18.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AktOldPeoplePhoneDelegate <NSObject>
-(void)didSelectCallPhone:(NSString *)phone;

@end

@interface AktOldPeopelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LabName;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnValue;
@property (weak, nonatomic) IBOutlet UILabel *labValue;

@property(weak,nonatomic)id <AktOldPeoplePhoneDelegate> delegate;

-(void)setOldpeopleCallPhone:(NSString *)phone oldName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
