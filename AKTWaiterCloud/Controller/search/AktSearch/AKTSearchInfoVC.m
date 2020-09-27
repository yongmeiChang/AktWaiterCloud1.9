//
//  AKTSearchInfoVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/9/19.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AKTSearchInfoVC.h"
#import "SearchDateController.h"

@interface AKTSearchInfoVC ()<UITextFieldDelegate>
{
    NSString *strTime;
}
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@end

@implementation AKTSearchInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.netWorkErrorView setHidden:YES];
    [self setTitle:@"搜索"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    strTime = [[NSString alloc] init];
    // 注册搜索通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNoticeDate:) name:@"searchDateVC" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - notice
-(void)searchNoticeDate:(NSNotification *)searchDate{
    if (searchDate) {
     NSDictionary *dicDate = [searchDate object];
        strTime = [NSString stringWithFormat:@"%@ %@",kString([dicDate objectForKey:@"beginDate"]),kString([dicDate objectForKey:@"endDate"])];
        self.labTime.text = strTime;
    }
}
#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchClick:(UIButton *)sender {
    [self.tfSearch resignFirstResponder];
    [self.tfAddress resignFirstResponder];
    [self.tfOrderNumber resignFirstResponder];
    
    if (_delegate&&[_delegate respondsToSelector:@selector(searchKey:SearchAddress:Searchtime:SearchOrder:Sender:)])
        [_delegate searchKey:kString(_tfSearch.text) SearchAddress:kString(_tfAddress.text) Searchtime:kString(strTime) SearchOrder:kString(_tfOrderNumber.text) Sender:sender.tag];
}

- (IBAction)btnSelectTimeClick:(UIButton *)sender {
    SearchDateController *searchTimevc = [[SearchDateController alloc] init];
    searchTimevc.typeVC = 1;
    searchTimevc.mindate = @"1996-01-01";
    searchTimevc.maxdate = [AktUtil getNowDate];
    [self.navigationController pushViewController:searchTimevc animated:YES];
}
#pragma mark - text delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tfSearch resignFirstResponder];
    [self.tfAddress resignFirstResponder];
    [self.tfOrderNumber resignFirstResponder];
    
    return textField;
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
