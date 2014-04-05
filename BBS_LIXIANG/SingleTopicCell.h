//
//  SingleTopicCell.h
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * section;
@property(nonatomic, assign) int replies;

-(void)setReadyToShow;

@end
