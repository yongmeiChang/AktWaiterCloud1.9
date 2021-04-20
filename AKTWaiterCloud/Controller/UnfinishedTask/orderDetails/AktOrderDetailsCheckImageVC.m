//
//  AktOrderDetailsCheckImageVC.m
//  AKTWaiterCloud
//
//  Created by 常永梅 on 2020/3/18.
//  Copyright © 2020 孙嘉斌. All rights reserved.
//

#import "AktOrderDetailsCheckImageVC.h"

@interface AktOrderDetailsCheckImageVC ()

@end

@implementation AktOrderDetailsCheckImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"查看图片";
    [self setNomalRightNavTilte:@"" RightTitleTwo:@""];
    UIView * popview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    popview.backgroundColor = [UIColor grayColor];
    [popview setTag:10];
    [self.view addSubview:popview];

    UIScrollView *scollBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    scollBg.contentSize = CGSizeMake(SCREEN_WIDTH*self.aryImg.count, self.view.frame.size.height);
    scollBg.pagingEnabled = YES;
    [popview addSubview:scollBg];
    for (int i = 0; i<self.aryImg.count; i++) {
        NSDictionary * object = self.aryImg[i];
        NSString * affixName = object[@"affixUrl"];
        UIImageView * photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.view.frame.size.height)];
        photoImageView.clipsToBounds = YES;
        photoImageView.contentMode = UIViewContentModeScaleAspectFit;
         photoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kString(affixName)]]]];
        [scollBg addSubview:photoImageView];
        
    }
}
#pragma mark - back
-(void)LeftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
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
