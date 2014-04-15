//
//  SectionsViewController.h
//  SBBS_xiang
//
//  Created by apple on 14-4-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SectionCell.h"

@protocol SectionsDelegate <NSObject>

-(void)pushToNextSingleSectionViewWithValue:(NSString *)boardName;

@end


@interface SectionsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *sectionsArr;

@property (nonatomic, retain) ASIFormDataRequest *request;

@property (nonatomic, assign) id delegate;

@end
