//
//  KIImagesPickerViewController.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/14.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol KIImagesPickerViewControllerDelegate;


@interface KIImagesPickerViewController : NSObject


- (id)initWithDelegate:(id<KIImagesPickerViewControllerDelegate>)delegate
        viewController:(UIViewController *)viewController;

- (void)show;

@end




@protocol KIImagesPickerViewControllerDelegate <NSObject>



@optional

- (void)imagesPickerControllerDidCancle:(KIImagesPickerViewController *)imagesPickerController;

- (void)imagesPickerController:(KIImagesPickerViewController *)imagesPickerController didPickedImage:(UIImage *)didPickedImage;

- (void)imagesPickerController:(KIImagesPickerViewController *)imagesPickerController didPickedImages:(NSArray *)didPickedImages;

@end