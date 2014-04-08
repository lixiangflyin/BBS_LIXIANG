//
//  CommentCell.h
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentToLabel;

@property(nonatomic, assign)int ID;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)int read;
@property(nonatomic, assign)int num;
@property(nonatomic, assign)BOOL isMan;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSString * quoter;
@property(nonatomic, strong)NSString * quote;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)NSMutableArray * attachmentsViewArray;

-(void)setReadyToShow;

@end
