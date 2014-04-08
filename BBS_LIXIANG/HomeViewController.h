//
//  HomeViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopTenViewController.h"
#import "AllSectionTopViewController.h"
#import "SectionsViewController.h"


@interface HomeViewController : UIViewController<TopTenTopicsDelegate,SectionsDelegate,AllSectionsTopicsDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) TopTenViewController *toptenViewContrller;
@property (nonatomic, strong) AllSectionTopViewController *allSectionViewController;
@property (nonatomic, strong) SectionsViewController *boardViewController;

@property (strong, nonatomic) UIScrollView *scrollView;

@end
