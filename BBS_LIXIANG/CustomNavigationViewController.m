//
//  CustomNavigationViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CustomNavigationViewController.h"
#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface CustomNavigationViewController ()

@property (strong, readwrite, nonatomic) MenuViewController *menuViewController;

@end

@implementation CustomNavigationViewController

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
	// Do any additional setup after loading the view.
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
