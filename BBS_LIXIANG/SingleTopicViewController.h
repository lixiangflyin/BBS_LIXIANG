//
//  SingleTopicViewController.h
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Topic.h"
#import "UIViewController+MJPopupViewController.h"

@interface SingleTopicViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *singletopicTableView;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) NSMutableArray *topicsArray;

@property (nonatomic, retain) NSMutableArray *usersInfo;

@property (nonatomic, retain) NSDictionary *oneUserInfo;

@property (nonatomic, assign) BOOL isRequestToTopics;

@property(nonatomic, strong) Topic * rootTopic;

@end
