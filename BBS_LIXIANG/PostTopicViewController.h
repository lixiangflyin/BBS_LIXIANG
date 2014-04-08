//
//  PostTopicViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTopicViewController : UIViewController<UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *postContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;

@property(nonatomic, retain)NSMutableArray *picArray;//picture upoaded array

- (IBAction)getPostPicture:(id)sender;
@end
