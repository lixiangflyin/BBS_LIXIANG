//
//  BoardTopicCell.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "BoardTopicCell.h"
#import "JsonParseEngine.h"

@implementation BoardTopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setReadyToShow
{
    [_authorLabel setText: _author];
    [_titleLabel setText:_title];
    [_timeLabel setText:[JsonParseEngine dateToString:_time]];
    [_replyLabel setText:[NSString stringWithFormat:@"回%i", _replies]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
