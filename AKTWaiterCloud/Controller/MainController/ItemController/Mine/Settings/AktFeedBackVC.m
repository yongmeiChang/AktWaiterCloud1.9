//
//  AktFeedBackVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/23.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktFeedBackVC.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "PhotoCell.h"
#import <LxGridView.h>
#import <LxGridViewCell.h>
@interface AktFeedBackVC ()<UIScrollViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    UIScrollView *scrollBg; // 背景
    UITextView *tvRemark; // 反馈内容
    UITextField *tfPhone; // 联系方式
    UIView *viewPic; // 上传图片背景view
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}
@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) LxGridView *collectionView;//选取图片按钮界面
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation AktFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"意见反馈";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    self.view.backgroundColor = kColor(@"B1");
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _isSelectOriginalPhoto = NO;
    // 初始化控件
    [self initPageView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView setCollectionViewLayout:_layout];
}

#pragma mark - init
-(void)initPageView{
 
    scrollBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-AktNavAndStatusHight-AktStatusHight-130)];
    scrollBg.delegate = self;
    scrollBg.showsVerticalScrollIndicator = NO;
    scrollBg.backgroundColor = kColor(@"B1");
    [self.viewBg addSubview:scrollBg];
    scrollBg.contentSize = CGSizeMake(SCREEN_WIDTH, 470);
    
      // 添加照片
      viewPic = [[UIView alloc] init];
    viewPic.backgroundColor = kColor(@"C3");
      [scrollBg addSubview:viewPic];
      
      UILabel *labPicTitle = [[UILabel alloc] init];
      labPicTitle.text = @"添加照片";
      labPicTitle.font = [UIFont systemFontOfSize:15];
      labPicTitle.textColor = kColor(@"C1");
     [viewPic addSubview:labPicTitle];
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
       _layout = [[LxGridViewFlowLayout alloc] init];
       _collectionView = [[LxGridView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
       _collectionView.alwaysBounceVertical = YES;
       _collectionView.backgroundColor = [UIColor clearColor];
       _collectionView.dataSource = self;
       _collectionView.delegate = self;
       _collectionView.scrollEnabled = NO;
       _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
       [viewPic addSubview:_collectionView];
       [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    UILabel *labPicNotice = [[UILabel alloc] init];
    labPicNotice.text = @"上传问题截图，不超过3张。";
    labPicNotice.font = [UIFont systemFontOfSize:13];
    labPicNotice.textColor = kColor(@"C16");
    [viewPic addSubview:labPicNotice];
    
    [viewPic mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(10);
         make.height.mas_equalTo(165);
         make.width.mas_equalTo(SCREEN_WIDTH);
     }];
     
     [labPicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(15);
         make.right.mas_equalTo(-15);
         make.top.mas_equalTo(viewPic.mas_top).offset(8);
         make.height.mas_equalTo(20);
     }];
    [labPicNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(viewPic.mas_bottom).offset(-8);
        make.height.mas_equalTo(20);
    }];
    
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH-60)/4, (SCREEN_WIDTH-60)/4);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 10;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 上传图片
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labPicTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo((SCREEN_WIDTH-60)/4);
        make.width.mas_equalTo(SCREEN_WIDTH-30);
    }];

    // 输入内容
      UIView *viewRemark = [[UIView alloc] init];
     viewRemark.backgroundColor = kColor(@"C3");
    [scrollBg addSubview:viewRemark];
    
    UILabel *labRemark = [[UILabel alloc] init];
    labRemark.text = @"反馈内容";
    labRemark.font = [UIFont systemFontOfSize:15];
    labRemark.textColor = kColor(@"C1");
    [viewRemark addSubview:labRemark];
    
    tvRemark = [[UITextView alloc] init];
    tvRemark.font = [UIFont systemFontOfSize:13];
    [viewRemark addSubview:tvRemark];
    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请填写10字以上的问题描述，以便我们更好地帮助您解决问题";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
    [tvRemark addSubview:placeHolderLabel];
    [tvRemark setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
    [viewRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewPic.mas_bottom).offset(10);
        make.height.mas_equalTo(168);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [labRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(viewRemark.mas_top).offset(8);
        make.height.mas_equalTo(20);
    }];
    
    [tvRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(labRemark.mas_bottom).offset(8);
        make.bottom.mas_equalTo(viewRemark.mas_bottom).offset(-20);
    }];
    
      // 输入联系方式
    UIView *viewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 78)];
        [scrollBg addSubview:viewPhone];
     viewPhone.backgroundColor = kColor(@"C3");
    UILabel *labPhonetitle = [[UILabel alloc] init];
    labPhonetitle.text = @"联系方式";
    labPhonetitle.font = [UIFont systemFontOfSize:15];
    labPhonetitle.textColor = kColor(@"C1");
    [viewPhone addSubview:labPhonetitle];
    tfPhone = [[UITextField alloc] init];
    tfPhone.placeholder = @"请填写您的手机号或邮箱，以便我们与您联系";
    tfPhone.font = [UIFont systemFontOfSize:13];
    [viewPhone addSubview:tfPhone];
    
      // 约束
      [viewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(viewRemark.mas_bottom).offset(10);
          make.height.mas_equalTo(78);
          make.width.mas_equalTo(SCREEN_WIDTH);
      }];
    [labPhonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    [tfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labPhonetitle.mas_bottom).offset(8);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
   
}

#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)updateAllInfo:(UIButton *)sender {
    NSLog(@"提交数据");
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"------——count：%lu",(unsigned long)_selectedPhotos.count);
    return _selectedPhotos.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }

    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        if (_selectedPhotos.count <3) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
            [sheet showInView:self.view];
        }else{
            [self showMessageAlertWithController:self title:@"温馨提示" Message:@"图片最多可以上传3张哦~" canelBlock:^{}];
        }
        
    } else {
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 3; // 最多选择图片数量

        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];

        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:4 delegate:self pushPhotoPickerVc:YES]; //  MaxImagesCount 最多选择照片
    // imagePickerVc.navigationBar.translucent = NO;
    // 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.isStatusBarDefault = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
 // 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
     navigationController.interactivePopGestureRecognizer.enabled = YES;
     if (viewController != navigationController.viewControllers[0]) {
     navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
     }
}
 
#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        [[AppDelegate sharedDelegate] showAlertView:@"无法使用相机" des:@"请在iPhone的""设置-隐私-相机""中允许访问相机" cancel:@"取消" action:@"设置" acHandle:^(UIAlertAction *action) {
        }];
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
        [[AppDelegate sharedDelegate] showAlertView:@"无法使用相册" des:@"请在iPhone的""设置-隐私-相册""中允许访问相册" cancel:@"取消" action:@"设置" acHandle:^(UIAlertAction *action) {
               }];
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
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self]; // 最多选择图片
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
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
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

//相册
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
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];

    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [_collectionView reloadData];

}
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

#pragma mark - Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private
// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
    }
}

#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

-(void)dealloc{
    //第一种方法.这里可以移除该控制器下的所有通知
    // 移除当前所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
