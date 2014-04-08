//
//  UserInfoViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastLogin;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *astro;
@property (weak, nonatomic) IBOutlet UILabel *posts;
@property (weak, nonatomic) IBOutlet UILabel *experience;
@property (weak, nonatomic) IBOutlet UILabel *perform;
@property (weak, nonatomic) IBOutlet UILabel *logins;
@property (weak, nonatomic) IBOutlet UILabel *life;
@property (weak, nonatomic) IBOutlet UILabel *medals;


@property (nonatomic, strong) NSDictionary *userDictionary;




@end









