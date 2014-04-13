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

@interface HotBoardViewController ()

@end

@implementation HotBoardViewController

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
    
    _hotBoardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    _hotBoardTableView.dataSource = self;  //数据源代理
    _hotBoardTableView.delegate = self;    //表视图委托
    [self.view addSubview:_hotBoardTableView];
    
    
    //下拉刷新
    [self addHeaderView];
}

- (void)addHeaderView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _hotBoardTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        //通过url来获得JSON数据
        NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/hot/boards.json"];
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
    //NSLog(@"dic %@",dic);
    
    NSArray * objects = [JsonParseEngine parseBoards:dic];
    //NSLog(@"%@",objects);
    
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
    }
    
    Board * b = [self.hotBoardArr objectAtIndex:indexPath.row];
    cell.nameLabel.text = b.name;
    cell.descriptionLabel.text = b.description;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 58;
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
