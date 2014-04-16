//
//  CommentCell.h
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "ImageAttachmentView.h"

@protocol CommentCellDelegate <NSObject>

-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum;
-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum;
//点击头像
-(void)tapHeadPhoto:(int)indexRow;
-(void)replyTheTopic:(int)indexRow ButtonNum:(int)buttonNum;

@end

@interface CommentCell : UITableViewCell<ImageAttachmentViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentToLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property(nonatomic, assign)int ID;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)int read;
@property(nonatomic, strong)NSString *num;
@property(nonatomic, assign)BOOL isMan;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSString * quoter;
@property(nonatomic, strong)NSString * quote;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)NSMutableArray * attachmentsViewArray;

@property(nonatomic, strong)NSString *headPhotoUrl;

@property(nonatomic, assign)int indexRow;
@property(nonatomic, assign)id delegate;

-(void)setReadyToShow;
-(void)setReadyToShowOne;

-(void)addTapToImageView;
- (IBAction)replyToTopic:(id)sender;

@end
