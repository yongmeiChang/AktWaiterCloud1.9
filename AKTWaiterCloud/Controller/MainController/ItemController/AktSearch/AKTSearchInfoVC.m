//
//  AKTSearchInfoVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/9/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AKTSearchInfoVC.h"
#import "AktSearchFmdb.h"

@interface AKTSearchInfoVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UITextField *tfTime;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfOrderNumber;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNav;

@end

@implementation AKTSearchInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.netWorkErrorView setHidden:YES];
    NSLog(@"%f  %f  %f"  ,AktNavHight,AktStatusHight,AktNavAndStatusHight);
    self.topNav.constant = 44+ AktStatusHight;
    
    [self setTitle:@"搜索"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnBackCkick:(id)sender {
      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)searchClick:(UIButton *)sender {
    [self.tfSearch resignFirstResponder];
    [self.tfTime resignFirstResponder];
    [self.tfAddress resignFirstResponder];
    [self.tfOrderNumber resignFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(searchKey:Sender:)])
        [_delegate searchKey:kString(_tfSearch.text) Sender:sender.tag];
}

#pragma mark - text delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tfSearch resignFirstResponder];
    [self.tfTime resignFirstResponder];
    [self.tfAddress resignFirstResponder];
    [self.tfOrderNumber resignFirstResponder];
    
    return textField;
}


@end
