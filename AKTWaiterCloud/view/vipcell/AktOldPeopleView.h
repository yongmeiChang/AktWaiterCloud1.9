//
//  AktOldPeopleView.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/5/18.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AktOldInfoCancelAppDelegate <NSObject>
-(void)didOldInfoCancelAppClose:(NSInteger)type;

@end
@interface AktOldPeopleView : UIView
@property(weak,nonatomic)id <AktOldInfoCancelAppDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
