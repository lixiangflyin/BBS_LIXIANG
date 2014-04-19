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
#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"
#import "MJRefresh.h"

@interface MailViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    BOOL _isRefreshAgain;
}

@end

@implementation MailViewController

-(void)dealloc
{
    [_headerView free];
    [_footerView free];
    _mailsArr = nil;
    _selectMail = nil;
    _request = nil;
    _mailsTableView = nil;
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
	
    _mailsArr = [[NSMutableArray alloc]init];
    
    NSLog(@"token: %@",[Toolkit getToken]);
    
    self.title = @"我的信箱";
    UIImage* image= [UIImage imageNamed:@"t1.png"];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *writeButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeMail:)];
    self.navigationItem.rightBarButtonItem = writeButton;
    
    _mailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _mailsTableView.dataSource = self;  //数据源代理
    _mailsTableView.delegate = self;    //表视图委托
    _mailsTableView.separatorStyle = NO;
    [self.view addSubview:_mailsTableView];
    
    //刷新和加载更多
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.mailsTableView;
    header.delegate = self;
    // 自动刷新
    [header beginRefreshing];
    _headerView = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.mailsTableView;
    footer.delegate = self;
    _footerView = footer;
    
    
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mailbox/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",[Toolkit getToken]];
    [baseurl appendFormat:@"&type=%i",0];
    [baseurl appendFormat:@"&limit=30&start=%i",0];
    
    //判断是否是刷新还是加载更多
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        
        _isRefreshAgain = YES;
        [baseurl appendFormat:@"&limit=30&start=%i",0];
        
    } else {
        
        _isRefreshAgain = NO;
        [baseurl appendFormat:@"&limit=30&start=%i",(int)[_mailsArr count]];
        
    }
    //通过url来获得JSON数据
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];

}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    //NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            //NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            //NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
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
    [_headerView endRefreshing];
    [_footerView endRefreshing];
    [ProgressHUD showError:@"网络故障"];
}

//ASI委托函数，信息处理
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [request.responseString objectFromJSONString];
    
    //我的收件箱
    NSArray * objects = [JsonParseEngine parseMails:dic Type:0];
    
    if (_isRefreshAgain) {
        [self.mailsArr removeAllObjects];
        [self.mailsArr addObjectsFromArray:objects];
        
        [_mailsTableView reloadData];
        [_headerView endRefreshing];
    }
    else{
        [self.mailsArr addObjectsFromArray:objects];
        
        [_mailsTableView reloadData];
        [_footerView endRefreshing];
    }
    
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
        
        [cell setBackgroundColor:UIColorFromRGB(0xD1EEFC)];
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
