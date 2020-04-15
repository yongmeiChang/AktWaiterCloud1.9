//
//  AktUserImageVC.h
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/27.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AktUserImageVC : BaseControllerViewController

@property(strong,nonatomic)NSString *strImg; // 头像URL
@property(nonatomic,strong) UIImage * himage; // 更换的图片

@end

NS_ASSUME_NONNULL_END
