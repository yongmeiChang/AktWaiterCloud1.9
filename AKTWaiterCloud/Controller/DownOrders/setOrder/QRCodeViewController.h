//
//  QRCodeViewController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/25.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WorkBaseViewController.h"
#import "UnfinishOrderTaskController.h"

@class LoginViewController;
@interface QRCodeViewController : WorkBaseViewController
@property (nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong) LoginViewController * loginController;
@property(nonatomic,strong) UnfinishOrderTaskController * unfinishController;
-(id)initWithQRCode:(BaseControllerViewController *)viewcontroller Type:(NSString *)type;
@end
