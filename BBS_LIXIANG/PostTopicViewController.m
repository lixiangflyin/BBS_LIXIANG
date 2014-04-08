//
//  PostTopicViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PostTopicViewController.h"
#import "seekImageView.h"

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
    
    self.title = NSLocalizedString(@"发帖", nil);
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
