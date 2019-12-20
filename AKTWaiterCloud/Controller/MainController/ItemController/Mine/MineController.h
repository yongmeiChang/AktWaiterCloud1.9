//
//  MineController.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/10/9.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineController : BaseControllerViewController
@property(weak,nonatomic) IBOutlet UIImageView * headImageView;//头像
@property(nonatomic,strong) UIImage * headimage;//用来接收编辑页面更改头像成功后的头像，刷新当前页面的头像
@end
