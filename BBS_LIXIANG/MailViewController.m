//
//  MailViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MailViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SingleMailViewController.h"
#import "PostMailViewController.h"
#import "Toolkit.h"

#import "MailCell.h"
//#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"

@interface MailViewController ()

@end

@implementation MailViewController

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
	
    self.title = @"我的信箱";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(leftDrawerButtonPress:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *writeButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeMail:)];
    self.navigationItem.rightBarButtonItem = writeButton;
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mailbox/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",[Toolkit getToken]];
    [baseurl appendFormat:@"&type=%i",0];
    [baseurl appendFormat:@"&limit=30&start=%i",0];
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
    _mailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _mailsTableView.dataSource = self;  //数据源代理
    _mailsTableView.delegate = self;    //表视图委托
    [self.view addSubview:_mailsTableView];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma -mark asi Delegate
//ASI委托函数，错误处理
-(void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"error!");
    
}

//ASI委托函数，信息处理
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [request.responseString objectFromJSONString];
    NSLog(@"dic %@",dic);
    
    //我的收件箱
    NSArray * objects = [JsonParseEngine parseMails:dic Type:0];
    NSLog(@"%@",objects);
    
    self.mailsArr = [NSMutableArray arrayWithArray:objects];
    [_mailsTableView reloadData];
    
}

#pragma mark - 数据源协议
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mailsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identi = @"MailCell";
    //第一次需要分配内存
    MailCell * cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MailCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    Mail * mail = [self.mailsArr objectAtIndex:indexPath.row];
    cell.mail = mail;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    self.selectMail = [self.mailsArr objectAtIndex:indexPath.row];
    
    SingleMailViewController *single = [[SingleMailViewController alloc]init];
    [single setRootMail:self.selectMail];
    [self.navigationController pushViewController:single animated:YES];
    single = nil;
}

#pragma -mark 回复邮件
-(void)writeMail:(id)sender
{
    //发邮件
    PostMailViewController *postMailVC = [[PostMailViewController alloc]init];
    postMailVC.postType = 0;
    [self presentViewController:postMailVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
