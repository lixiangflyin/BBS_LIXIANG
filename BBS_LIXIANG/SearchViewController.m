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
#import "SearchTopicCell.h"
#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"
#import "MJRefresh.h"

#import "WBUtil.h"   //格式转换

@interface SearchViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    BOOL _isRefreshAgain;
}

@end

@implementation SearchViewController

-(void)dealloc
{
    [_headerView free];
    [_footerView free];
    _searchTableView = nil;
    _searchTopicsArr = nil;
    _searchString = nil;
    _selectTopic = nil;
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
    
    //屏幕大小适配
    CGSize size_screen = [[UIScreen mainScreen]bounds].size;
    [self.view setFrame:CGRectMake(0, 0, size_screen.width, size_screen.height)];
    
    self.title = @"搜索结果";
    
    _searchTopicsArr = [[NSMutableArray alloc]init];
    
    UIImage* image= [UIImage imageNamed:@"t1.png"];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _searchTableView.dataSource = self;  //数据源代理
    _searchTableView.delegate = self;    //表视图委托
    _searchTableView.separatorStyle = NO;
    [self.view addSubview:_searchTableView];
    
    //刷新和加载更多
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.searchTableView;
    header.delegate = self;
    // 自动刷新
    [header beginRefreshing];
    _headerView = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.searchTableView;
    footer.delegate = self;
    _footerView = footer;
}

//重新加载视图
-(void)reloadSearchView
{
    [self refreshViewBeginRefreshing:_headerView];
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    //通过url来获得JSON数据
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/topics.json?" mutableCopy];
    [baseurl appendFormat:@"keys=%@",[_searchString URLEncodedString]];
    
    //判断是否是刷新还是加载更多
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        
        _isRefreshAgain = YES;
        [baseurl appendFormat:@"&limit=30&start=%d", 0];
        
    } else {
        
        _isRefreshAgain = NO;
        [baseurl appendFormat:@"&limit=30&start=%d", (int)[_searchTopicsArr count]];
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        
        NSArray * objects = [JsonParseEngine parseSearchTopics:dic];
        
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
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        [ProgressHUD showError:@"网络故障"];
    }];
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
    
    static NSString * identi = @"SearchTopicCell";
    //第一次需要分配内存
    SearchTopicCell * cell = (SearchTopicCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SearchTopicCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        [cell setBackgroundColor:UIColorFromRGB(0xF1F1F1)];
    }
    
    Topic * topic = [self.searchTopicsArr objectAtIndex:indexPath.row];
    cell.section = topic.board;
    cell.title = topic.title;
    cell.author = topic.author;
    
    [cell setReadyToShow];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int returnHeight;
    
    Topic * topic = [self.searchTopicsArr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size1 = [topic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    
    returnHeight = size1.height  + 49;
    
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
