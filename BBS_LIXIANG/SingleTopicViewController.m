//
//  SingleTopicViewController.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SingleTopicViewController.h"
#import "SingleTopicCell.h"
#import "CommentCell.h"

#import "ASIFormDataRequest.h"
#import "JsonParseEngine.h"

@interface SingleTopicViewController ()

@end

@implementation SingleTopicViewController

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

    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic" mutableCopy];
    [baseurl appendFormat:@"/%@",_rootTopic.board];
    [baseurl appendFormat:@"/%i.json?start=%i&limit=30",_rootTopic.ID,0];
    //通过url来获得JSON数据
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
    _singletopicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _singletopicTableView.dataSource = self;  //数据源代理
    _singletopicTableView.delegate = self;    //表视图委托
    [self.view addSubview:_singletopicTableView];
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
    
    NSArray * objects = [JsonParseEngine parseSingleTopic:dic];
    NSLog(@"%@",objects);
    
    self.topicsArray = [NSMutableArray arrayWithArray:objects];
    [_singletopicTableView reloadData];
    
}

#pragma mark - 数据源协议
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.topicsArray == nil) {
        return 0;
    }
    return [self.topicsArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        SingleTopicCell * cell = (SingleTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        cell.section = _rootTopic.board;
        cell.title = _rootTopic.title;
        cell.replies = _rootTopic.replies;
        [cell setReadyToShow];
        return cell;
    }
    else
    {
        CommentCell * cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        Topic * topic = [self.topicsArray objectAtIndex:indexPath.row-1];
        
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.num = indexPath.row;
        cell.content = topic.content;
        cell.attachments = topic.attachments;

        [cell setReadyToShow];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnHeight;
    if (indexPath.row == 0)
    {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize size1 = [_rootTopic.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
        
        returnHeight = size1.height  + 35;
    }
    else {
        Topic * topic = [self.topicsArray objectAtIndex:indexPath.row-1];
        
        UIFont *font = [UIFont systemFontOfSize:15.0];
        UIFont *font2 = [UIFont boldSystemFontOfSize:12.0];
        CGSize size1 = [topic.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
        CGSize size2 = [[NSString stringWithFormat:@"回复 %@：%@",topic.quoter, topic.quote] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font2} context:nil].size;
        
        returnHeight = size1.height + size2.height + 80;
    }
    return returnHeight;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showActionSheet];
}

-(void)showActionSheet
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                 initWithTitle:@"针对该话题"
                                 delegate:self
                                cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"回复", @"查看用户" ,nil];

    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
    }
    if(buttonIndex == 1)
    {
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
