//
//  AktSuccseView.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AktSuccseDelegate <NSObject>
-(void)didSelectClose;

@end

@interface AktSuccseView : UIView

@property(weak,nonatomic)id <AktSuccseDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
