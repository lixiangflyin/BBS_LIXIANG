//
//  MenuViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "SwitchViewController.h"
#import "LoginViewController.h"
#import "MailViewController.h"
#import "SearchViewController.h"
#import "InputViewController.h"
#import "UserInfoViewController.h"
#import "MySectionsViewController.h"
#import "NotificationViewController.h"
#import "SettingViewController.h"
#import "MenuCell.h"
#import "Toolkit.h"

#import "UIViewController+MMDrawerController.h"
#import "UIImageView+WebCache.h"

#import "ProgressHUD.h"
#import "JsonParseEngine.h"

#define MYMAIL           201
#define REPLYME          202
#define COLLECTION       203

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SwitchViewController *slideSwitchVC = [[SwitchViewController alloc] initWithNibName:@"SwitchViewController" bundle:nil];
        
        self.navSwitchViewController = [[UINavigationController alloc] initWithRootViewController:slideSwitchVC];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = _headView;
    self.tableView.scrollEnabled = NO;

    [self addTapToHeadImageView];
    
    if ([Toolkit getID] != nil) {
        [_name1Label setText:[Toolkit getID]];
        [_name2Label setText:[Toolkit getName]];
    }
    else{
        [_name1Label setText:@"quest"];
        [_name2Label setText:@"quest"];
    }
}

//给图片添加事件
-(void)addTapToHeadImageView
{
    UITapGestureRecognizer *clickHeadPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadPhoto)];
    _headPhotoView.userInteractionEnabled = YES;
    [_headPhotoView addGestureRecognizer: clickHeadPhoto];
    clickHeadPhoto = nil;
    
}

-(void)clickHeadPhoto
{
    //是否登录
    if ([Toolkit getUserName] == nil) {
        return;
    }
    
    UserInfoViewController *userInfor = [[UserInfoViewController alloc]init];
    User *myinfo = [JsonParseEngine parseUserInfo:[Toolkit getUserDictionary]];
    [userInfor setUser:myinfo];
    [self presentPopupViewController:userInfor animationType:MJPopupViewAnimationSlideTopBottom];
    userInfor = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 0, 0)];
    //label.text = @"操作";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    if (sectionIndex == 0)
        label.text = @"  常用";
    else
        label.text = @"  操作";
    
    [label sizeToFit];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 24;    //显示高度的如果为0，就不显示这一行
    
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    if (section == 0) {
        switch (row) {
            case 0:
                if (!self.navSwitchViewController) {
                    SwitchViewController *slideSwitchVC = [[SwitchViewController alloc] init];
                    
                    self.navSwitchViewController = [[UINavigationController alloc] initWithRootViewController:slideSwitchVC];
                }
                
                [self.mm_drawerController setCenterViewController:self.navSwitchViewController
                                               withCloseAnimation:YES completion:^(BOOL finished){
                                                   NSLog(@"finished animation");
                                                }];
                break;
            default:
                break;
        }
    }
    
    else if (section == 1)
    {
        switch (row) {
            case 0:{
                if (!_inputSearchVC) {
                    _inputSearchVC = [[InputViewController alloc]init];
                    _inputSearchVC.delegate = self;
                }

                //需要回调函数
                [self.mm_drawerController presentPopupViewController:_inputSearchVC animationType:MJPopupViewAnimationSlideTopBottom];
                break;
            }
            case 1:
                if (!self.navSettingViewController) {
                    SettingViewController *settingVC = [[SettingViewController alloc] init];
                    
                    self.navSettingViewController = [[UINavigationController alloc] initWithRootViewController:settingVC];
                }
                
                [self.mm_drawerController setCenterViewController:self.navSettingViewController
                                               withCloseAnimation:YES completion:^(BOOL finished){
                                                   NSLog(@"finished animation");
                                               }];
                break;
            case 2:{
                if ([Toolkit getUserName] != nil) {
                    //注销用户
                    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:@"登出虎踞龙盘？"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"取消"
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:@"确定",nil];
                    //cameraSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                    [cameraSheet showInView:self.view];
                    cameraSheet = nil;
                    break;
                }
                
                LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:login];
                login.delegate = self;
                [self presentViewController:navVC animated:YES completion:nil];
                break;
            }
            default:
                break;
        } //滑动切换视图
    }
}


#pragma action delegate
//******************************************
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
        
        [_name1Label setText:@"quest"];
        [_name2Label setText:@"quest"];
        
        [Toolkit saveUserName:nil];
        [Toolkit saveID:nil];
        [Toolkit saveName:nil];
        [Toolkit saveToken:nil];
        [Toolkit saveUserDictionary:nil];
        
        //UI变化
        NSIndexPath * index = [NSIndexPath indexPathForItem:2 inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        for(UIView *label in [cell.contentView subviews]){
            if ([label isKindOfClass:[UILabel class]]) {
                [(UILabel *)label setText:@"登录"];
            }
        }
		
	} else if (buttonIndex == 1) {
		

	}
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identi = @"MenuCell";
    //第一次需要分配内存
    MenuCell * cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    if (indexPath.section == 0) {
        
        NSArray *titles = @[@"热门话题"];
        cell.titleLabel.text = titles[indexPath.row];
        cell.titleImageView.image = [UIImage imageNamed:@"menu_top.png"];
    }
    else {
        
        NSArray *titles;
        if ([Toolkit getUserName] == nil) {
            titles = @[@"搜索", @"设置", @"登录"];
        }
        else{
            titles = @[@"搜索", @"设置", @"注销"];
        }
        
        NSArray *images = @[@"menu_search.png",@"menu_setting",@"menu_logout"];
        cell.titleString = titles[indexPath.row];
        cell.imageName = images[indexPath.row];
        
        [cell setReadyShow];
    }
    
    return cell;
}

#pragma -mark button handle
- (IBAction)clickButton:(id)sender {
    
    //判断是否登录
    if ([Toolkit getUserName] == nil) {
        [ProgressHUD showError:@"请先登录"];
        return;
    }
    
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag) {
        case MYMAIL:
            if (!self.navMailViewController) {
                MailViewController *mailVC = [[MailViewController alloc] init];
                
                self.navMailViewController = [[UINavigationController alloc] initWithRootViewController:mailVC];
            }
            
            [self.mm_drawerController setCenterViewController:self.navMailViewController
                                           withCloseAnimation:YES completion:^(BOOL finished){
                                               NSLog(@"finished animation");
                                           }];
            break;
        case REPLYME:
            if (!self.navReplymeViewController) {
                NotificationViewController *replyMeVC = [[NotificationViewController alloc] init];
                
                self.navReplymeViewController = [[UINavigationController alloc] initWithRootViewController:replyMeVC];
            }
            
            [self.mm_drawerController setCenterViewController:self.navReplymeViewController
                                           withCloseAnimation:YES completion:^(BOOL finished){
                                               NSLog(@"finished animation");
                                           }];
            break;
        case COLLECTION:
            if (!self.navMyCollectViewController) {
                MySectionsViewController *mySectionVC = [[MySectionsViewController alloc] init];
                
                self.navMyCollectViewController = [[UINavigationController alloc] initWithRootViewController:mySectionVC];
            }
            
            [self.mm_drawerController setCenterViewController:self.navMyCollectViewController
                                           withCloseAnimation:YES completion:^(BOOL finished){
                                               NSLog(@"finished animation");
                                           }];
            break;
        default:
            break;
    }
    
}

#pragma -mark InputSearchStrDelegate
-(void)pushToSearchViewWithValue:(NSString *)searchString
{
    [self.mm_drawerController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
    
    if (!self.navSearchViewController) {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchString = searchString;
        self.navSearchViewController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    }
    else{
        //为传数据
        SearchViewController *searchVC = [self.navSearchViewController.viewControllers objectAtIndex:0];
        searchVC.searchString = searchString;
        [searchVC reloadSearchView];
    }
    
    [self.mm_drawerController setCenterViewController:self.navSearchViewController
                                   withCloseAnimation:YES completion:^(BOOL finished){
                                       NSLog(@"finished animation");
                                   }];
}

-(void)cancelSearchView
{
    [self.mm_drawerController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

#pragma -mark loginDelegate
-(void)loginSuccess
{
    [_name1Label setText:[Toolkit getID]];
    [_name2Label setText:[Toolkit getName]];
    
    
    NSString * baseurl = [NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/user/%@.json",[Toolkit getUserName]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"dic %@",dic);
        if ([[dic objectForKey:@"success"] boolValue] == 1) {
            
            //保存用户信息
            [Toolkit saveUserDictionary:dic];
            
            NSDictionary *userDic = [dic objectForKey:@"user"];
            NSString *gender = [userDic objectForKey:@"gender"];
            if ([gender isEqualToString:@"M"]) {
                [_headPhotoView setImage:[UIImage imageNamed:@"man.jpg"]];
                
            }
            else{
                
                [_headPhotoView setImage:[UIImage imageNamed:@"girl.jpg"]];
            }
            
            //UI变化
            NSIndexPath * index = [NSIndexPath indexPathForItem:2 inSection:1];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            for(UIView *label in [cell.contentView subviews]){
                if ([label isKindOfClass:[UILabel class]]) {
                    [(UILabel *)label setText:@"注销"];
                }
            }
        
        }
        else{
            
            //访问出错
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error!");
        
    }];
    
}


@end
