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
    [_titleLabel setText:_title];
    //[_sectionLabel setText:_section];
    
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


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
