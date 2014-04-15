//
//  SectionCell.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (nonatomic, retain) NSDictionary *sectionDic;

@property (nonatomic, assign) id delegate;

-(void)setReadyToShow;
- (IBAction)collectionTheSection:(id)sender;

@end
