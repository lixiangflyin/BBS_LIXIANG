//
//  TopTenCell.h
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  //authorLabel
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorBackgroudLabel;

@property(nonatomic, strong) NSString * section;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * author;
@property(nonatomic, assign) int replies;

@property(nonatomic, strong) NSString * colorStr;

@property(nonatomic, retain) NSMutableArray *array;
//数据显示在cell
-(void)setReadyToShow;

@end
