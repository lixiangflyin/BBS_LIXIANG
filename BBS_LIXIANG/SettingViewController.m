//
//  SettingViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-19.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "Toolkit.h"
#import "SDImageCache.h"
#import "ProgressHUD.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"设置";
    UIImage* image= [UIImage imageNamed:@"t1.png"];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _settingTableView.dataSource = self;  //数据源代理
    _settingTableView.delegate = self;    //表视图委托
    [self.view addSubview:_settingTableView];
    
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }
    if(section == 1){
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"当前";
    else
        return @"其他";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"当前用户";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    
                    if ([Toolkit getToken] != nil)
                        cell.detailTextLabel.text = [Toolkit getUserName];
                    else
                        cell.detailTextLabel.text = @"未登录";
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"版本号";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    cell.detailTextLabel.text = @"Version 1.0";
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"开发者";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    cell.detailTextLabel.text = @"李翔(lixiangflyin@163.com)";
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"消除缓存";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"关于应用";
                    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 0){
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        //[ASIHTTPRequest clearSession];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        [self deleteFiles];
        [ProgressHUD showSuccess:@"清除成功"];
    }
}

//delete files in document
-(void)deleteFiles
{
    //注释掉的是指删除指定文件
    //NSString *extension = @"m4r";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        //if ([[filename pathExtension] isEqualToString:extension]) {
        
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        //}
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
