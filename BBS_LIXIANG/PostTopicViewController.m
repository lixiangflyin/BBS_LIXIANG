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

#import "ProgressHUD.h"

static NSString *TMP_UPLOAD_IMG_PATH = @"";

#define XLoc  70
#define YLoc  70

@interface PostTopicViewController ()

@end

@implementation PostTopicViewController

-(void)dealloc
{
    _picArray = nil;
    _postTypeLabel = nil;
    _postTitleField = nil;
    _postContentView = nil;
    _pictureScrollView = nil;
    _rootTopic = nil;
    _boardName = nil;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _picArray = [[NSMutableArray alloc]init];
        _picNameArr = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"root content %@",_rootTopic.content);
    
    //屏幕大小适配
    CGSize size_screen = [[UIScreen mainScreen]bounds].size;
    [self.view setFrame:CGRectMake(0, 0, size_screen.width, size_screen.height)];
    
    UIBarButtonItem *replyButton =[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(postTopic:)];
    self.navigationItem.rightBarButtonItem = replyButton;
    replyButton = nil;
    
    //设置圆角
    _postContentView.layer.cornerRadius = 8;
    _postContentView.layer.borderWidth = 0.8;
    [_postContentView setText:@"请输入内容:"];
    
    if (_postType == 0) {
        self.title = @"发新帖";
        [_postTypeLabel setText:@"标题:"];
        [_postTitleField setPlaceholder:@"请输入话题"];
        [_postTitleField setText:@""];
        [_postContentView setText:@""];
    }
    if (_postType == 1) {
        self.title = @"回帖";
        [_postTypeLabel setText:@"回复:"];
        if ([_rootTopic.title length] >=4 && [[_rootTopic.title substringToIndex:4] isEqualToString:@"Re: "]) {
            [_postTitleField setText:[NSString stringWithFormat:@"%@", _rootTopic.title]];
        }
        else {
            [_postTitleField setText:[NSString stringWithFormat:@"Re: %@", _rootTopic.title]];
        }
        [_postContentView setText:@""];

    }
    
    if (_postType == 2) {
        self.title = @"修改帖子";
        [_postTypeLabel setText:@"修改:"];
        [_postTitleField setText:_rootTopic.title];
        [_postContentView setText:_rootTopic.content];
    }
    
    
}

#pragma -mark 发送帖子（修改，发新帖，回复）
-(void)postTopic:(id)sender
{
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/post.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",[Toolkit getToken]];
    
    if (_boardName == nil) {
        [baseurl appendFormat:@"&board=%@",_rootTopic.board];  //回帖和修改获得的
    }
    else{
        [baseurl appendFormat:@"&board=%@",_boardName];     //版面发新帖获得的
    }
    
    [baseurl appendFormat:@"&title=%@",[_postTitleField.text URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[_postContentView.text URLEncodedString]];
    
    if (_postType == 0) {
        [baseurl appendFormat:@"&reid=%i",0]; //新帖阅读数为0
    }
    if (_postType == 1) {
        [baseurl appendFormat:@"&reid=%i",_rootTopic.ID];
    }
    if (_postType == 2) {
        [baseurl appendFormat:@"&reid=%i",_rootTopic.ID];
    }
    [baseurl appendFormat:@"&type=%i",3];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"dic = %@",dic);
        
        BOOL success = [[dic objectForKey:@"success"] boolValue];
        
        
        
        if (success) {
            
            //上传图片
            if([_picArray count] <= 0){
                [ProgressHUD showSuccess:@"发送成功"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            //返回数据解析
            NSDictionary *dict = [dic objectForKey:@"topic"];
            
            //NSURL *filePath = [NSURL fileURLWithPath:TMP_UPLOAD_IMG_PATH];
            
            NSString *baseUrl = [NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@&board=%@&id=%d",[Toolkit getToken],[dict objectForKey:@"board"], [[dict objectForKey:@"id"]intValue]];
            
            [manager POST:baseUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                [formData appendPartWithFileData:_picArray[0] name:@"file" fileName:@"image.jpg" mimeType:@"image/png"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"upload Success: %@", responseObject);
                
                if ([responseObject objectForKey:@"success"]) {
                    [ProgressHUD showSuccess:@"发送成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                    [ProgressHUD showError:@"发送失败"];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"upload Error: %@", error);
                [ProgressHUD showError:@"发送失败"];
            }];
            
        }
        
        
        
        else{
            [ProgressHUD showError:@"发送失败"];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error!");
        [ProgressHUD showError:@"网络故障"];
    }];
    
    
   
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

- (IBAction)cancelKeyboard:(id)sender {
    
    [_postTitleField resignFirstResponder];
    [_postContentView resignFirstResponder];
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
    
    NSString *nameStr =  [NSString stringWithFormat:@"%@.jpg",[self generateUuidString]];
 
    [self saveImage:selectedImage WithName:nameStr];
    //文件名
    [_picNameArr addObject:TMP_UPLOAD_IMG_PATH];
    
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

//调整大小
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize
{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName

{
    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    TMP_UPLOAD_IMG_PATH = fullPathToFile;
 
    //NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    NSLog(@"===new fullPathToFile===%@",fullPathToFile);
    NSLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}

-(NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    // transfer ownership of the string
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}


@end
