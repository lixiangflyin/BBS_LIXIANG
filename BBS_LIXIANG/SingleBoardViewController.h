//
//  SingleBoardViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Board.h"
#import "Topic.h"

@interface SingleBoardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *singleSectionTableView;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) NSMutableArray *singleSectionArr;

@property (nonatomic, retain) Board *requestBoard;

@property (nonatomic, retain) Topic *selectTopic;

@end
