//
//  HotBoardViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Board.h"
#import "MJRefresh.h"

@protocol HotBoardDelegate <NSObject>

-(void)pushToNextSingleSectionViewWithValue:(NSString *)boardName;

@end

@interface HotBoardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic, retain) UITableView *hotBoardTableView;

@property (nonatomic, retain) MJRefreshHeaderView *headerView;

@property (nonatomic, retain) NSMutableArray *hotBoardArr;

@property (nonatomic, strong) NSArray *pictureArr;

@property (nonatomic, retain) Board *selectBoard;

@property (nonatomic, assign) id delegate;

@end
