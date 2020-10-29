//
//  AktResetAppView.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AktResetAppDelegate <NSObject>
-(void)didNoResetAppClose:(NSInteger)type;

@end
@interface AktResetAppView : UIView
@property(weak,nonatomic)id <AktResetAppDelegate> delegate;
@property(nonatomic,strong) NSString *strContent; // 更新内容
@property(nonatomic) BOOL isUpdate; // **默认非强制更新，可以进行更改。yes强更 No不强更 **

@end

NS_ASSUME_NONNULL_END
