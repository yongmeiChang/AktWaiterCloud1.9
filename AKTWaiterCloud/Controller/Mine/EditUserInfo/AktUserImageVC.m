//
//  AktUserImageVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/27.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktUserImageVC.h"
#import <Photos/PHPhotoLibrary.h>
#import "TZImageManager.h"
#import "TZPhotoPreviewController.h"
#import "TZImagePickerController.h"
#import "TZVideoPlayerController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"

@interface AktUserImageVC ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedAssets;//选择的图片
    UIImageView *imgUserView; // 显示图片
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *nowdate;


@property(nonatomic,strong) NSString * headBaseStr;//图片转base64字符串

@end

@implementation AktUserImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人头像";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@"user_resetImg.png"];
    
    imgUserView = [[UIImageView alloc] init];
    if (self.himage) {
        imgUserView.image = self.himage;
    }else{
        if ([kString(self.strImg) containsString:@"http"] && kString(self.strImg).length>5) {
            imgUserView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strImg]]]];
        }else{
            UIImageView *imgNormal = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 120, 100, 100)];
            imgNormal.backgroundColor = kColor(@"C8");
            imgNormal.image = [UIImage imageNamed:@"defaultuserhead"];
            [self.view addSubview:imgNormal];
            imgNormal.layer.masksToBounds = YES;
            imgNormal.layer.cornerRadius = 50;
        }
    }
    imgUserView.contentMode = UIViewContentModeScaleAspectFit;
    imgUserView.autoresizesSubviews = YES;
    imgUserView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:imgUserView];
    
    [imgUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT);
        make.center.mas_equalTo(self.view);
    }];
}

#pragma mark - click
-(void)LeftBarClick{
//    _headBaseStr = [self imageToBaseString:self.himage];
    if (self.himage) {
        NSLog(@"1");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chageUserImage" object:nil userInfo:@{@"userImage":self.himage}];
    }else{
        NSLog(@"2");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SearchBarClick{
    [self headBtnClick];
}

#pragma mark - 更换头像
-(void)headBtnClick{
    __weak typeof(self) weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      // 未完成照相功能
        [self takePhoto];
        }];
    
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:weakSelf pushPhotoPickerVc:YES];
          // 五类个性化设置，这些参数都可以不传，此时会走默认设置
//            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowPickingImage = YES;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.allowPickingGif = NO;
            imagePickerVc.allowPickingMultipleVideo = NO;
            imagePickerVc.isStatusBarDefault = NO;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if(photos[0]){
                    weakSelf.himage = photos[0];
                    [imgUserView setImage:photos[0]];
                }
            }];
             imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    UIAlertAction * canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:canelAction];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 调用相机
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
       [self pushImagePickerController];
    }
}
// 调用相机（可以去除）
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        _imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage * rimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage * image = [[UIImage alloc] init];
        if(rimage){
            CGSize sizes;
            float x = 0.f;
            if(rimage.size.height>rimage.size.width){
                if(rimage.size.height>=1080){
                    x = 1080/rimage.size.height;
                    float h = x*rimage.size.height;
                    float y = rimage.size.width*x;
                    sizes = CGSizeMake(y, h);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }else{
                    sizes = CGSizeMake(image.size.width, image.size.height);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }
            }else{
                if(rimage.size.width>=1080){
                    x = 1080/rimage.size.width;
                    float w = x*rimage.size.width;
                    float y = rimage.size.height*x;
                    sizes = CGSizeMake(w, y);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }else{
                    sizes = CGSizeMake(image.size.width, image.size.height);
                    image = [self imageWithImage:rimage scaledToSize:sizes];
                }
            }
        }
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    self.himage = image;
    [imgUserView setImage:image];
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 相册
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        
        UIBarButtonItem *tzBarItem, *BarItem;
        
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
    
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    //    NSString * mimeType = @"image/jpeg";
    //    NSString *encodedImageStr = [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,[data base64EncodedStringWithOptions: 0]];
    //NSLog(@"%@",encodedImageStr);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
