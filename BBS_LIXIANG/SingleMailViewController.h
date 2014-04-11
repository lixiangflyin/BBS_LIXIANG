//
//  SingleMailViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Mail.h"

@interface SingleMailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet UIView *realView;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property(nonatomic, retain)Mail * rootMail;  //前一个传的值
@property(nonatomic, retain)Mail * mail;

@end
