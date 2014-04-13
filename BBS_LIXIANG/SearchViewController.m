//
//  SearchViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+MMDrawerController.h"

#import "SingleTopicViewController.h"
#import "TopCell.h"
//#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"

#import "WBUtil.h"   //格式转换

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    
    self.title = @"搜索结果";
    
    _searchTopicsArr = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(leftDrawerButtonPress:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _searchTableView.dataSource = self;  //数据源代理
    _searchTableView.delegate = self;    //表视图委托
    [self.view addSubview:_searchTableView];
    
    [self addHeaderView];
    [self addFooterView];
}

//添加下拉刷新
- (void)addHeaderView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _searchTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        _isRefreshAgain = YES;
        
        //通过url来获得JSON数据
        NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/topics.json?" mutableCopy];
        [baseurl appendFormat:@"keys=%@",[_searchString URLEncodedString]];
        [baseurl appendFormat:@"&limit=30&start=%d", 0];
        //    if (token != nil) {
        //        [baseurl appendFormat:@"&token=%@", token];
        //    }
        
        NSURL *myurl = [NSURL URLWithString:baseurl];
        _request = [ASIFormDataRequest requestWithURL:myurl];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(GetResult:)];
        [_request setDidFailSelector:@selector(GetErr:)];
        [_request startAsynchronous];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        
    };
    
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    
    [header beginRefreshing];
    _headerView = header;
}

- (void)addFooterView
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _searchTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        _isRefreshAgain = NO;
        
        //通过url来获得JSON数据
        NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/topics.json?" mutableCopy];
        [baseurl appendFormat:@"keys=%@",[_searchString URLEncodedString]];
        [baseurl appendFormat:@"&limit=30&start=%d", [_searchTopicsArr count]];
        //    if (token != nil) {
        //        [baseurl appendFormat:@"&token=%@", token];
        //    }
        
        NSURL *myurl = [NSURL URLWithString:baseurl];
        _request = [ASIFormDataRequest requestWithURL:myurl];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(GetResult:)];
        [_request setDidFailSelector:@selector(GetErr:)];
        [_request startAsynchronous];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footerView = footer;
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
    
    NSArray * objects = [JsonParseEngine parseSearchTopics:dic];
    NSLog(@"%@",objects);
    
    if (_isRefreshAgain) {
        [self.searchTopicsArr removeAllObjects];
        [self.searchTopicsArr addObjectsFromArray:objects];
        
        [_searchTableView reloadData];
        [_headerView endRefreshing];
    }
    else{
        [self.searchTopicsArr addObjectsFromArray:objects];
        
        [_searchTableView reloadData];
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
    return [self.searchTopicsArr count];
    //NSLog(@"count %d",[self.allTopicsArr count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identi = @"TopTenTableViewCell";
    //第一次需要分配内存
    TopCell * cell = (TopCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    Topic * topic = [self.searchTopicsArr objectAtIndex:indexPath.row];
    cell.section = topic.board;
    cell.title = topic.title;
    cell.author = topic.author;
    cell.replies = topic.replies;
    
    [cell setReadyToShow];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int returnHeight;
    
    Topic * topic = [self.searchTopicsArr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size1 = [topic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    
    returnHeight = size1.height  + 61;
    
    return returnHeight;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectTopic = [self.searchTopicsArr objectAtIndex:indexPath.row];
    
    SingleTopicViewController *single = [[SingleTopicViewController alloc]init];
    [single setRootTopic:self.selectTopic];
    [self.navigationController pushViewController:single animated:YES];
    single = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
