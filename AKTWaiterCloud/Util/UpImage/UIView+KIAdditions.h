//
//  UIView+KIView.h
//  Kitalker
//
//  Created by 杨 烽 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (KIAdditions)

@property (nonatomic, assign) id userInfo;

- (void)setUserInfo:(id)userInfo ;

- (id)userInfo;


/*size*/
- (CGSize)size;
- (void)setSize:(CGSize)size;

/*x*/
- (CGFloat)x;
- (void)setOriginX:(CGFloat)x;

/*y*/
- (CGFloat)y;
- (void)setOriginY:(CGFloat)y;

- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;

/*width*/
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

/*height*/
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;



//水平居中对齐 view：相对view padding：间距
- (void)horizontAllignment:(UIView *)view;
//垂直居中对齐 view：相对view padding：间距
- (void)verticalAllignment:(UIView *)view;
//位于view右边，间距为padding (y值一样)
- (void)rightView:(UIView *)view padding:(CGFloat)padding;
//位于view下面，间距为padding
- (void)underView:(UIView *)view padding:(CGFloat)padding;



/*快照*/
- (UIImage *)snapshot;

- (void)registEndEditing;

- (UIActivityIndicatorView *)activityIndicatorView;
- (void)removeActivityView;

- (UIViewController *)viewController;

/*返回view的viewController*/
- (UIViewController *)findViewControllerByView:(UIView *)view;


- (void)pushView:(UIView *)view completion:(void (^)(BOOL finished))completion;

- (void)popCompletion:(void (^)(BOOL finished))completion;



@end
