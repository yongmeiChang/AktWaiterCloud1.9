//
//  AktServicOldPersonVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2021/4/23.
//  Copyright © 2021 常永梅. All rights reserved.
//

#import "AktServicOldPersonVC.h"
#import "AktOldPersonDetailsVC.h"
#import "AktOldPersonModel.h"
#import "AktOldPeopelCell.h"

@interface AktServicOldPersonVC ()<AktOldPeoplePhoneDelegate>{
    int pageNum; // 页数
    NSMutableArray * dataArray;//数据源
    AktOldPersonModel *oldmodel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableOldPerson;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *tfOldPersonCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@end

@implementation AktServicOldPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏
    [self setNavTitle:@"用户列表"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    pageNum = 1;
    dataArray = [NSMutableArray array];
    self.tableOldPerson.mj_header = self.mj_header;
    self.tableOldPerson.mj_footer = self.mj_footer;
    [self.tableOldPerson.mj_header beginRefreshing];
    // 搜索栏
    self.searchView.layer.cornerRadius = 6;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - request
-(void)checkNetWork:(NSString *)ukey{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@"加载中..."];
    NSDictionary * parameters =@{@"waiterId":kString([LoginModel gets].uuid),@"pageSize":AktPageSize,@"pageNum":[NSString stringWithFormat:@"%d",pageNum],@"customerUkey":ukey}; // @"waiterId":[LoginModel gets].uuid,
    [[AktVipCmd sharedTool] requestOldpersonlist:parameters type:HttpRequestTypeGet success:^(id responseObject) {
        NSDictionary * dic = responseObject;
        NSNumber * code = [dic objectForKey:ResponseCode];
        if (pageNum == 1) {
            [dataArray removeAllObjects];
        }
        if([code intValue]==1){
            oldmodel = [[AktOldPersonModel alloc] initWithDictionary:[dic objectForKey:ResponseData] error:nil];
            [dataArray addObjectsFromArray:oldmodel.list];
            [self.tableOldPerson reloadData];
        }
        [[AppDelegate sharedDelegate] hidHUD];
    }failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}

#pragma mark - mj
-(void)loadHeaderData:(MJRefreshGifHeader*)mj{
    [self loadNewData];
}

-(void)loadFooterData:(MJRefreshAutoGifFooter *)mj{
    pageNum = pageNum+1;
    [self checkNetWork:kString(self.tfOldPersonCode.text)];
    [self.tableOldPerson.mj_footer endRefreshing];
}
-(void)loadNewData{
    pageNum = 1;
    [self checkNetWork:kString(self.tfOldPersonCode.text)];
    [self.tableOldPerson.mj_header endRefreshing];
}
#pragma mark - btn click
- (IBAction)btnSearchClick:(UIButton *)sender { // 搜索
    [self.tableOldPerson.mj_header beginRefreshing];
}
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
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
    static NSString *cellidentify = @"oldcell";
    AktOldPeopelCell *cell = (AktOldPeopelCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AktOldPeopelCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    AktOldPersonDetailsModel *deltaismodel = [dataArray objectAtIndex:indexPath.row];
    [cell setOldpeopleCallPhone:kString(deltaismodel.customerMobile) oldName:kString(deltaismodel.customerName)];
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
    detailsvc.oldPresondetailsModel = [dataArray objectAtIndex:indexPath.row];
    detailsvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsvc animated:YES];
}

#pragma mark - phone
-(void)didSelectCallPhone:(NSString *)phone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",kString(phone)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}
#pragma mark - text delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadNewData];
    [self.tfOldPersonCode resignFirstResponder];
    return YES;
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
