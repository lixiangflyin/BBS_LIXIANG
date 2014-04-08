//
//  AllSectionTopViewController.m
//  SBBS_xiang
//
//  Created by apple on 14-4-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "AllSectionTopViewController.h"
#import "SingleTopicViewController.h"
#import "TopCell.h"
//#import "ProgressHUD.h"
#import "JSONKit.h"
#import "JsonParseEngine.h"

@interface AllSectionTopViewController ()

@end

@implementation AllSectionTopViewController

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
    NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/hot/topics.json"];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
    
    _allTopicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _allTopicTableView.dataSource = self;  //数据源代理
    _allTopicTableView.delegate = self;    //表视图委托
    [self.view addSubview:_allTopicTableView];
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
    
    NSArray * objects = [JsonParseEngine parseSectionsTopics:dic];
    NSLog(@"%@",objects);
    
    self.allTopicsArr = [NSMutableArray arrayWithArray:objects];

    [_allTopicTableView reloadData];
    
}

#pragma mark - 数据源协议
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allTopicsArr count];
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
    
    Topic * topic = [self.allTopicsArr objectAtIndex:indexPath.row];
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
    
    Topic * topic = [self.allTopicsArr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size1 = [topic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    
    returnHeight = size1.height  + 61;
    
    return returnHeight;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectTopic = [self.allTopicsArr objectAtIndex:indexPath.row];
    
    [_delegate pushToNextViewWithValue:self.selectTopic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
