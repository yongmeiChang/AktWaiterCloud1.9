//
//  AktWSigninListVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2019/12/25.
//  Copyright © 2019 孙嘉斌. All rights reserved.
//

#import "AktWSigninListVC.h"
#import "ServicePojCell.h"

@interface AktWSigninListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *aryAll;
    SigninListInfo *modellist;
    UIImageView *imageSection; // 展开某一个section 图片
}
@property (weak, nonatomic) IBOutlet UITableView *tableList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topyable;

@property (nonatomic,strong)NSMutableArray *flagArray;

@end

@implementation AktWSigninListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择租户";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    aryAll = [[NSMutableArray alloc] init];
    _flagArray  = [[NSMutableArray alloc] init];

    modellist = [[SigninListInfo alloc] init];
    [self reloadListZuhu];
}
#pragma mark - request
-(void)reloadListZuhu{
    [[AFNetWorkingTool sharedTool] requestWithURLString:@"getTenantsTree" parameters:@{} type:HttpRequestTypePost success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *code = [dic objectForKey:@"code"];
        NSString *msg = [dic objectForKey:@"message"];
        if ([code integerValue] == 1) {
            [aryAll addObjectsFromArray:[dic objectForKey:@"object"]];
            for (int s=0; s<aryAll.count; s++) {
                 [_flagArray addObject:@"0"];
            }
            [self.tableList reloadData];
        }else{
            [[AppDelegate sharedDelegate] showTextOnly:msg];
        }
    } failure:^(NSError *error) {
        [[AppDelegate sharedDelegate] showTextOnly:error.domain];
    }];
}
#pragma mark - tableview datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return aryAll.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     modellist = [[SigninListInfo alloc] initWithDictionary:[aryAll objectAtIndex:section] error:nil];
    return [modellist.tenantsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_flagArray[indexPath.section] isEqualToString:@"0"])
           return 0;
       else
           return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentify = @"ServicePojCell";
    ServicePojCell *cell = (ServicePojCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServicePojCell" owner:self options:nil] objectAtIndex:0];
    }
    modellist = [[SigninListInfo alloc] initWithDictionary:[aryAll objectAtIndex:indexPath.section] error:nil];
    SigninDetailsInfo *modelDetails = [modellist.tenantsList objectAtIndex:indexPath.row];
    [cell setSigninDetailsCellInfo:modelDetails selectCellInfo:self.selectZuhuInfo];
    
    return cell;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    modellist = [[SigninListInfo alloc] initWithDictionary:[aryAll objectAtIndex:section] error:nil];
    
    UIView *viewbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    viewbg.tag = 100+section;
    
    UILabel *labLeft = [[UILabel alloc] initWithFrame:CGRectMake(16.5, 18, 4.5, 14)];
    labLeft.backgroundColor = kColor(@"C8");
    [viewbg addSubview:labLeft];
    
    UILabel *labName = [[UILabel alloc] init];
    labName.font = [UIFont systemFontOfSize:14];
    labName.textAlignment = NSTextAlignmentLeft;
    labName.text = kString(modellist.pname);
    [viewbg addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labLeft.mas_right).offset(6);
        make.top.bottom.right.mas_equalTo(viewbg);
    }];
    
    imageSection = [[UIImageView alloc] init];
  
    [viewbg addSubview:imageSection];
    [imageSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(viewbg);
        if ([_flagArray[section] isEqualToString:@"0"]){
            imageSection.image = [UIImage imageNamed:@"right"];
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(11);
          }else{
            imageSection.image = [UIImage imageNamed:@"down"];
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(6);
          }
       
        make.right.mas_equalTo(viewbg.mas_right).offset(-22.5);
    }];
    
    UILabel *labLine = [[UILabel alloc] init];
    labLine.backgroundColor = kColor(@"C12");
    [viewbg addSubview:labLine];
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(viewbg);
        make.height.mas_equalTo(1);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [viewbg addGestureRecognizer:tap];
    
    return viewbg;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    viewFooter.backgroundColor = kColor(@"B1");
    return viewFooter;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    modellist = [[SigninListInfo alloc] initWithDictionary:[aryAll objectAtIndex:indexPath.section] error:nil];
    SigninDetailsInfo *modelDetails = [modellist.tenantsList objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectZuhu" object:modelDetails userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - click
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sectionClick:(UITapGestureRecognizer *)sender{
    int index = sender.view.tag % 100;

    //展开
    if ([_flagArray[index] isEqualToString:@"0"]) {
        _flagArray[index] = @"1";
    } else { //收起
        _flagArray[index] = @"0";
    }
    
     NSRange range = NSMakeRange(index, 1);
     NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
     [_tableList reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
