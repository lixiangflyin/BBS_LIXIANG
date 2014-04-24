//
//  SingleMailViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SingleMailViewController.h"
#import "PostMailViewController.h"

#import "JsonParseEngine.h"
#import "Toolkit.h"
#import "ProgressHUD.h"

@interface SingleMailViewController ()

@end

@implementation SingleMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    _authorLabel = nil;
    _timeLabel = nil;
    _titleLabel = nil;
    _contentLabel = nil;
    _scollView = nil;
    _realView = nil;
    _mail = nil;
    _rootMail = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //屏幕大小适配
    CGSize size_screen = [[UIScreen mainScreen]bounds].size;
    [self.view setFrame:CGRectMake(0, 0, size_screen.width, size_screen.height)];
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(reply:)];
    self.navigationItem.rightBarButtonItem = replyButton;
    replyButton = nil;
    
    //全置空
    [_titleLabel setText:nil];
    [_contentLabel setText:nil];
    [_timeLabel setText:nil];
    
    [self firstLoadData];
    
}

-(void)firstLoadData
{
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",[Toolkit getToken]];
    [baseurl appendFormat:@"&type=%i",_rootMail.type];
    [baseurl appendFormat:@"&id=%i",_rootMail.ID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        _mail = [JsonParseEngine parseSingleMail:dic Type:_rootMail.type];
        
        if (_mail.type == 0)
            [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
        if (_mail.type == 1)
            [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
        if (_mail.type == 2)
            [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
        
        [_titleLabel setText:_mail.title];
        [_contentLabel setText:_mail.content];
        [_timeLabel setText:[JsonParseEngine dateToString:_mail.time]];
        
        [_scollView addSubview:_realView];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:16.0];
        CGSize size = [_mail.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, self.view.frame.size.width - 40, size.height)];
        
        [_realView setFrame:CGRectMake(0, 0, self.view.frame.size.width, _contentLabel.frame.origin.y + size.height)];
        [_scollView setContentSize:CGSizeMake(self.view.frame.size.width, _contentLabel.frame.origin.y + size.height+ 10 + 64 + 80)];
        if (_contentLabel.frame.origin.y + size.height + 10 <= self.view.frame.size.height) {
            [_scollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 20)];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
        [ProgressHUD showSuccess:@"网络故障"];
    }];
}

#pragma -mark 回复邮件
-(void)reply:(id)sender
{
    //发邮件
    PostMailViewController *postMailVC = [[PostMailViewController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:postMailVC];
    postMailVC.rootMail = _mail;
    postMailVC.postType = 1;
    
    navVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navVC animated:YES completion:nil];
    //[self.navigationController pushViewController:postMailVC animated:YES];
    postMailVC = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
