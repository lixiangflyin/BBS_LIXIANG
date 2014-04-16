//
//  TopTenViewController.h
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Topic.h"
#import "MJRefresh.h"

@protocol TopTenTopicsDelegate <NSObject>

-(void)pushToNextViewWithValue:(Topic *)topic;

@end

@interface TopTenViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic, retain) UITableView *tentopicTableView;

@property (nonatomic, retain) MJRefreshHeaderView *headerView;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) NSMutableArray *tentopicsArr;

@property (nonatomic, retain) Topic *selectTopic;

@property (nonatomic, assign) id delegate;

@end
