//
//  InputViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"   //UIViewController视图动画

@protocol InputSearchStrDelegate <NSObject>

-(void)pushToSearchViewWithValue:(NSString *)searchString;
-(void)cancelSearchView;

@end

@interface InputViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) IBOutlet UITextField *searchTxtField;
- (IBAction)startSearch:(id)sender;
- (IBAction)cancelSearch:(id)sender;

@end
