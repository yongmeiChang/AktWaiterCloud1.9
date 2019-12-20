//
//  MyTableView.h
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/12/22.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface MyTableView : UITableView
@property(nonatomic,strong) MJRefreshAutoGifFooter *footer;
@property(nonatomic,strong) MJRefreshGifHeader * header;
@property(nonatomic,strong) NSArray * imageArrs;

-(void)initImageArr;
-(void)setReqestHeader;
-(void)setRequestFooter;

-(void)loadNewData;
-(void)loadMoreData;
@end
