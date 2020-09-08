//
//  AktServiceStationListVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/8/7.
//  Copyright © 2020 常永梅. All rights reserved.
//

#import "AktServiceStationListVC.h"
#import "ServicePojCell.h"
#import "DownOrderController.h"

@interface AktServiceStationListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong) IBOutlet UITableView * tableview;
@property (weak, nonatomic) IBOutlet UIImageView *imgNodata;
@property (weak, nonatomic) IBOutlet UILabel *labNodata;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toptableview;
@end

@implementation AktServiceStationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kColor(@"B2");
    [self setNavTitle:@"服务站"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    if (self.aryStation.count>0) {
        self.labNodata.hidden = YES;
    }else{
        self.labNodata.hidden = NO;
    }
}

#pragma mark -
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - table delegate

/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/**行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.aryStation.count;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 设置section背景颜色
    view.tintColor = [UIColor colorWithRed:226/255.0f green:231/255.0f blue:237/255.0f alpha:1];
}
/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"stationListCell";
    ServicePojCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServicePojCell" owner:self options:nil] lastObject];
    }
    ServiceStationInfo * spInfo = [self.aryStation objectAtIndex:indexPath.row];
    [cell setStationCellInfo:spInfo selectCellInf:self.stationInfo IndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0.0f;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceStationInfo * stationInfo = [self.aryStation objectAtIndex:indexPath.row];
    if(_DoContoller){
        _DoContoller.stationInfo = stationInfo;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//让section的头部跟着一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview)
    {
        CGFloat sectionHeaderHeight = 20;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
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
