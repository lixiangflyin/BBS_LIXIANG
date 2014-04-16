//
//  NotificationViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NotificationViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SingleTopicViewController.h"

#import "SearchTopicCell.h"
#import "JsonParseEngine.h"
#import "Notification.h"
#import "Toolkit.h"
#import "ProgressHUD.h"



@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    
    self.title = @"我的消息";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(leftDrawerButtonPress:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    _mynotiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _mynotiTableView.dataSource = self;  //数据源代理
    _mynotiTableView.delegate = self;    //表视图委托
    [self.view addSubview:_mynotiTableView];
    
    //下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.mynotiTableView;
    header.delegate = self;
    // 自动刷新
    [header beginRefreshing];
    _headerView = header;
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    //通过url来获得JSON数据
    NSString *baseUrlStr = [NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/notifications.json?token=%@",[Toolkit getToken]];
    NSURL *myurl = [NSURL URLWithString:baseUrlStr];
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
    [ProgressHUD showError:@"网络故障"];
}

//ASI委托函数，信息处理
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [request.responseString objectFromJSONString];
    
    Notification * notification = [JsonParseEngine parseNotification:dic];
    
    NSArray *objects = notification.replies;
    
    self.notificationsArr = [NSMutableArray arrayWithArray:objects];
    
    [_mynotiTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_headerView endRefreshing];
    
}

#pragma mark - 数据源协议
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notificationsArr count];
    //NSLog(@"count %d",[self.allTopicsArr count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identi = @"SearchTopicCell";
    //第一次需要分配内存
    SearchTopicCell * cell = (SearchTopicCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SearchTopicCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    Topic * topic = [self.notificationsArr objectAtIndex:indexPath.row];
    cell.section = topic.board;
    cell.title = topic.title;
    cell.author = topic.author;
    
    [cell setReadyToShow];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int returnHeight;
    
    Topic * topic = [self.notificationsArr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size1 = [topic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    
    returnHeight = size1.height  + 49;
    
    return returnHeight;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectTopic = [self.notificationsArr objectAtIndex:indexPath.row];
    
    SingleTopicViewController *single = [[SingleTopicViewController alloc]init];
    [single setRootTopic:self.selectTopic];
    [self.navigationController pushViewController:single animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
