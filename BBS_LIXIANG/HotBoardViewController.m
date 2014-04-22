//
//  HotBoardViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "HotBoardViewController.h"
#import "SingleBoardViewController.h"
#import "BoardCell.h"

#import "JsonParseEngine.h"
#import "ProgressHUD.h"

@interface HotBoardViewController ()

@end

@implementation HotBoardViewController

-(void)dealloc
{
    _hotBoardTableView = nil;
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
    
    _pictureArr = @[@"home.png",@"amuse.png",@"fasion.png",@"science.png",@"art.png",@"society.png",@"game.png",@"art.png",@"fasion.png",@"game.png",@"fasion.png",@"art.png"];
    
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://bbs.seu.edu.cn/api/hot/boards.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        
        NSArray * objects = [JsonParseEngine parseBoards:dic];
        
        [self.hotBoardArr removeAllObjects];
        self.hotBoardArr = [NSMutableArray arrayWithArray:objects];
        
        [_hotBoardTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_headerView endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
        [_headerView endRefreshing];
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
    
    static NSString * identi = @"BoardCell";
    //第一次需要分配内存
    BoardCell * cell = (BoardCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BoardCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        [cell setBackgroundColor:UIColorFromRGB(0xF1F1F1)];
    }
    
    Board * b = [self.hotBoardArr objectAtIndex:indexPath.row];
    
    [cell.boardLabel setText:b.description];
    
    int randomNum = arc4random_uniform(12);
    [cell.titleImageView setImage:[UIImage imageNamed:_pictureArr[randomNum]]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
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
