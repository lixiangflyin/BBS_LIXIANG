//
//  SettingViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-19.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *settingTableView;

@end
