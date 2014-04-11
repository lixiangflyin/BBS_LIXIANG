//
//  SingleBoardViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SingleBoardViewController.h"
#import "SingleTopicViewController.h"
#import "PostTopicViewController.h"
#import "BoardTopicCell.h"
//#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"

@interface SingleBoardViewController ()

@end

@implementation SingleBoardViewController

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
    
    self.title = _requestBoard.name;
    
    UIBarButtonItem *newTopicButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postNewTopic:)];
    self.navigationItem.rightBarButtonItem = newTopicButton;
	
    //通过url来获得JSON数据
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/" mutableCopy];
    [baseurl appendFormat:@"board/%@.json?", _requestBoard.name];
    [baseurl appendFormat:@"mode=%d&limit=30&start=%i", 2,0];
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
    
    _singleSectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _singleSectionTableView.dataSource = self;  //数据源代理
    _singleSectionTableView.delegate = self;    //表视图委托
    [self.view addSubview:_singleSectionTableView];
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
    
    NSArray * objects = [JsonParseEngine parseTopics:dic];
    NSLog(@"%@",objects);
    
    self.singleSectionArr = [NSMutableArray arrayWithArray:objects];
    [_singleSectionTableView reloadData];
    
}

#pragma mark - 数据源协议
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.singleSectionArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identi = @"BoardTopicCell";
    //第一次需要分配内存
    BoardTopicCell * cell = (BoardTopicCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BoardTopicCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    Topic * topic = [self.singleSectionArr objectAtIndex:indexPath.row];
    cell.time = topic.time;
    cell.title = topic.title;
    cell.author = topic.author;
    cell.replies = topic.replies;
    
    [cell setReadyToShow];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
    
    int returnHeight;
    
    Topic * topic = [self.singleSectionArr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size1 = [topic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    
    returnHeight = size1.height  + 40;
    
    return returnHeight;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectTopic = [self.singleSectionArr objectAtIndex:indexPath.row];
    
    SingleTopicViewController *single = [[SingleTopicViewController alloc]init];
    
    [single setRootTopic:self.selectTopic];
    
    [self.navigationController pushViewController:single animated:YES];
    
    single = nil;
}

#pragma -mark 触发发送新话题
-(void)postNewTopic:(id)sender
{
    PostTopicViewController *postTopic = [[PostTopicViewController alloc]init];
    //[self presentViewController:postTopic animated:YES completion:Nil];
    [self.navigationController pushViewController:postTopic animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
