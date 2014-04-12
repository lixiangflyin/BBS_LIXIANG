//
//  PostTopicViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface PostTopicViewController : UIViewController<UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *postContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;

@property(nonatomic, retain)NSMutableArray *picArray;//picture upoaded array

@property(nonatomic, strong) Topic * rootTopic;   //传值 话题
@property(nonatomic, strong) NSString * boardName;  //版面
@property(nonatomic, assign) int postType;   //发表类型，0发表新文章，1回帖，2修改文章

- (IBAction)getPostPicture:(id)sender;
@end
