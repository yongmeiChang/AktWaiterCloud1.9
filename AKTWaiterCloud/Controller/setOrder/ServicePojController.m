//
//  ServicePojController.m
//  AnKangTong
//
//  Created by 孙嘉斌 on 2017/11/7.
//  Copyright © 2017年 www.3ti.us. All rights reserved.
//

#import "ServicePojController.h"
#import "ServicePojCell.h"
#import "DownOrderController.h"

@interface ServicePojController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoginModel *model;
}
@property(nonatomic,strong) IBOutlet UITableView * tableview;
@property(nonatomic,strong) NSArray * dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *imgNodata;
@property (weak, nonatomic) IBOutlet UILabel *labNodata;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toptableview;

@end

@implementation ServicePojController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"B2");
    [self setNavTitle:@"服务项目"];
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    model = [LoginModel gets];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _dataArray = [NSArray array];
    [self requestServicePoj];
}

-(void)requestServicePoj{
    [[AppDelegate sharedDelegate] showLoadingHUD:self.view msg:@""];
    NSMutableDictionary *paremeter = [NSMutableDictionary dictionary];
    [paremeter addUnEmptyString:model.tenantId forKey:@"tenantsId"];
    [[AFNetWorkingRequest sharedTool] requestWithGetServicePojCustomerUkeyParameters:paremeter type:HttpRequestTypeGet success:^(id responseObject) {
       
        NSMutableArray *arr = [NSMutableArray array];
        if([[responseObject objectForKey:@"code"] intValue] == 1){
            NSArray *object = [responseObject objectForKey:ResponseData];
            [object enumerateObjectsUsingBlock:^(id  _Nonnull
                                                 obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary * Obj = [NSMutableDictionary dictionaryWithDictionary:obj];
//                NSDictionary * dic = [Obj objectForKey:@"createBy"];
//                NSString * createByid = [dic objectForKey:@"id"];
//                if(!createByid){
//                    createByid= @"";
//                }
//                [Obj removeObjectForKey:@"createBy"];
//                [Obj setObject:createByid forKey:@"createBy"];
                ServicePojInfo *font = [[ServicePojInfo alloc]initWithDictionary:Obj error:nil];
                
                if(font) {
                    [arr addObject:font];
                }
            }];
        }else{
            self.imgNodata.hidden = NO;
            self.labNodata.hidden = NO;
            self.tableview.hidden = YES;
            self.labNodata.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]];
        }
        
        _dataArray = [NSMutableArray arrayWithArray:arr];
        [_tableview reloadData];
        [[AppDelegate sharedDelegate] hidHUD];
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] hidHUD];
    }];
}

-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview设置
/**段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/**行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 设置section背景颜色
    view.tintColor = [UIColor colorWithRed:226/255.0f green:231/255.0f blue:237/255.0f alpha:1];
}
/**Cell生成*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"serviceListCell";
    ServicePojCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServicePojCell" owner:self options:nil] lastObject];
    }
    ServicePojInfo * spInfo = [_dataArray objectAtIndex:indexPath.row];
    [cell setCellInfo:spInfo selectCellInf:self.selectInfo IndexPath:indexPath];
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
    ServicePojInfo * spInfo = [_dataArray objectAtIndex:indexPath.row];
    if(_DoContoller){
        _DoContoller.servicepojInfo = spInfo;
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


@end
