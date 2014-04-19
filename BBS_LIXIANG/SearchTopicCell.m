//
//  SearchTopicCell.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SearchTopicCell.h"

@implementation SearchTopicCell

-(void)dealloc
{
    _authorLabel = nil;
    _sectionLabel = nil;
    _titleLabel = nil;
    _author = nil;
    _section = nil;
    _title = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//数据显示在cell
-(void)setReadyToShow;
{
    [_titleLabel setText:_title];
    [_sectionLabel setText:_section];
    [_authorLabel setText:[NSString stringWithFormat:@"%@", _author]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
