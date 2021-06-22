//
//  AktUserImageVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/27.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktUserImageVC.h"

@interface AktUserImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imgUserView; // 显示图片
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


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
    if (self.himage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chageUserImage" object:nil userInfo:@{@"userImage":self.himage}];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SearchBarClick{
    [self headBtnClick];
}

#pragma mark - 更换头像
-(void)headBtnClick{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      // 未完成照相功能
        [self takePhoto];
        }];
    
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imagePickerPhotosLibrary];
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc = [[UIImagePickerController alloc]init];
        self.imagePickerVc.allowsEditing = YES;
        self.imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera; // 暂时使用相册
        self.imagePickerVc.delegate = self;
        self.imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    }else{
        [[AppDelegate sharedDelegate] showAlertView:@"无法使用相机" des:@"请在iPhone的""设置-隐私-相机""中允许访问相机" cancel:@"确定" action:@"" acHandle:nil];
    }
}
#pragma mark - 保存图片
//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}
#pragma mark - imagepicker delagete
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage * rimage = [info objectForKey:UIImagePickerControllerOriginalImage]; //UIImagePickerControllerEditedImage 编辑的图片   UIImagePickerControllerOriginalImage 原图
    if ([type isEqualToString:@"public.image"]) {
        self.himage = rimage;
        [imgUserView setImage:rimage];
    }
    if ([picker sourceType] == 1) {// type：1 拍照 0 相册
        UIImageWriteToSavedPhotosAlbum(rimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil); // 照片存储到相册
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 相册
-(void)imagePickerPhotosLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerVc = [[UIImagePickerController alloc]init];
        self.imagePickerVc.allowsEditing = YES;
        self.imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 暂时使用相册
        self.imagePickerVc.delegate = self;
        self.imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    }else{
        [[AppDelegate sharedDelegate] showAlertView:@"无法使用相册" des:@"请在iPhone的""设置-隐私-相机""中允许访问相册" cancel:@"确定" action:@"" acHandle:nil];
    }
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
