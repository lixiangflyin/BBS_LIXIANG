//
//  TopTenViewController.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TopTenViewController.h"
#import "TopTenCell.h"
//#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"

@interface TopTenViewController ()

@end

@implementation TopTenViewController

- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
    [_headerView free];
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
	
    _tentopicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    _tentopicTableView.dataSource = self;  //数据源代理
    _tentopicTableView.delegate = self;    //表视图委托
    [self.view addSubview:_tentopicTableView];
    
    //下拉刷新
    [self addHeaderView];
    
}

//添加下拉刷新
- (void)addHeaderView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tentopicTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        //发送请求
        NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/hot/topten.json"];
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
    NSLog(@"dic %@",dic);

//    NSArray * objects = [JsonParseEngine parseSections:dic];
//    
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    
//    for (int i=0; i<[objects count]; i++) {
//        
//        Board *dict = [objects objectAtIndex:i];
//        NSArray *sectionArr = dict.sectionBoards;
//        NSMutableArray *arr1 = [[NSMutableArray alloc]init];
//        for (int j=0; j<[sectionArr count]; j++) {
//            
//            Board *board = [sectionArr objectAtIndex:j];
//            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:board.name,@"sectionName",board.description,@"description", nil];
//            [arr1 addObject:dic1];
//        }
//        [array addObject:arr1];
//    }
//    
//    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString*path=[paths objectAtIndex:0];
//    NSString *filename= [path stringByAppendingPathComponent:@"sections_info.plist"];
//    
//    [array writeToFile:filename  atomically:YES];
    
    NSArray * objects = [JsonParseEngine parseTopics:dic];
    NSLog(@"%@",objects);
    
    [self.tentopicsArr removeAllObjects];
    self.tentopicsArr = [NSMutableArray arrayWithArray:objects];
    
    // 刷新表格
    [_tentopicTableView reloadData];
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
    return [self.tentopicsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * identi = @"TopTenTableViewCell";
    //第一次需要分配内存
    TopTenCell * cell = (TopTenCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
        
    Topic * topic = [self.tentopicsArr objectAtIndex:indexPath.row];
    cell.section = topic.board;
    cell.title = topic.title;
        
    [cell setReadyToShow];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int returnHeight;
    
    Topic * topic = [self.tentopicsArr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size1 = [topic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    
    returnHeight = size1.height  + 35;
    
    return returnHeight;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectTopic = [self.tentopicsArr objectAtIndex:indexPath.row];
    
    [_delegate pushToNextViewWithValue:self.selectTopic];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
