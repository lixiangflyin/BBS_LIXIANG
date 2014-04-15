//
//  MySectionsViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface MySectionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *mySectionsTableView;

@property (nonatomic, retain) MJRefreshHeaderView *headerView;

@property (nonatomic, retain) MJRefreshFooterView *footerView;

@property (nonatomic, retain) NSMutableArray *mySectionsArr;

@property (nonatomic, retain) NSString *selectSection;

@end
