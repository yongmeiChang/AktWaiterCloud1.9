//
//  AKTSearchInfoVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/9/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AktSearchDelegate <NSObject>
-(void)searchKey:(NSString *)search SearchAddress:(NSString *)address Searchtime:(NSString *)searchtime SearchOrder:(NSString *)orderid Sender:(NSInteger)sender;
@end

@interface AKTSearchInfoVC : WorkBaseViewController
@property (weak, nonatomic) id<AktSearchDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
