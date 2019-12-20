//
//  PhotoView.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/7/26.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "PhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "PhotoCell.h"
#import "FileManagerUtil.h"
#import <LxGridView.h>
#import <LxGridViewCell.h>
#import "SaveDocumentArray.h"

@interface PhotoView ()
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) LxGridView *collectionView;//选取图片按钮界面
@property (strong, nonatomic) LxGridViewFlowLayout *layout;

@end

@implementation PhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
