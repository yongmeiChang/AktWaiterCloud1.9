//
//  SignInVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/16.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class LoginViewController;
@interface SignInVC : BaseControllerViewController
-(id)initWithSigninWController:(LoginViewController *)logincontoller;
@end

NS_ASSUME_NONNULL_END
