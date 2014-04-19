//
//  SingleTopicCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SingleTopicCell.h"

@implementation SingleTopicCell

-(void)dealloc
{
    _titleLabel = nil;
    _sectionLabel = nil;
    _replyLabel = nil;
    _time = nil;
    _title = nil;
    _section = nil;
}

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
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size1 = [_title boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, self.frame.size.width - 35, size1.height)];
    [_titleLabel setText:_title];
    font = nil;
    
    [_sectionLabel setFrame:CGRectMake(_sectionLabel.frame.origin.x, _titleLabel.frame.origin.y + size1.height + 1, 118, 21)];
    [_sectionLabel setText:_section];
    
    [_replyLabel setFrame:CGRectMake(237, _titleLabel.frame.origin.y + size1.height + 1, 71, 21)];
    //NSLog(@"frame: %@", NSStringFromCGRect(_replyLabel.frame));
    [_replyLabel setText:[NSString stringWithFormat:@"回复(%i)", _replies]];
}



@end
