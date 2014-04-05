//
//  HomeViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomNavigationViewController.h"
#import "SingleTopicViewController.h"


@interface HomeViewController ()
{
    //左右滑动部分
    UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;
    
}

@end

@implementation HomeViewController

-(void)dealloc
{
    _toptenViewContrller = nil;
    _allSectionViewController = nil;
    _boardViewController = nil;
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
    
	self.title = @"虎踞龙盘";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MENU"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(CustomNavigationViewController *)self.navigationController
                                                                            action:@selector(showMenu)];

    
    _toptenViewContrller = [[TopTenViewController alloc]init];
    _toptenViewContrller.delegate = self;
    _allSectionViewController = [[AllSectionTopViewController alloc]init];
    _allSectionViewController.delegate = self;
    _boardViewController = [[SectionsViewController alloc]init];
    
    //滑动特效
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = YES;
    _scrollView.delegate = self;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_scrollView];
    
    //公用
    currentPage = 1;
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 1;
    pageControl.backgroundColor = [UIColor whiteColor];
    [self createAllEmptyPagesForScrollView];

}

- (void)createAllEmptyPagesForScrollView {
    
    [_toptenViewContrller.view setFrame:CGRectMake(320*1, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [_allSectionViewController.view setFrame:CGRectMake(320*0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [_boardViewController.view setFrame:CGRectMake(320*2, -64, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [_scrollView addSubview:_toptenViewContrller.view];
    [_scrollView addSubview:_allSectionViewController.view];
    [_scrollView addSubview:_boardViewController.view];
    [_scrollView setContentOffset:CGPointMake(320*1, 0)];//页面滑动
}

#pragma mark - scrollView 委托
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPage = page;
    currentPage = page;
    pageControlUsed = NO;
    
    //同时改变按钮
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //暂不处理 - 其实左右滑动还有包含开始等等操作，这里不做介绍
}


#pragma -mark TopTenTopicsDelegate
-(void)pushToNextViewWithValue:(Topic *)topic
{
    SingleTopicViewController *single = [[SingleTopicViewController alloc]init];
    [single setRootTopic:topic];
    [self.navigationController pushViewController:single animated:YES];
    single = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
