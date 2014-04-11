//
//  HotBoardViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Board.h"

@protocol HotBoardDelegate <NSObject>

-(void)pushToNextSingleSectionViewWithValue:(Board *)board;

@end

@interface HotBoardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *hotBoardTableView;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, retain) NSMutableArray *hotBoardArr;

@property (nonatomic, retain) Board *selectBoard;

@property (nonatomic, assign) id delegate;

@end
