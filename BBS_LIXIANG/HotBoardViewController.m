//
//  HotBoardViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "HotBoardViewController.h"
#import "SingleBoardViewController.h"
#import "HotBoardCell.h"

#import "JsonParseEngine.h"
#import "ProgressHUD.h"

@interface HotBoardViewController ()

@end

@implementation HotBoardViewController

-(void)dealloc
{
    _hotBoardTableView = nil;
    _request = nil;
    _headerView = nil;
    _hotBoardArr = nil;
    _selectBoard = nil;
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
    
    _hotBoardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    _hotBoardTableView.dataSource = self;  //数据源代理
    _hotBoardTableView.delegate = self;    //表视图委托
    _hotBoardTableView.separatorStyle = NO;
    [self.view addSubview:_hotBoardTableView];
    
    //下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.hotBoardTableView;
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
    NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/hot/boards.json"];
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
    
    NSArray * objects = [JsonParseEngine parseBoards:dic];
    
    [self.hotBoardArr removeAllObjects];
    self.hotBoardArr = [NSMutableArray arrayWithArray:objects];
    
    [_hotBoardTableView reloadData];
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
    return [self.hotBoardArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identi = @"HotBoardCell";
    //第一次需要分配内存
    HotBoardCell * cell = (HotBoardCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"HotBoardCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        [cell setBackgroundColor:UIColorFromRGB(0xD1EEFC)];
    }
    
    Board * b = [self.hotBoardArr objectAtIndex:indexPath.row];
    cell.nameLabel.text = b.name;
    cell.descriptionLabel.text = b.description;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 63;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectBoard = [self.hotBoardArr objectAtIndex:indexPath.row];
    
    [_delegate pushToNextSingleSectionViewWithValue:self.selectBoard.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
