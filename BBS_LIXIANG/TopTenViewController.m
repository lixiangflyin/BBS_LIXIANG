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
    
    NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/hot/topten.json"];
    
    //NSURL *myurl = [NSURL URLWithString:@"http://bbs.seu.edu.cn/api/sections.json?"];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
    
    
    _tentopicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    _tentopicTableView.dataSource = self;  //数据源代理
    _tentopicTableView.delegate = self;    //表视图委托
    [self.view addSubview:_tentopicTableView];
    
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
    
    self.tentopicsArr = [NSMutableArray arrayWithArray:objects];
    [_tentopicTableView reloadData];
    
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
