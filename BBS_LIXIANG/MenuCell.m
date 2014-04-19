//
//  MenuCell.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

-(void)dealloc
{
    _titleImageView = nil;
    _titleLabel = nil;
    _edgeImageView = nil;
    _imageName = nil;
    _titleString = nil;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setReadyShow
{
    [_titleImageView setImage:[UIImage imageNamed:_imageName]];
    [_titleLabel setText:_titleString];
    
    if ([_titleString isEqualToString:@"热门话题"]) {
        _edgeImageView.hidden = NO;
    }
    else
        _edgeImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
