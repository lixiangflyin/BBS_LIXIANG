//
//  BoardTopicCell.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardTopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property(nonatomic, strong) NSDate * time;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * author;
@property(nonatomic, assign) int replies;

-(void)setReadyToShow;

@end
