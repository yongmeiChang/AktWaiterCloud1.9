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

@property(nonatomic,strong) UIImage * himage;
@property(nonatomic,strong) NSString * headBaseStr;//图片转base64字符串



@end

@implementation EditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.netWorkErrorView.hidden = YES;
    self.tableTop.constant = AktNavAndStatusHight;
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
    NSDictionary * params = @{@"waiterId":appDelegate.userinfo.id,@"tenantsId":appDelegate.userinfo.tenantsId,@"images":_headBaseStr};
    [[AFNetWorkingRequest sharedTool] requestupdateWaiterInfo:params type:HttpRequestTypePost success:^(id responseObject) {
        self.minecontroller.headimage = self.himage;
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        [self.tableUser reloadData];
    } failure:^(NSError *error) {
     [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
    }];
     [[AppDelegate sharedDelegate] hidHUD];
}

-(void)headBtnClick{
    __weak typeof(self) weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      // 未完成照相功能
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


#pragma mark - UIImagePickerController
- (void)takePhoto {
    // 无权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
    }
}

//UIImage图片转成Base64字符串
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
#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
