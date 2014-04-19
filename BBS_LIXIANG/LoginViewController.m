//
//  LoginViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressHUD.h"
#import "JsonParseEngine.h"
#import "Toolkit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


-(void)dealloc
{
    _request =nil;
    _nameTextField = nil;
    _pwdTextField = nil;
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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)login:(id)sender {
    
    [_nameTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/token.json?" mutableCopy];
    [baseurl appendFormat:@"user=%@", _nameTextField.text];
    [baseurl appendFormat:@"&pass=%@",_pwdTextField.text];
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
}

- (IBAction)cancel:(id)sender {
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark asi Delegate
//ASI委托函数，错误处理
-(void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"error!");
    [ProgressHUD showSuccess:@"网络故障"];
}

//ASI委托函数，信息处理
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSLog(@"responseString = %@",request.responseString);
    
    NSDictionary *dic = [request.responseString objectFromJSONString];
    NSLog(@"dic %@",dic);
    if ([[dic objectForKey:@"success"] boolValue] == 1) {
        
        [Toolkit saveUserName:_nameTextField.text];
        [Toolkit saveID:[dic objectForKey:@"id"]];
        [Toolkit saveName:[dic objectForKey:@"name"]];
        [Toolkit saveToken:[dic objectForKey:@"token"]];
        
        [ProgressHUD showSuccess:@"登陆成功"];
        [_delegate loginSuccess];
        [self back:self];
    }
    else{
        
       [ProgressHUD showError:@"输入有误"];
    }
    
}
@end
