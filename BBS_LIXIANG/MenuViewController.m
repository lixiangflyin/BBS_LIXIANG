//
//  MenuViewController.m
//  BBS_LIXIANG
//
//  Created by apple on 14-4-5.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "HomeViewController.h"

#define MYMAIL     201
#define ATME       202
#define REPLYME    203

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = _headView;
    
    [_name1Label setText:@"心往之"];
    [_name2Label setText:@"lixiangflyin"];
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
        label.text = @"常用";
    else
        label.text = @"操作";
    
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
    //    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    //
    //    if (indexPath.section == 0 && indexPath.row == 0) {
    //        DEMOHomeViewController *homeViewController = [[DEMOHomeViewController alloc] init];
    //        navigationController.viewControllers = @[homeViewController];
    //    } else {
    //        DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
    //        navigationController.viewControllers = @[secondViewController];
    //    }
    //
    //    [self.frostedViewController hideMenuViewController];
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"热门话题"];
        NSLog(@"%ld",(long)indexPath.row);
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"搜索", @"设置", @"注销"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

- (IBAction)clickButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag) {
        case MYMAIL:
            NSLog(@"201");
            break;
        case ATME:
            NSLog(@"202");
            break;
        case REPLYME:
            NSLog(@"203");
            break;
        default:
            break;
    }
    
}

@end
