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

#import "ASIFormDataRequest.h"
#import "JsonParseEngine.h"


static int count;

@interface SingleTopicViewController ()

@property (nonatomic, strong) CommentCell *prototypeCell;

@end

@implementation SingleTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        count = 0;
        _isRequestToTopics = YES;
        _usersInfo = [[NSMutableArray alloc]init];
        
        self.prototypeCell = [self.singletopicTableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *browerButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(browerPicture:)];
    self.navigationItem.rightBarButtonItem = browerButton;
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic" mutableCopy];
    [baseurl appendFormat:@"/%@",_rootTopic.board];
    [baseurl appendFormat:@"/%i.json?start=%i&limit=10",_rootTopic.ID,0];
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

#pragma mark - Button Handlers
-(void)browerPicture:(id)sender{
    NSArray *urls = @[@"http://ww4.sinaimg.cn/thumbnail/7f8c1087gw1e9g06pc68ug20ag05y4qq.gif", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg", @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg", @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg", @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg", @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    
    int count = (int)urls.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        //photo.srcImageView = self.view.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 2; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
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
        
    NSArray * objects = [JsonParseEngine parseSingleTopic:dic];
    //NSLog(@"%@",objects);
        
    self.topicsArray = [NSMutableArray arrayWithArray:objects];

    //同步请求
    for ( ; count<[_topicsArray count]; count++) {
        Topic *topic = [_topicsArray objectAtIndex:count];
        NSString *str = [NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/user/%@.json",topic.author];
        NSURL *myurl = [NSURL URLWithString:str];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            //NSLog(@"reponse:%@",response);
            NSDictionary *dictionary = [response objectFromJSONString];
            [_usersInfo addObject:dictionary];
        }
    }
        
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
            cell.num = [NSString stringWithFormat:@"%i楼",indexPath.row -1];
        
        NSDictionary *dic = [self.usersInfo objectAtIndex:indexPath.row-1];
        NSDictionary *userDic = [dic objectForKey:@"user"];
        if ([[userDic objectForKey:@"gender"] isEqualToString:@"M"])
            cell.isMan = YES;
        else
            cell.isMan = NO;
        
        cell.name = [userDic objectForKey:@"name"];
        
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
        
        returnHeight = size1.height  + 35;
    }
    else {
        
        
//        CommentCell *cell = (CommentCell *)self.prototypeCell;
//        CGSize sieze = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        returnHeight = sieze.height + 1;
        Topic * topic = [self.topicsArray objectAtIndex:indexPath.row-1];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size1 = [topic.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        //楼主那一cell
        if (indexPath.row == 1) {
            if (topic.attachments != nil) {
                return returnHeight = size1.height + 80 + (180 * [[self getPicList:topic.attachments] count]);
            }
            return returnHeight = size1.height + 80;
        }
        
        NSDictionary *dic = [self.usersInfo objectAtIndex:indexPath.row-1];
        NSDictionary *userDic = [dic objectForKey:@"user"];
        NSString *name = [userDic objectForKey:@"name"];
        UIFont *font2 = [UIFont boldSystemFontOfSize:13.0];
        CGSize size2 = [[NSString stringWithFormat:@"【在%@(%@)的大作中提到:】\n : %@",topic.quoter,name, topic.quote] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 34, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font2} context:nil].size;
        
        if (topic.attachments != nil) {
            return returnHeight = size1.height + +size2.height + 80 + (180 * [[self getPicList:topic.attachments] count]);
        }
        returnHeight = size1.height + size2.height + 80;
    }
    return returnHeight;
}

//获取附件中的照片
-(NSArray *)getPicList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attUrl] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

#pragma -mark tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.row == 0) {
        return;
    }
    _oneUserInfo = [self.usersInfo objectAtIndex:indexPath.row-1];
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
        PostTopicViewController *postTopic = [[PostTopicViewController alloc]init];
      
        [self.navigationController pushViewController:postTopic animated:YES];
    }
    
    if(buttonIndex == 1)
    {
        UserInfoViewController *userInfor = [[UserInfoViewController alloc]init];
        userInfor.userDictionary = _oneUserInfo;
        [self presentPopupViewController:userInfor animationType:MJPopupViewAnimationSlideTopBottom];
    }
    
}

#pragma - SingleTopicCellDelegate
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
