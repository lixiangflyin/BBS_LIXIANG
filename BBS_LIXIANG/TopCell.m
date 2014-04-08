//
//  TopTenCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setReadyToShow
{
    
    [_titleLabel setText:_title];
    [_sectionLabel setText:_section];
    [_timeLabel setText:[NSString stringWithFormat:@"作者:%@", _author]];
    [_replyLabel setText:[NSString stringWithFormat:@"回复%i", _replies]];
}


@end
