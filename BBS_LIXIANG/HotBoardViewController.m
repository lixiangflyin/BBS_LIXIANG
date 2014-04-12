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
    
    //通过url来获得JSON数据
    
    NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/hot/boards.json"];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
    _hotBoardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    _hotBoardTableView.dataSource = self;  //数据源代理
    _hotBoardTableView.delegate = self;    //表视图委托
    [self.view addSubview:_hotBoardTableView];
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
    
    NSArray * objects = [JsonParseEngine parseBoards:dic];
    NSLog(@"%@",objects);
    
    self.hotBoardArr = [NSMutableArray arrayWithArray:objects];
    [_hotBoardTableView reloadData];
    
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
