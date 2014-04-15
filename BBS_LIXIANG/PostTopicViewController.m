//
//  PostTopicViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PostTopicViewController.h"
#import "seekImageView.h"
#import "JsonParseEngine.h"
#import "Toolkit.h"
#import "WBUtil.h"

#define XLoc  70
#define YLoc  70

@interface PostTopicViewController ()

@end

@implementation PostTopicViewController

-(void)dealloc
{
    _picArray = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _picArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"root content %@",_rootTopic.content);
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postTopic:)];
    self.navigationItem.rightBarButtonItem = replyButton;
    replyButton = nil;
    
    if (_postType == 0) {
        self.title = @"发新帖";
        [_postTypeLabel setText:@"新帖:"];
        [_postContentView setText:@""];
    }
    if (_postType == 1) {
        self.title = @"回帖";
        [_postTypeLabel setText:@"回帖:"];
        [_postTitleLabel setText:_rootTopic.title];
        [_postContentView setText:@""];

    }
    
    if (_postType == 2) {
        self.title = @"修改帖子";
        [_postTypeLabel setText:@"修改:"];
        [_postTitleLabel setText:_rootTopic.title];
        [_postContentView setText:_rootTopic.content];
    }
    
    
}

#pragma -mark 发送帖子（修改，发新帖，回复）
-(void)postTopic:(id)sender
{
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/post.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",[Toolkit getToken]];
    [baseurl appendFormat:@"&board=%@",_boardName];
    [baseurl appendFormat:@"&title=%@",[_postTitleLabel.text URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[_postContentView.text URLEncodedString]];
    
    if (_postType == 0) {
        [baseurl appendFormat:@"&reid=%i",0]; //新帖阅读数为0
    }
    if (_postType == 1) {
        [baseurl appendFormat:@"&reid=%i",_rootTopic.read];
    }
    if (_postType == 2) {
        [baseurl appendFormat:@"&reid=%i",_rootTopic.read];
    }
    [baseurl appendFormat:@"&type=%i",3];
    
    //通过url来获得JSON数据
    NSURL *myurl = [NSURL URLWithString:baseurl];
    _request = [ASIFormDataRequest requestWithURL:myurl];
    [_request setDelegate:self];
    [_request setDidFinishSelector:@selector(GetResult:)];
    [_request setDidFailSelector:@selector(GetErr:)];
    [_request startAsynchronous];
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
    
    //同步请求,其用户信息

    
}

#pragma -mark 获取上传图片
- (IBAction)getPostPicture:(id)sender {
    
    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"立刻拍照",@"相册选择",nil];
    //cameraSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [cameraSheet showInView:self.view];
    cameraSheet = nil;
}

#pragma action delegate
//******************************************
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
            imagePicker = nil;

		} else {
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
		}
	} else if (buttonIndex == 1) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.allowsEditing = YES;
		
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
			imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
		
		else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            
			imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
		
		else{
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated: YES];
            
		}
        imagePicker = nil;
	}
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  {

    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    
    //二进制流数据
    NSData *pngData = UIImagePNGRepresentation(selectedImage);
    [_picArray  addObject:pngData];
    
    int len = 0;
    
    @try {
        len = (int)[_picArray count];
    }
    @catch (NSException *exception) {
        NSLog(@"has exceptions");
    }
    @finally {
        
        for(int i = 0; i < len; i++)
        {
            
            seekImageView *imgView = [[seekImageView alloc] initWithFrame:CGRectMake(XLoc*i +35, 3, XLoc, YLoc)];
            [imgView setImage:[UIImage imageWithData:[_picArray objectAtIndex:i]]];
            [_pictureScrollView addSubview:imgView];
            [_pictureScrollView setContentSize:CGSizeMake(XLoc*i+100, YLoc)];
        }
    }
    
    // NSLog(@"the content of pic array == %@", [picArray description]);
    
    [picker dismissModalViewControllerAnimated:YES];
    
}
@end
