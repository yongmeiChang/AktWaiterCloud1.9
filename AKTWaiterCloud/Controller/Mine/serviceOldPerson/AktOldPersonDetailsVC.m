//
//  AktOldPersonDetailsVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/4/25.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import "AktOldPersonDetailsVC.h"

@interface AktOldPersonDetailsVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgClick;

@end

@implementation AktOldPersonDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏
    [self setNavTitle:@"老人信息"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
}
#pragma mark - click
- (IBAction)btnfaceInsert:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
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

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imgClick setImage:image];
   
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
