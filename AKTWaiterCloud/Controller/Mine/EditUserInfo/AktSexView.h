//
//  AktSexView.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/11.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AktSexSelectDelegate <NSObject>
-(void)theSexviewClose;
-(void)theSexviewSureTypeEnd:(NSInteger)type; // 0 男生  1 女生
@end

@interface AktSexView : UIView
{
    UIButton *btnMen;
    UIButton *btnWomen;
    NSInteger sextypeIndex; // 选择的性别
}
@property(weak,nonatomic)id <AktSexSelectDelegate> delegate;
-(void)selectSexTypeNomal:(UserInfo *)info;
@end

NS_ASSUME_NONNULL_END
