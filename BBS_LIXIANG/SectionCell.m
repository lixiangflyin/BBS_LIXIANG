//
//  SectionCell.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SectionCell.h"
#import "ProgressHUD.h"
#import "Toolkit.h"

@implementation SectionCell

-(void)dealloc
{
    _sectionLabel = nil;
    _collectButton = nil;
    _sectionDic = nil;
}

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
    [_sectionLabel setText:[_sectionDic objectForKey:@"description"]];
    
    //获取保存的收藏版面
    NSMutableArray *array = [Toolkit getCollectedSections];
    
    BOOL isCollected = NO;
    for(NSDictionary *obj in array){
        if ([obj isEqualToDictionary:_sectionDic]) {
            isCollected = YES;
            break;
        }
    }
    
    if (isCollected) {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    }
    else{
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"select_not.png"] forState:UIControlStateNormal];
    }
}


- (IBAction)collectionTheSection:(id)sender {
    
    NSLog(@"tap collection!");
    
    //需要分配内存
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObjectsFromArray:[Toolkit getCollectedSections]];
    
    BOOL isCollected = NO;
    for(NSDictionary *obj in array){
        if ([obj isEqualToDictionary:_sectionDic]) {
            isCollected = YES;
            break;
        }
    }
    
    if (isCollected) {
        [array removeObject:_sectionDic];
        [Toolkit saveCollectedSections:array];
        
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"select_not.png"] forState:UIControlStateNormal];
        [ProgressHUD showSuccess:@"取消收藏"];
    }
    else{
        [array addObject:_sectionDic];
        [Toolkit saveCollectedSections:array];
        
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [ProgressHUD showSuccess:@"收藏成功"];
    }
    
    array = nil;
    
}


@end
