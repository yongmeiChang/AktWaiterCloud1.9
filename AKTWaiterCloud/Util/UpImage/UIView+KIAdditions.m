//
//  UIView+KIView.m
//  Kitalker
//
//  Created by 杨 烽 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+KIAdditions.h"
#import <objc/runtime.h>

NSString * const kViewUserInfo = @"kAlertViewUserInfo";

#define kActivityViewTag 1010110

@implementation UIView (KIAdditions)

@dynamic userInfo;

- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, (__bridge const void *)(kViewUserInfo), userInfo, OBJC_ASSOCIATION_ASSIGN);
}

- (id)userInfo {
    return objc_getAssociatedObject(self, (__bridge const void *)(kViewUserInfo));
}

- (CGSize)size {
    return self.bounds.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)x{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(CGFloat)y{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



/*--设置相对位置--*/

//水平居中对齐 view：相对view padding：间距
- (void)horizontAllignment:(UIView *)view{
    CGRect superRect = view.frame;
    
    CGRect rect = self.frame;
    
    CGRect currRect = CGRectMake(rect.origin.x,
                                 (superRect.size.height - rect.size.height)/2 + superRect.origin.y,
                                 rect.size.width,
                                 rect.size.height);
    self.frame = currRect;
    
}

//垂直居中对齐 view：相对view padding：间距
- (void)verticalAllignment:(UIView *)view{
    CGRect superRect = view.frame;
    
    CGRect rect = self.frame;
    
    CGRect currRect = CGRectMake((superRect.size.width - rect.size.width)/2 + superRect.origin.x,
                                 rect.origin.y,
                                 rect.size.width,
                                 rect.size.height);
    self.frame = currRect;
}

//位于view右边，间距为padding (y值一样)
- (void)rightView:(UIView *)view padding:(CGFloat)padding{
    CGRect superRect = view.frame;
    
    CGRect rect = self.frame;
    
    CGRect currRect = CGRectMake(CGRectGetMaxX(superRect) + padding,
                                 superRect.origin.y,
                                 rect.size.width,
                                 rect.size.height);
    self.frame = currRect;
}

//位于view下面，间距为padding
- (void)underView:(UIView *)view padding:(CGFloat)padding{
    CGRect superRect = view.frame;
    
    CGRect rect = self.frame;
    
    CGRect currRect = CGRectMake(superRect.origin.x,
                                 CGRectGetMaxY(superRect) + padding,
                                 rect.size.width,
                                 rect.size.height);
    self.frame = currRect;
}




- (UIImage *)snapshot {
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    }
//    else {
//        UIGraphicsBeginImageContext(self.bounds.size);
//    }
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)registEndEditing {
    UITapGestureRecognizer *endEditingTapGesture = nil;
    endEditingTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(endEditingTapGestureHandler:)];
    [endEditingTapGesture setCancelsTouchesInView:YES];
    [self addGestureRecognizer:endEditingTapGesture];
    
}

- (void)endEditingTapGestureHandler:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self isKindOfClass:[UITableView class]]) {
            [self.superview endEditing:YES];
        } else {
            [self endEditing:YES];
        }
    }
}


- (UIActivityIndicatorView *)activityIndicatorView {
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag:kActivityViewTag];
    if (activityView == nil) {
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView setTag:kActivityViewTag];
        CGFloat width = 100;
        CGFloat height = 100;
        CGFloat x = (CGRectGetWidth(self.frame) - width) / 2;
        CGFloat y = (CGRectGetHeight(self.frame) - height) / 2;
        [activityView setFrame:CGRectMake(x, y, width, height)];
        activityView.backgroundColor = [UIColor grayColor];
        [self addSubview:activityView];
        [self bringSubviewToFront:activityView];
    }
    
    [activityView startAnimating];
    
    return activityView;
}

- (void)removeActivityView{
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag:kActivityViewTag];
    if (activityView) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
    activityView = nil;
}

- (UIViewController *)viewController {
    return (UIViewController *)[self findViewControllerByView:self];
}

/*返回view的viewController*/
- (UIViewController *)findViewControllerByView:(UIView *)view{
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self findViewControllerByView:nextResponder];
    } else {
        return nil;
    }
}

- (void)pushView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    if (view == self) {
        return ;
    }
    [view setFrame:CGRectMake(CGRectGetWidth(self.bounds),
                              0,
                              CGRectGetWidth(self.bounds),
                              CGRectGetHeight(self.bounds))];
    [self addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        [view setFrame:self.bounds];
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)popCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:CGRectMake(CGRectGetWidth(self.bounds),
                                  0,
                                  CGRectGetWidth(self.bounds),
                                  CGRectGetHeight(self.bounds))];
    } completion:^(BOOL finished) {
        completion(finished);
        [self removeFromSuperview];
    }];
}


@end
