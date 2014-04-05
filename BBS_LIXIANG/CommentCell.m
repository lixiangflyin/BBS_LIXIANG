//
//  CommentCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CommentCell.h"
#import "JsonParseEngine.h"

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
    [_numLabel setText:[NSString stringWithFormat:@"%i楼", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
   
    CGSize size1 = [_content boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, self.frame.size.width - 35, size1.height)];
    [_contentLabel setText:_content];
    
    UIFont *font2 = [UIFont boldSystemFontOfSize:12.0];
    CGSize size2 = [[NSString stringWithFormat:@"回复 %@：%@",_quoter, _quote] boundingRectWithSize:CGSizeMake(self.frame.size.width - 34, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font2} context:nil].size;
    [_commentToLabel setFrame:CGRectMake(_commentToLabel.frame.origin.x, _contentLabel.frame.origin.y + size1.height + 4, self.frame.size.width - 30, size2.height)];
    [_commentToLabel setText:[NSString stringWithFormat:@"回复 %@：%@",_quoter, _quote]];

}

#pragma mark UIView
//- (void)layoutSubviews {
//	[super layoutSubviews];
//    
//    [_numLabel setText:[NSString stringWithFormat:@"%i楼", _num]];
//    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
//    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
//    NSDateFormatter *date = [[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [_timeLabel setText:[date stringFromDate:_time]];
//    date = nil;
//    
//    UIFont *font = [UIFont systemFontOfSize:15.0];
//    
//    CGSize size1 = [_content boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
//    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, self.frame.size.width - 30, size1.height)];
//    [_contentLabel setText:_content];
//    
//    UIFont *font2 = [UIFont boldSystemFontOfSize:12.0];
//    CGSize size2 = [[NSString stringWithFormat:@"回复 %@：%@",_quoter, _quote] boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font2} context:nil].size;
//    [_commentToLabel setFrame:CGRectMake(_commentToLabel.frame.origin.x, _contentLabel.frame.origin.y + size1.height + 4, self.frame.size.width - 30, size2.height)];
//    [_commentToLabel setText:[NSString stringWithFormat:@"回复 %@：%@",_quoter, _quote]];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
