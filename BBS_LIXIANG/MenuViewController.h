//
//  MenuViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface MenuViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headPhotoView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *name1Label;
@property (weak, nonatomic) IBOutlet UILabel *name2Label;

- (IBAction)clickButton:(id)sender;

@end
