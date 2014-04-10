//
//  LoginViewController.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-6.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)login:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)back:(id)sender;
@end
