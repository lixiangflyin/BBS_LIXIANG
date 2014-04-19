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

-(void)dealloc
{
    _timeLabel = nil;
    _titleLabel = nil;
    _authorLabel = nil;
    _replyLabel = nil;
    _time = nil;
    _title = nil;
    _author = nil;
}

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
    [_replyLabel setText:[NSString stringWithFormat:@"%i", _replies]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
