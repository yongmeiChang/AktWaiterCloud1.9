//
//  AktServicOldPersonVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/4/23.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import "AktServicOldPersonVC.h"
#import "AktOldPersonDetailsVC.h"
#import "AktTitleCell.h"

@interface AktServicOldPersonVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableOldPerson;
@property (weak, nonatomic) IBOutlet UITextField *tfOldPersonCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@end

@implementation AktServicOldPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏
    [self setNavTitle:@"老人"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
}

#pragma mark - btn click
- (IBAction)btnSearchClick:(UIButton *)sender {
    NSLog(@"---%@",self.tfOldPersonCode.text);
}
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

////设置分割线上下去边线，顶头缩进15
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableOldPerson respondsToSelector:@selector(setSeparatorInset:)]) {

            [self.tableOldPerson setSeparatorInset:UIEdgeInsetsMake(0, 41.5, 0, 9.5)];
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
    cell.labName.text = @"老人姓名";
    cell.labvalue.text = @"13671827222";
    cell.labValueConstraint.constant = 100;
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
    AktOldPersonDetailsVC *detailsvc = [[AktOldPersonDetailsVC alloc] init];
    detailsvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsvc animated:YES];
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
