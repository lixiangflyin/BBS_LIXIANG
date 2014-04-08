//
//  MailCell.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface MailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) Mail * mail;

@end
