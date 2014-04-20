//
//  TopTenCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TopCell.h"
#import "JsonParseEngine.h"

@implementation TopCell

-(void)dealloc
{
    _sectionLabel = nil;
    _titleLabel = nil;
    _timeLabel = nil;
    _section = nil;
    _replyLabel = nil;
    _section = nil;
    _title = nil;
    _author = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
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
    
    [_colorBackgroudLabel setBackgroundColor:[JsonParseEngine colorWithHexString:_colorStr]];
    
    //遍历获得中文名
    for(NSArray *arr in _array)
    {
        for (int i=0; i<[arr count]; i++) {
            NSDictionary *dic = arr[i];
            if ([[dic objectForKey:@"sectionName"] isEqualToString:_section]) {
                [_sectionLabel setText:[dic objectForKey:@"description"]];
                break;
            }
        }
    }
    
    [_timeLabel setText:[NSString stringWithFormat:@"%@", _author]];
    [_replyLabel setText:[NSString stringWithFormat:@"%i", _replies]];
}


@end
