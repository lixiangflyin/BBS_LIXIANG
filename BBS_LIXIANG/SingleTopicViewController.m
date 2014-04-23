//
//  SingleTopicViewController.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SingleTopicViewController.h"
#import "UserInfoViewController.h"
#import "PostTopicViewController.h"
#import "SingleTopicCell.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "JsonParseEngine.h"
#import "MJRefresh.h"
#import "ProgressHUD.h"
#import "Toolkit.h"

#define EDITTOPIC     200
#define REPLYTOPIC    201

static int count;

@interface SingleTopicViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    BOOL _isRefreshAgain;
}

@end

@implementation SingleTopicViewController

-(void)dealloc
{
    [_headerView free];
    [_footerView free];
    _singletopicTableView = nil;
    _topicsArray = nil;
    _usersInfo = nil;
    _rootTopic = nil;
    //_request = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        count = 0;
        _isRequestToTopics = YES;
        _topicsArray = [[NSMutableArray alloc]init];
        _usersInfo = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"阅读文章";
    
//    //自制ui
//    UIImage* image= [UIImage imageNamed:@"t2.png"];
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
//                                   initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    _singletopicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _singletopicTableView.dataSource = self;  //数据源代理
    _singletopicTableView.delegate = self;    //表视图委托
    _singletopicTableView.separatorStyle = NO;
    [self.view addSubview:_singletopicTableView];
    
    //刷新和加载更多
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.singletopicTableView;
    header.delegate = self;
    // 自动刷新
    [header beginRefreshing];
    _headerView = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.singletopicTableView;
    footer.delegate = self;
    _footerView = footer;

}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic" mutableCopy];
    [baseurl appendFormat:@"/%@",_rootTopic.board];
    //判断是否是刷新还是加载更多
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        
        _isRefreshAgain = YES;
        [baseurl appendFormat:@"/%i.json?start=%i&limit=10",_rootTopic.ID,0];
        
    } else {
        
        _isRefreshAgain = NO;
        [baseurl appendFormat:@"/%i.json?start=%i&limit=10",_rootTopic.ID,(int)[_topicsArray count]];
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        
        NSArray * objects = [JsonParseEngine parseSingleTopic:dic];
        
        if (_isRefreshAgain) {
            //获取信息的记录,重新置0
            count = 0;
            
            [self.topicsArray removeAllObjects];
            [self.usersInfo removeAllObjects];
            
            [self.topicsArray addObjectsFromArray:objects];
        }
        else{
            [self.topicsArray addObjectsFromArray:objects];
        }
        
        //同步请求,其用户信息 可以用afnetworking
        for ( ; count<[_topicsArray count]; count++) {
            Topic *topic = [_topicsArray objectAtIndex:count];
            NSString *str = [NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/user/%@.json",topic.author];
            NSURL *myurl = [NSURL URLWithString:str];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
            [request startSynchronous];
            NSError *error = [request error];
            if (!error) {
                
                NSString *response = [request responseString];
                
                NSDictionary *dictionary = [response objectFromJSONString];
                
                User *user = [JsonParseEngine parseUserInfo:dictionary];
                [_usersInfo addObject:user];
            }
            
            //NSLog(@"usersInfo: %@",_usersInfo);
            request = nil;
        }
        
        [_singletopicTableView reloadData];
        
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error!");
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        [ProgressHUD showError:@"网络故障"];
    }];
    
//    //通过url来获得JSON数据
//    NSURL *myurl = [NSURL URLWithString:baseurl];
//    _request = [ASIFormDataRequest requestWithURL:myurl];
//    [_request setDelegate:self];
//    [_request setDidFinishSelector:@selector(GetResult:)];
//    [_request setDidFailSelector:@selector(GetErr:)];
//    [_request startAsynchronous];
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
    [_footerView endRefreshing];
    [ProgressHUD showError:@"网络连接有问题"];
}

//ASI委托函数，信息处理
//-(void) GetResult:(ASIHTTPRequest *)request
//{
//
//    NSDictionary *dic = [request.responseString objectFromJSONString];
//        
//    NSArray * objects = [JsonParseEngine parseSingleTopic:dic];
//    
//    if (_isRefreshAgain) {
//        //获取信息的记录,重新置0
//        count = 0;
//        
//        [self.topicsArray removeAllObjects];
//        [self.usersInfo removeAllObjects];
//        
//        [self.topicsArray addObjectsFromArray:objects];
//    }
//    else{
//        [self.topicsArray addObjectsFromArray:objects];
//    }
//
//    //同步请求,其用户信息
//    for ( ; count<[_topicsArray count]; count++) {
//        Topic *topic = [_topicsArray objectAtIndex:count];
//        NSString *str = [NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/user/%@.json",topic.author];
//        NSURL *myurl = [NSURL URLWithString:str];
//        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
//        [request startSynchronous];
//        NSError *error = [request error];
//        if (!error) {
//            
//            NSString *response = [request responseString];
//    
//            NSDictionary *dictionary = [response objectFromJSONString];
//            [_usersInfo addObject:dictionary];
//        }
//        
//        request = nil;
//    }
//        
//    [_singletopicTableView reloadData];
//    
//    [_headerView endRefreshing];
//    [_footerView endRefreshing];
//
//    
//}

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
    return [self.topicsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        SingleTopicCell * cell = (SingleTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:UIColorFromRGB(0xF1F1F1)];
        }
        
        
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
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addTapToImageView];
            
            [cell setBackgroundColor:UIColorFromRGB(0xF1F1F1)];
        }
        
        Topic * topic = [self.topicsArray objectAtIndex:indexPath.row-1];
        
        cell.delegate = self;
        cell.indexRow = indexPath.row;
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.content = topic.content;
        cell.attachments = topic.attachments;
        
        if (indexPath.row == 1) {
            cell.num = @"楼主";
        }
        else if(indexPath.row == 2){
            cell.num = @"沙发";
        }
        else if(indexPath.row == 3){
            cell.num = @"板凳";
        }
        else
            cell.num = [NSString stringWithFormat:@"%d楼",(int)indexPath.row -1];
        
        User *user = [self.usersInfo objectAtIndex:indexPath.row-1];

        if ([user.gender isEqualToString:@"M"])
            cell.isMan = YES;
        else
            cell.isMan = NO;
        
        cell.headPhotoUrl = user.avatar;
        NSLog(@"photo url: %@",cell.headPhotoUrl);
        
        cell.name = user.name;
        
        //楼主特殊
        if (indexPath.row == 1){
            [cell setReadyToShowOne];
            return cell;
        }
        
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
        
        returnHeight = size1.height  + 39;
    }
    else {
        
        
//        CommentCell *cell = (CommentCell *)self.prototypeCell;
//        CGSize sieze = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        returnHeight = sieze.height + 1;
        Topic * topic = [self.topicsArray objectAtIndex:indexPath.row-1];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size1 = [topic.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 35, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        paragraphStyle = nil;
        
        //楼主那一cell
        if (indexPath.row == 1) {
            if (topic.attachments != nil) {
                return returnHeight = size1.height + 80 + (180 * [[self getPicList:topic.attachments] count] + 30);
            }
            return returnHeight = size1.height + 80 + 30;
        }
        
        User *user = [self.usersInfo objectAtIndex:indexPath.row-1];
        NSString *name = user.name;
        UIFont *font2 = [UIFont boldSystemFontOfSize:13.0];
        CGSize size2 = [[NSString stringWithFormat:@"【在%@(%@)的大作中提到:】\n : %@",topic.quoter,name, topic.quote] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 34, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font2} context:nil].size;
        
        if (topic.attachments != nil) {
            return returnHeight = size1.height + +size2.height + 80 + (180 * [[self getPicList:topic.attachments] count] + 30);
        }
        returnHeight = size1.height + size2.height + 80 + 30;
    }
    return returnHeight;
}

#pragma -mark 获取附件中的照片
-(NSArray *)getPicList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attUrl] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"] )
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}

#pragma -mark SingleTopicCellDelegate
-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum
{
    //由于特殊原因 主题对象需要在行减一处理 indexRow-1
    Topic * topic = [_topicsArray objectAtIndex:indexRow-1];
    NSArray * picArray = [self getPicList:topic.attachments];
    
    int count = (int)[picArray count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        Attachment *attachment = picArray[i];
        // 替换为中等尺寸图片
        NSString *url = [attachment.attUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        //photo.srcImageView = self.view.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexNum; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum
{
}

-(void)tapHeadPhoto:(int)indexRow
{
    UserInfoViewController *userInfor = [[UserInfoViewController alloc]init];
    userInfor.user = self.usersInfo[indexRow-1];
    [self presentPopupViewController:userInfor animationType:MJPopupViewAnimationSlideTopBottom];
}

-(void)replyTheTopic:(int)indexRow ButtonNum:(int)buttonNum
{
    if([Toolkit getUserName] == nil){
        [ProgressHUD showError:@"请先登录"];
        return;
    }
    
    PostTopicViewController *postTopic = [[PostTopicViewController alloc]init];
    
    switch (buttonNum) {
        case EDITTOPIC:
            [postTopic setPostType:2];  //修改帖子
            break;
        case REPLYTOPIC:
            [postTopic setPostType:1];  //发表对自己或对别人的跟帖
            break;
        default:
            break;
    }
    
    //各楼的帖子
    [postTopic setRootTopic:self.topicsArray[indexRow-1]];
    [self.navigationController pushViewController:postTopic animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
