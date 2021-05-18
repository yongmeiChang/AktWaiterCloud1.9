//
//  AktOldPersonDetailsVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/4/25.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import "AktOldPersonDetailsVC.h"
#import "AktOldPeopleView.h"

@interface AktOldPersonDetailsVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AktOldInfoCancelAppDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labIDCard;
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (weak, nonatomic) IBOutlet UIImageView *imgClick;
@property (weak, nonatomic) IBOutlet UIButton *btnFace;
@property (weak, nonatomic) IBOutlet UIView *peopleBgView;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;

@end

@implementation AktOldPersonDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kColor(@"B1");
    //导航栏
    [self setNavTitle:@"老人信息"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    // 背景
    self.peopleBgView.layer.masksToBounds = YES;
    self.peopleBgView.layer.cornerRadius = 5;
    
    // 老人信息
    self.labName.text = kString([self.oldPresondetailsDic objectForKey:@"customerName"]);
    self.labIDCard.text = kString([self.oldPresondetailsDic objectForKey:@"customerUkey"]);
    self.labPhone.text = kString([self.oldPresondetailsDic objectForKey:@"customerPhone"]);
    self.labAddress.text = kString([self.oldPresondetailsDic objectForKey:@"serviceAddress"]);
    // 人脸采集按钮
    self.btnFace.backgroundColor = kColor(@"C8");
    self.btnFace.layer.masksToBounds = YES;
    self.btnFace.layer.cornerRadius = 5;
    
    // 信息录入
    self.btnInfo.backgroundColor = kColor(@"C8");
    self.btnInfo.layer.masksToBounds = YES;
    self.btnInfo.layer.cornerRadius = 5;
    
}
#pragma mark - click
- (IBAction)btnfaceInsert:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; // 暂时使用相册 后台修改分辨率之后再更改拍照
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        [[AppDelegate sharedDelegate] showTextOnly:@"您暂时没有拍照权限，请打开照相机权限！"];
    }
}
- (IBAction)btnPhoneClick:(UIButton *)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",kString(self.labPhone.text)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}

-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPeopleInfo:(UIButton *)sender {
    // 弹框
    AktOldPeopleView *alterV = [[AktOldPeopleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alterV.delegate = self;
    alterV.tag = 103;
    [[UIApplication sharedApplication].keyWindow addSubview:alterV];
}

#pragma mark - delegate
-(void)didOldInfoCancelAppClose:(NSInteger)type{
    [[[UIApplication sharedApplication].keyWindow  viewWithTag:103] removeFromSuperview];
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //上传
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"采集中..."];
    NSDictionary * parameters =@{@"customerName":kString([self.oldPresondetailsDic objectForKey:@"customerName"]),@"customerUkey":kString([self.oldPresondetailsDic objectForKey:@"customerUkey"]),@"customerImg":[self imageToBaseString:image],@"imgType":@"png"};
    [[AktVipCmd sharedTool] requestFaceCollect:parameters type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSLog(@"---%@",responseObject);
        [[AppDelegate sharedDelegate] showTextOnly:[responseObject objectForKey:@"message"]];
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError * _Nonnull error) {
        [[AppDelegate sharedDelegate] showTextOnly:[NSString stringWithFormat:@"%@",error]];
        [[AppDelegate sharedDelegate] hidHUD];
    }];
//    [self.imgClick setImage:image];
}

#pragma mark - UIImage图片转成Base64字符串
-(NSString *)imageToBaseString:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
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
