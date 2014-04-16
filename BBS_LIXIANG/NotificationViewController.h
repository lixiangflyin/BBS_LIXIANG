//
//  NotificationViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Topic.h"
#import "MJRefresh.h"

@interface NotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic, retain) UITableView *mynotiTableView;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) MJRefreshHeaderView *headerView;

@property (nonatomic, retain) NSMutableArray *notificationsArr;

@property (nonatomic, retain) Topic *selectTopic;

@end
