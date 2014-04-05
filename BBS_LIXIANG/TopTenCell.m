//
//  TopTenCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TopTenCell.h"

@implementation TopTenCell

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
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size1 = [_title boundingRectWithSize:CGSizeMake(self.frame.size.width - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil].size;
    [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, self.frame.size.width - 35, size1.height)];
    [_titleLabel setText:_title];
    
    [_sectionLabel setFrame:CGRectMake(_sectionLabel.frame.origin.x, _titleLabel.frame.origin.y + size1.height, 112, 17)];
    [_sectionLabel setText:_section];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
