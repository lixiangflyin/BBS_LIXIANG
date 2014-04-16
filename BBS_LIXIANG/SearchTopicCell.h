//
//  SearchTopicCell.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) NSString * section;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * author;

//数据显示在cell
-(void)setReadyToShow;

@end
