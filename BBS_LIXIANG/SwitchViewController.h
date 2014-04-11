//
//  SwitchViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopTenViewController.h"
#import "AllSectionTopViewController.h"
#import "SectionsViewController.h"
#import "HotBoardViewController.h"

#import "SUNSlideSwitchView.h"
#import "LCViewController.h"

@interface SwitchViewController : UIViewController<TopTenTopicsDelegate,HotBoardDelegate,SectionsDelegate,AllSectionsTopicsDelegate,SUNSlideSwitchViewDelegate>

@property (weak, nonatomic) IBOutlet SUNSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) TopTenViewController *toptenViewContrller;
@property (nonatomic, strong) AllSectionTopViewController *allSectionViewController;
@property (nonatomic, strong) SectionsViewController *boardViewController;
@property (nonatomic, strong) HotBoardViewController *hotBoardViewController;

@end
