//
//  SearchViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Topic.h"
#import "MJRefresh.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSString *searchString;

@property (nonatomic, retain) UITableView *searchTableView;

//加载与刷新
@property (nonatomic, retain) MJRefreshHeaderView *headerView;

@property (nonatomic, retain) MJRefreshFooterView *footerView;

@property (nonatomic, assign) BOOL isRefreshAgain;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) NSMutableArray *searchTopicsArr;

@property (nonatomic, retain) Topic *selectTopic;



@end
