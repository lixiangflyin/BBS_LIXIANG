//
//  PostMailViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Mail.h"

@interface PostMailViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *postUser;
@property (nonatomic, strong) UITextField *postTitle;
@property (nonatomic, strong) UITextView *postContent;

@property (nonatomic, strong) UIScrollView * postScrollView;

@property(nonatomic, strong)Mail * rootMail;
@property(nonatomic, strong)NSString * sentToUser;
@property(nonatomic, assign)int postType;

- (IBAction)cancel:(id)sender;
- (IBAction)sendMail:(id)sender;
@end
