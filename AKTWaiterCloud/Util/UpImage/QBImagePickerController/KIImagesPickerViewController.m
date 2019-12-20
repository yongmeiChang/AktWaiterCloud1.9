//
//  KIImagesPickerViewController.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/14.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "KIImagesPickerViewController.h"
#import "QBImagePickerController.h"

@interface KIImagesPickerViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate> {
    
}
@property (nonatomic, weak) id<KIImagesPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL showDelete;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end



@implementation KIImagesPickerViewController


- (id)initWithDelegate:(id<KIImagesPickerViewControllerDelegate>)delegate
        viewController:(UIViewController *)viewController{
    if (self = [super init]) {
        self.delegate = delegate;
        self.viewController = viewController;
        self.title = @"请选择";
    }
    return self;
}

- (void)show {
    UIApplication *applicaiton = [UIApplication sharedApplication];
    [[self actionSheet:NO] showInView:[applicaiton keyWindow]];
}

- (UIActionSheet *)actionSheet:(BOOL)needDelete {
    self.showDelete = needDelete;
    if (_actionSheet == nil) {
        
        if (TARGET_IPHONE_SIMULATOR) {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", nil];
        }else{
            _actionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", @"从相机拍摄", nil];
        }
        
        NSUInteger cancelIndex = 1;
        if (self.showDelete) {
            [_actionSheet addButtonWithTitle:@"删除图片"];
            cancelIndex++;
        }
        
        [_actionSheet addButtonWithTitle:@"取消"];
        cancelIndex++;
        
        _actionSheet.cancelButtonIndex = cancelIndex;
        
    }
    return _actionSheet;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        [_imagePickerController setDelegate:self];
    }
    return _imagePickerController;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [_viewController presentViewController:navigationController animated:YES completion:NULL];
        
        
    } else if (buttonIndex == 1) {
        [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
        [self imagePickerController].modalPresentationStyle = UIModalPresentationFullScreen;
        [_viewController presentViewController:[self imagePickerController] animated:YES completion:^{
            
        }];
#else
        [_viewController presentModalViewController:[self imagePickerController] animated:YES];
#endif
        
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(imagesPickerControllerDidCancle:)]) {
            [self.delegate imagesPickerControllerDidCancle:self];
        }
        [self dismiss];
    } else {
        [self dismiss];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [_viewController presentViewController:navigationController animated:YES completion:NULL];
        
        
    } else if (buttonIndex == 1) {
        [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
        [self imagePickerController].modalPresentationStyle = UIModalPresentationFullScreen;
        [_viewController presentViewController:[self imagePickerController] animated:YES completion:^{
            
        }];
#else
        [_viewController presentModalViewController:[self imagePickerController] animated:YES];
#endif
        
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(imagesPickerControllerDidCancle:)]) {
            [self.delegate imagesPickerControllerDidCancle:self];
        }
        [self dismiss];
    } else {
        [self dismiss];
    }
}


- (void)pickImage:(UIImage *)image {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(imagesPickerController:didPickedImage:)]) {
        [self.delegate imagesPickerController:self didPickedImage:image];
    }
    [self dismiss];
}

- (void)dismiss {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    [[self imagePickerController] dismissViewControllerAnimated:YES completion:^{
        
    }];
#else
    [[self imagePickerController] dismissModalViewControllerAnimated:YES];
#endif
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //    NSURL   *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    //    NSString *imagePath = [imageURL absoluteString];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self pickImage:image];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.delegate respondsToSelector:@selector(imagesPickerControllerDidCancle:)]) {
        [self.delegate imagesPickerControllerDidCancle:self];
    }
    [self dismiss];
}



#pragma mark -

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
//    NIF_TRACE(@"*** imagePickerController:didSelectAssets:");
//    NIF_TRACE(@"%@", assets);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(imagesPickerController:didPickedImage:)]) {
        [self.delegate imagesPickerController:self didPickedImages:assets];
    }
    
    [self dismissImagePickerController];
}

- (void)imagesPickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    //NIF_TRACE(@"*** imagePickerControllerDidCancel:");
    
    if ([self.delegate respondsToSelector:@selector(imagesPickerControllerDidCancle:)]) {
        [self.delegate imagesPickerControllerDidCancle:self];
    }
    
    [self dismissImagePickerController];
}

- (void)dismissImagePickerController
{
    if (_viewController.presentedViewController) {
        [_viewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [_viewController.navigationController popToViewController:_viewController animated:YES];
    }
}

@end
