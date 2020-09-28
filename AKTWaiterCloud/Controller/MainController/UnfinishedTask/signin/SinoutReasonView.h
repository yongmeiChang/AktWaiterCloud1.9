//
//  SinoutReasonView.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/31.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SinoutreasonDelegate <NSObject>
-(void)didselectAction:(UIButton *)sender textviewInfo:(NSString *)info;
@end

@interface SinoutReasonView : UIView<UITextViewDelegate>
{
    NSString *strReasoninfo; // 填写原因
}
@property(nonatomic,assign)id<SinoutreasonDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
