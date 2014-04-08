//
//  UserInfoViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"userInformation: %@",_userDictionary);
    
    [self refreshView];
}

-(void)refreshView
{
    NSDictionary *dic = [_userDictionary objectForKey:@"user"];
    [_ID setText:[dic objectForKey:@"id"]];
    [_name setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    //NSString * lastloginstring = [dateFormatter stringFromDate:user.lastlogin];
    //[_lastlogin setText:[NSString stringWithFormat:@"%@",lastloginstring]];
    
    [_level setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"level"]]];
    [_posts setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"posts"]]];
    [_perform setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"perform"]]];
    [_experience setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"experience"]]];
    [_medals setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"medals"]]];
    [_logins setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"logins"]]];
    [_life setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"life"]]];
    
    if ([dic objectForKey:@"gender"] != NULL) {
        if([[dic objectForKey:@"gender"] isEqualToString:@"M"])
            [_gender setText:[NSString stringWithFormat:@"%@", @"帅哥"]];
        else
            [_gender setText:[NSString stringWithFormat:@"%@", @"美女"]];
        
        [_astro setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"astro"]]];
    }
    else {
        [_gender setText:@"保密"];
        [_astro setText:@"保密"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
