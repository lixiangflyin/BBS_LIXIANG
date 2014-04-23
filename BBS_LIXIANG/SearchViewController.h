//
//  SearchViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Topic.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSString *searchString;

@property (nonatomic, retain) UITableView *searchTableView;

@property (nonatomic, retain) NSMutableArray *searchTopicsArr;

@property (nonatomic, retain) Topic *selectTopic;

-(void)reloadSearchView;

@end
