//
//  UserInfoViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UserInfoViewController.h"
#import "PostMailViewController.h"
#import "Toolkit.h"

#import "UIViewController+MJPopupViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

-(void)dealloc
{
    _ID = nil;
    _name = nil;
    _logins = nil;
    _level = nil;
    _posts = nil;
    _perform = nil;
    _experience = nil;
    _medals = nil;
    _logins = nil;
    _life = nil;
    _gender = nil;
    _astro = nil;
}

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
    
    //NSLog(@"userInformation: %@",_userDictionary);
    
    [self refreshView];
}

-(void)refreshView
{
    [_ID setText:_user.ID];
    [_name setText:_user.name];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    [_level setText:_user.level];
    [_posts setText:[NSString stringWithFormat:@"%d", _user.posts]];
    [_perform setText:[NSString stringWithFormat:@"%d", _user.perform]];
    [_experience setText:[NSString stringWithFormat:@"%d", _user.experience]];
    [_medals setText:[NSString stringWithFormat:@"%d", _user.medals]];
    [_logins setText:[NSString stringWithFormat:@"%d", _user.logins]];
    [_life setText:[NSString stringWithFormat:@"%d", _user.life]];
    
    if (_user.gender != NULL) {
        if([_user.gender isEqualToString:@"M"])
            [_gender setText:[NSString stringWithFormat:@"%@", @"帅哥"]];
        else
            [_gender setText:[NSString stringWithFormat:@"%@", @"美女"]];
        
        [_astro setText: _user.astro];
    }
    else {
        [_gender setText:@"保密"];
        [_astro setText:@"保密"];
    }

    _replyMailBtn.hidden = YES;
    
    if ([Toolkit getUserName] == nil) {
        _replyMailBtn.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postMail:(id)sender {
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
    
    PostMailViewController *postMailVC = [[PostMailViewController alloc]init];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailVC];
    //[self presentViewController:postMailVC animated:YES completion:nil];
}
@end
