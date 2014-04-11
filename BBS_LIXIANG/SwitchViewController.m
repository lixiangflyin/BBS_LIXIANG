//
//  SwitchViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SwitchViewController.h"
#import "UIViewController+MMDrawerController.h"

#import "SingleTopicViewController.h"
#import "SingleBoardViewController.h"

@interface SwitchViewController ()

@end

@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(leftDrawerButtonPress:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.title = @"虎踞龙盘";
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    _toptenViewContrller = [[TopTenViewController alloc]init];
    _toptenViewContrller.title = @"今日十大";
    _toptenViewContrller.delegate = self;
    _allSectionViewController = [[AllSectionTopViewController alloc]init];
    _allSectionViewController.title = @"分区逛逛";
    _allSectionViewController.delegate = self;
    _boardViewController = [[SectionsViewController alloc]init];
    _boardViewController.title = @"分类讨论";
    _boardViewController.delegate = self;
    
    _hotBoardViewController = [[HotBoardViewController alloc]init];
    _hotBoardViewController.title = @"人气版面";
    _hotBoardViewController.delegate = self;
    
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    self.slideSwitchView.rigthSideButton = rightSideButton;
    
    [self.slideSwitchView buildUI];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 4;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0)
    {
        return self.toptenViewContrller;
    }
    else if (number == 1)
    {
        
        return self.allSectionViewController;
    }
    else if (number == 2)
    {
        return self.hotBoardViewController;
    }
    else if (number == 3)
    {
        return self.boardViewController;
    }
    else
    {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    LCViewController *drawerController = (LCViewController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number == 0)
    {
        TopTenViewController *vc = nil;
        vc = self.toptenViewContrller;
        //[vc viewDidCurrentView];
    }
    else if (number == 1)
    {
        AllSectionTopViewController *vc = nil;
        vc = self.allSectionViewController;
        //[vc viewDidCurrentView];
    }
    else if (number == 2)
    {
        HotBoardViewController *vc = nil;
        vc = self.hotBoardViewController;
        //[vc viewDidCurrentView];
    }
    else if (number == 3)
    {
        SectionsViewController *vc = nil;
        vc = self.boardViewController;
    }
}

#pragma -mark TopTenTopicsDelegate
-(void)pushToNextViewWithValue:(Topic *)topic
{

    SingleTopicViewController *single = [[SingleTopicViewController alloc]init];
    [single setRootTopic:topic];
    [self.navigationController pushViewController:single animated:YES];
    single = nil;
}

#pragma -mark TopTenTopicsDelegate
-(void)pushToNextSingleSectionViewWithValue:(Board *)board
{
    
    SingleBoardViewController *single = [[SingleBoardViewController alloc]init];
    [single setRequestBoard:board];
    [self.navigationController pushViewController:single animated:YES];
    single = nil;
}


#pragma -mark AllSectionsTopicsDelegate
-(void)pushToNextSingleSectionView
{

    SingleBoardViewController *single = [[SingleBoardViewController alloc]init];
    [self.navigationController pushViewController:single animated:YES];
    single = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
