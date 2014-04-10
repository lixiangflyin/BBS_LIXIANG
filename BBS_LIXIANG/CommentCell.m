//
//  CommentCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CommentCell.h"
#import "JsonParseEngine.h"
#import "UIImageView+MJWebCache.h"

@implementation CommentCell

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
    if (_isMan) {
        [_headPhotoImage setImage:[UIImage imageNamed:@"man.jpg"]];
    }
    else{
        [_headPhotoImage setImage:[UIImage imageNamed:@"girl.jpg"]];
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%@", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;

    [_contentLabel setText:_content];

    NSString *str = [NSString stringWithFormat:@"【在%@(%@)的大作中提到:】\n : %@",_quoter,_name,_quote];
    [_commentToLabel setText:str];

}

-(void)setReadyToShowOne
{
    if (_isMan) {
        [_headPhotoImage setImage:[UIImage imageNamed:@"man.jpg"]];
    }
    else{
        [_headPhotoImage setImage:[UIImage imageNamed:@"girl.jpg"]];
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%@", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;

    [_contentLabel setText:_content];
    [_commentToLabel setText:@""];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
