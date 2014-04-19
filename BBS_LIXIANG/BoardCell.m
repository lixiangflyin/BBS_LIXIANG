//
//  BoardCell.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "BoardCell.h"

@implementation BoardCell

-(void)dealloc
{
    _boardLabel = nil;
    _titleImageView = nil;
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

@end
