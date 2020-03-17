//
//  EditUserInfoController.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/18.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "EditUserInfoController.h"
#import <Photos/PHPhotoLibrary.h>
#import "TZImageManager.h"
#import "TZPhotoPreviewController.h"
#import "TZImagePickerController.h"
#import "TZVideoPlayerController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "MineController.h"
#import "AktTitleCell.h"
#import "AktSexView.h"

@interface EditUserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,AktSexSelectDelegate>{
        NSMutableArray *_selectedAssets;//选择的图片
        BOOL _isSelectOriginalPhoto;
    AktSexView*sexView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet UITableView *tableUser;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *nowdate;

@property(nonatomic,strong) UIImage * himage;
@property(nonatomic,strong) NSString * headBaseStr;//图片转base64字符串



@end

@implementation EditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.netWorkErrorView.hidden = YES;
    [self setNavTitle:@"个人信息"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@"保存"];
    
    self.tableUser.delegate = self;
    self.tableUser.dataSource = self;

    // 性别
    sexView=[[AktSexView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_HEIGHT)];
    sexView.tag = 100;
    sexView.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserFmdb * userdb = [[UserFmdb alloc] init];
    appDelegate.userinfo = [userdb findByrow:0];
    NSLog(@"头像----%@",appDelegate.userinfo.icon);
}

#pragma mark - tableview datesouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

////设置分割线上下去边线，顶头缩进15
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableUser respondsToSelector:@selector(setSeparatorInset:)]) {

            [self.tableUser setSeparatorInset:UIEdgeInsetsMake(0, 41.5, 0, 9.5)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"settingscell";
    AktTitleCell *cell = (AktTitleCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AktTitleCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setUserInfoDetails:appDelegate.userinfo indexPath:indexPath IconImage:self.himage];
    return cell;
}
#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self headBtnClick];
    }else if (indexPath.row == 2){
        [[UIApplication sharedApplication].keyWindow addSubview:sexView];
        [sexView selectSexTypeNomal:appDelegate.userinfo];
//        sexView.hidden = NO;
    }
}

#pragma mark - save
-(void)saveClick{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"提交中"];
    _headBaseStr = [self imageToBaseString:self.himage];
 
    NSDictionary * params = @{@"id":kString(appDelegate.userinfo.uuid),@"sex":appDelegate.userinfo.sex,@"iconData":kString(_headBaseStr),@"tenantsId":kString(appDelegate.userinfo.tenantsId)};
    [[AktVipCmd sharedTool] requestedSaveUserInfo:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"object"];
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        self.minecontroller.headimage = self.himage;
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        if ([code integerValue] == 1) {
            appDelegate.userinfo.icon = kString([dic objectForKey:@"icon"]);
            appDelegate.userinfo.sex = [dic objectForKey:@"sex"];
            UserFmdb * userdb = [[UserFmdb alloc] init];
            [userdb updateObject:appDelegate.userinfo];
            [self.tableUser reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
    }];
}

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
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
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
                    [self.tableUser reloadData];
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
    [self.tableUser reloadData];
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


#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    //    NSString * mimeType = @"image/jpeg";
    //    NSString *encodedImageStr = [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,[data base64EncodedStringWithOptions: 0]];
    //NSLog(@"%@",encodedImageStr);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
#pragma mark - nav click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SearchBarClick{
     [self saveClick];
}
#pragma mark - sex delegate
-(void)theSexviewClose{
//    sexView.hidden = YES;
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:100] removeFromSuperview];
}
-(void)theSexviewSureTypeEnd:(NSInteger)type{
//    sexView.hidden = YES;
    [[[UIApplication sharedApplication].keyWindow viewWithTag:100] removeFromSuperview];
    appDelegate.userinfo.sex = [NSString stringWithFormat:@"%ld",(long)type];
    if (type ==0) {
        appDelegate.userinfo.sexName = @"男";
    }else{
        appDelegate.userinfo.sexName = @"女";
    }
    [self.tableUser reloadData];
}

#pragma mark -
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
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}
#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
