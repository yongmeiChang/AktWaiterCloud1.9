//
//  HMAddImagesView.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/12.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "HMAddImagesView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBImagePickerController.h"

#import "UIView+KIAdditions.h"


#define ImageView_tag  500


@interface HMAddImagesView () <QBImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>{
    
}
@property (nonatomic,strong) UIButton *addImageBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger imageIndex; //用于保存图片
@property (nonatomic,assign) NSInteger tempDeleteIndex;

@end



@implementation HMAddImagesView

- (id)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        self.backgroundColor = [UIColor whiteColor];
        _dataArray = [[NSMutableArray alloc]init];
        
        [self initSubviews];
    }
    return self;
}


//
//- (void)reloadWithImages:(NSArray *)images{
//    for (NSDictionary *dict in images) {
//        [_dataArray addObject:dict];
//    }
//
//    [self reloadImages];
//}
//
//- (void)reloadImages{
//
//    NSInteger lineNum = ceil((_dataArray.count + 1)/4.0);
//    [self setHeight:lineNum * 70 + 10];
//
//
//    //删除视图
//    for (UIImageView *imageView in self.subviews) {
//        //UIImageView *view = (UIImageView *)[self viewWithTag:i + ImageView_tag ];
//        if ([imageView isKindOfClass:[UIImageView class]]) {
//
//            [imageView removeFromSuperview];
//        }
//    }
//
//    //视图处理
//    for (int i = 0; i< _dataArray.count; i++){
//        NSDictionary *image = [_dataArray objectAtIndex:i];
//        UIImageView *view = [self addViewWithImage:image frame:[self getImageFrameWithIndex:i]];
//        [self addSubview:view];
//        view.tag = ImageView_tag + i;
//    }
//    _addImageBtn.frame = [self getImageFrameWithIndex:_dataArray.count];
//}


+ (CGFloat)getViewheight:(NSArray *)array{
    NSInteger lineNum = ceil((array.count + 1)/4.0);
    
    return lineNum * 60+10;
}

//注意：在编辑的情况下，部分数据室url，部分是本地路径
- (NSArray *)getImagesArray{
    return _dataArray;
}

- (void)initSubviews{
    
    [self initAddImageBtn];
    
    
}


#pragma mark - 照片添加删除

- (void)initAddImageBtn{
    //width && height = 68
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addImageBtn.frame = [self getImageFrameWithIndex:0];
    [_addImageBtn setBackgroundImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
    [self addSubview:_addImageBtn];
    [_addImageBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (CGRect)getImageFrameWithIndex:(NSInteger)index{
    //大小和间距
    CGFloat button_height          = 60;
    CGFloat button_width           = 60;
    CGFloat button_interval_width  = (SCREEN_WIDTH- 4*button_width) / 5.0f;
    CGFloat button_interval_height = 10;
    
    long _column = index / 4;//行
    long _line   = index % 4;//列
    
    CGRect rect = CGRectMake(button_interval_width + (button_interval_width + button_width) * _line,
                             15 + (button_interval_height + button_height) * _column,
                             button_width, button_height);
    
    return rect;
}

- (UIImageView *)addViewWithImage:(id)imageStr frame:(CGRect)frame{
    
    UIImageView *viewBg = [[UIImageView alloc] init];
    viewBg.frame = CGRectMake(frame.origin.x, frame.origin.y-15, frame.size.width+15, frame.size.height+15);
    viewBg.userInteractionEnabled = YES;
    viewBg.clipsToBounds = NO;
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.frame = CGRectMake(0, 15, frame.size.width, frame.size.height);
    imageview.userInteractionEnabled = YES;
    imageview.clipsToBounds = NO;
    imageview.layer.borderWidth = 1;
    imageview.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if ([imageStr isKindOfClass:[NSDictionary class]]) {
        //[imageview setImageWithURL:[NSURL URLWithString:[imageStr stringValueForKey:@"small_image_url"]] placeholderImage:[UIImage imageNamed:@"default64x300"]];
    }else {
        
        imageview.image = [UIImage imageWithContentsOfFile:imageStr];
    }
    [viewBg addSubview:imageview];
    
    //添加图片右上角删除按钮
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(frame.size.width-10, 5, 20, 20);
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"service_close.png"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(deleteImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.userInteractionEnabled = YES;
    [viewBg addSubview:imageBtn];
    
    //    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteGesture:)];
    //    gesture.delegate = self;
    //    [imageview addGestureRecognizer:gesture];
    
    return viewBg;
}

- (void)deleteImageBtnClick:(UIButton *)button{
    UIImageView *view = (UIImageView *)(button.superview);
    NSInteger _index = view.tag - ImageView_tag;
    
    _tempDeleteIndex = _index;
    
//--- 这个需要自己调整下哦
    [self alertView:[[UIAlertView alloc]init] clickedButtonAtIndex:1];
}



- (void)deleteGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        
        UIImageView *view = (UIImageView *)(gesture.view);
        NSInteger _index = view.tag - ImageView_tag;
        
        _tempDeleteIndex = _index;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
}




#pragma mark - 图片处理

- (void)addBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
        [_delegate addImagesView:self actionType:3 object:nil];
    }
    // 所选图片的张数 9
    if (_dataArray.count >= _countPic) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多可以上传%ld张图片",(long)_countPic] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    UIActionSheet *sheet;  //@"从相册选择", @"从相机拍摄",
    if (_isOnebol) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"拍照", nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"拍照", @"照片图库", nil];
    }
    
    [sheet showInView:[[[UIApplication sharedApplication]delegate]window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 拍照
        [self showCarema];
        
    }else if (buttonIndex == 1){
        // 照片图库
        if (!_isOnebol) {
            [self showImagesPicker];
        }
    }else{
        
    }
}



- (void)addImageWithImageName:(NSString *)imageName imagePath:(NSString *)imagePath{
    
    
    [_dataArray addObject:imagePath];
    
    UIImageView *view = [self addViewWithImage:imagePath frame:[self getImageFrameWithIndex:(_dataArray.count - 1)]];
    [self addSubview:view];
    view.tag = ImageView_tag + _dataArray.count - 1;
    
    //无效，需要调试
    //    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage:)];
    //    gesture.minimumPressDuration = 0.5f;
    //    [view addGestureRecognizer:gesture];
    
    _addImageBtn.frame = [self getImageFrameWithIndex:_dataArray.count];

    if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
        [_delegate addImagesView:self actionType:1 object:nil];
    }
}

- (void)deleteImage:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView = (UIImageView *)gesture.view;
        NSInteger _index = imageView.tag - ImageView_tag;
        _tempDeleteIndex = _index;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除图片?" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 1) {
        NSInteger _index = _tempDeleteIndex;
        
        //删除视图
        for (int i = 0; i< _dataArray.count; i++) {
            UIImageView *view = (UIImageView *)[self viewWithTag:i + ImageView_tag ];
            [view removeFromSuperview];
        }
        
        //数据处理
        [_dataArray removeObjectAtIndex:_index];
        
        //视图处理
        for (int i = 0; i< _dataArray.count; i++){
            
            UIImageView *view = [self addViewWithImage:[_dataArray objectAtIndex:i] frame:[self getImageFrameWithIndex:i]];
            [self addSubview:view];
            view.tag = ImageView_tag + i;
        }
        _addImageBtn.frame = [self getImageFrameWithIndex:_dataArray.count];
        
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
            [_delegate addImagesView:self actionType:2 object:nil];
        }
    }
}

#pragma mark - camara

- (void)showCarema{
    if (TARGET_IPHONE_SIMULATOR) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"模拟器不能使用相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"您没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil, nil);
    
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/certified%ld.jpg", NSHomeDirectory(), (long)_imageIndex++];
    if (tempImage != nil) {
        // 压缩比例 0 - 1
        [UIImageJPEGRepresentation(tempImage, 0.3) writeToFile:path atomically:YES];
        
        [self addImageWithImageName:@"" imagePath:path];
    }
    
    
    [self dismissController];
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissController];
}

- (void)dismissController{
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - QBImagePickerController

- (void)showImagesPicker{
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    // 所选图片的张数 9
    imagePickerController.maximumNumberOfSelection = _countPic - _dataArray.count;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:navigationController animated:YES completion:NULL];
}


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    
    NSArray *assetArr = assets;
    
    for (NSInteger i=0; i<assetArr.count; i++) {
        
        ALAsset *asset = [assetArr objectAtIndex:i];
        
        
        UIImage *tempImage = [HMAddImagesView fullResolutionImageFromALAsset:asset];
        
        NSString *path = [NSString stringWithFormat:@"%@/Documents/certified%ld.jpg", NSHomeDirectory(), (long)_imageIndex++];
        if (tempImage != nil) {
            [UIImageJPEGRepresentation(tempImage, 0.3) writeToFile:path atomically:YES];
            
            [self addImageWithImageName:@"" imagePath:path];
        }
        
    }
    
    [self dismissImagePickerController];
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

- (void)imagesPickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    
    [self dismissImagePickerController];
}

- (void)dismissImagePickerController
{
    if (self.viewController.presentedViewController) {
        [self.viewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.viewController.navigationController popToViewController:self.viewController animated:YES];
    }
}

@end
