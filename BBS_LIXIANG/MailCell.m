//
//  MailCell.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MailCell.h"

@implementation MailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
    
    //推送
//    notificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 65)];
//    [self addSubview:notificationImageView];
//    if (mail.unread) {
//        [notificationImageView setBackgroundColor:[UIColor redColor]];
//    }
//    else
//    {
//        [notificationImageView setBackgroundColor:[UIColor whiteColor]];
//    }
    
    if (_mail.type == 0)
        [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
    if (_mail.type == 1)
        [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
    if (_mail.type == 2)
        [_authorLabel setText:[NSString stringWithFormat:@"%@", _mail.author]];
    
    [_titleLabel setText:[NSString stringWithFormat:@"%@", _mail.title]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@", _mail.time]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
