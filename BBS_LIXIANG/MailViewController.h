//
//  MailViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Mail.h"
#import "MJRefresh.h"

@interface MailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *mailsTableView;

@property (nonatomic, retain) MJRefreshHeaderView *headerView;

@property (nonatomic, retain) MJRefreshFooterView *footerView;

@property (nonatomic, assign) BOOL isRefreshAgain;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) NSMutableArray *mailsArr;

@property (nonatomic, retain) Mail *selectMail;

@end
