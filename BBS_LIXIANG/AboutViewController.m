//
//  AboutViewController.m
//  weitaozhi
//
//  Created by admin  on 13-8-17.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize webView;

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
	webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
    
	//添加headbar
    UIImage *headimage = [UIImage imageNamed:@"navBar.png"];
    UIImageView *headView = [[UIImageView alloc]initWithImage:headimage];
    [headView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:headView];

    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(7, 7, 42, 30);
    backBtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [backBtn setTitle: @"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"blankpress.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTag:100];
    [self.view addSubview:backBtn];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 30)];
    companyLabel.text = @"关于微淘职";
    companyLabel.font = [UIFont systemFontOfSize:21];
    companyLabel.textColor = [UIColor whiteColor];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:companyLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) BtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
