//
//  AktServiceRemarkCell.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/17.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AktServiceRemarkCellDelegate <NSObject>
-(void)remarkChangeDelegateText:(NSString *)remak;
-(void)didPostInfo; // 提交
@end

@interface AktServiceRemarkCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tvRemark;
@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (weak, nonatomic) id<AktServiceRemarkCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
