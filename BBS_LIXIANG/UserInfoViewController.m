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
    NSDictionary *dic = [_userDictionary objectForKey:@"user"];
    [_ID setText:[dic objectForKey:@"id"]];
    [_name setText:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
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
