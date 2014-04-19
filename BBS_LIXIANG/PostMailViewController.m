//
//  PostMailViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PostMailViewController.h"
#import "ASIFormDataRequest.h"
#import "ProgressHUD.h"
#import "Toolkit.h"
#import "JsonParseEngine.h"
#import "WBUtil.h"

@interface PostMailViewController ()

@end

@implementation PostMailViewController


-(void)dealloc
{
    _postContent = nil;
    _postScrollView = nil;
    _postTitle = nil;
    _postUser = nil;
    _rootMail = nil;
    _sentToUser = nil;
    
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
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    
    _postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _postScrollView.contentSize = CGSizeMake(rect.size.width, self.view.frame.size.height - 64 + 1);
    _postScrollView.delegate = self;
    
    UILabel * userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+5, 40, 21)];
    userLabel.textColor = [UIColor whiteColor];
    userLabel.backgroundColor = [UIColor lightGrayColor];
    userLabel.font = [UIFont systemFontOfSize:15];
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.text = @"发给";
    _postUser = [[UITextField alloc] initWithFrame:CGRectMake(60, 5+5, 205, 21)];
    _postUser.textColor = [UIColor lightGrayColor];
    _postUser.placeholder = @"添加收件人";

    [_postScrollView addSubview:userLabel];
    [_postScrollView addSubview:_postUser];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30+5, 40, 21)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    _postTitle = [[UITextField alloc] initWithFrame:CGRectMake(60, 30+5, 205, 21)];
    _postTitle.textColor = [UIColor lightGrayColor];
    _postTitle.placeholder = @"添加标题";
 
    _postContent = [[UITextView alloc] initWithFrame:CGRectMake(5, 55+5, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 55-5)];
    [_postContent setFont:[UIFont systemFontOfSize:17]];
    [_postScrollView addSubview:titleLabel];
    [_postScrollView addSubview:_postTitle];
    [_postScrollView addSubview:_postContent];
    [self.view addSubview:_postScrollView];
    
    if (_postType == 0) {
        self.title = @"发新邮件";
        [_postUser setText:@""];
        [_postUser becomeFirstResponder];
        //[_sendButton setEnabled:NO];
        [_postTitle setText:@""];
        [_postContent setText:@""];
    }
    if (_postType == 1) {
        self.title = @"回复邮件";
        [_postUser setText:_rootMail.author];
        [_postUser setEnabled:NO];
        
        if ([_rootMail.title length] >=4 && [[_rootMail.title substringToIndex:4] isEqualToString:@"Re: "]) {
            [_postTitle setText:[NSString stringWithFormat:@"%@", _rootMail.title]];
        }
        else {
            [_postTitle setText:[NSString stringWithFormat:@"Re: %@", _rootMail.title]];
        }
        
        [_postContent setText:@""];
        [_postContent becomeFirstResponder];
   
    }
    if (_postType == 2) {
        self.title = @"发新邮件";
        [_postUser setText:_sentToUser];
        [_postUser setEnabled:NO];
        [_postTitle becomeFirstResponder];
        [_postTitle setText:@""];
        [_postContent setText:@""];
        [_postTitle becomeFirstResponder];
        //[sendButton setEnabled:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_postUser resignFirstResponder];
    [_postTitle resignFirstResponder];
    [_postContent resignFirstResponder];
}

#pragma -mark button
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMail:(id)sender {
    
    //发送情况
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/send.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",[Toolkit getToken]];
    [baseurl appendFormat:@"&user=%@",_postUser.text];
    [baseurl appendFormat:@"&title=%@",_postTitle.text];
    [baseurl appendFormat:@"&content=%@",[_postContent.text URLEncodedString]];
    if (_rootMail == nil) {
        [baseurl appendFormat:@"&reid=%i",0];
        
    }else{
        [baseurl appendFormat:@"&reid=%i",_rootMail.ID];
    }
    
    //同步
    NSURL *myurl = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:myurl];
    
    [_request startSynchronous];
    
    NSError *error = [_request error];
    if (!error) {
        
        NSString *response = [_request responseString];
        
        NSDictionary *dictionary = [response objectFromJSONString];
        
        BOOL success = [[dictionary objectForKey:@"success"] boolValue];
        
        if (success) {
            [ProgressHUD showSuccess:@"发送成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [ProgressHUD showError:@"发送失败"];
        }
    }
    else{
        [ProgressHUD showError:@"网络故障"];
    }
    
    _request = nil;

}





#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    
    [_postScrollView setContentOffset:CGPointMake(0, 0)];
    [_postContent setFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 55 - keyboardRect.size.height - 2)];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (_postContent.contentSize.height < self.view.frame.size.height - 64 - 55) {
        [_postContent setFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 55)];
    }
    else
    {
        [_postContent setFrame:CGRectMake(5, 55, self.view.frame.size.width - 10, _postContent.contentSize.height)];
        [_postScrollView setContentSize:CGSizeMake(_postScrollView.contentSize.width, _postContent.contentSize.height + 55)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
