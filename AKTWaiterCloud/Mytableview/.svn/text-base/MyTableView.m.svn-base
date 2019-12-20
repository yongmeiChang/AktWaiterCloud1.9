//
//  MyTableView.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/22.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView

-(void)initImageArr{
    self.imageArrs = [NSArray array];
    NSMutableArray * arr = [NSMutableArray array];
    for(int i=1; i<=32;i++){
        NSString * imagename = [NSString stringWithFormat:@"loading%d.png",i];
        UIImage * image = [UIImage imageNamed:imagename];
        [arr addObject:image];
    }
    self.imageArrs = [NSArray arrayWithArray:arr];
}

-(void)setReqestHeader{
    //去除没有数据时的分割线
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //去除右侧滚动条
    self.showsVerticalScrollIndicator = NO;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [_header setTitle:@"按住下拉" forState:MJRefreshStateIdle];
    [_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    // 设置普通状态的动画图片 (idleImages 是图片)
    [_header setImages:self.imageArrs forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [_header setImages:self.imageArrs forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [_header setImages:self.imageArrs forState:MJRefreshStateRefreshing];
    self.mj_header = _header;
}

-(void)setRequestFooter{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置刷新图片
    //[footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [_footer setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
    _footer.triggerAutomaticallyRefreshPercent = 50.0;
    self.mj_footer = _footer;
}

-(void)loadNewData{
    
}

-(void)loadMoreData{
    
}
@end
