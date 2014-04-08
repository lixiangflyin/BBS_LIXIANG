//
//  SectionsViewController.m
//  SBBS_xiang
//
//  Created by apple on 14-4-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SectionsViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SectionsViewController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation SectionsViewController

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
	
    RADataObject *phone1 = [RADataObject dataObjectWithName:@"本站系统" children:nil];
    RADataObject *phone2 = [RADataObject dataObjectWithName:@"东南大学" children:nil];
    RADataObject *phone3 = [RADataObject dataObjectWithName:@"Phone 3" children:nil];
    RADataObject *phone4 = [RADataObject dataObjectWithName:@"Phone 4" children:nil];
    
    RADataObject *phone = [RADataObject dataObjectWithName:@"本站系统"
                                                  children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]];
    
    RADataObject *notebook1 = [RADataObject dataObjectWithName:@"Notebook 1" children:nil];
    RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Notebook 2" children:nil];
    self.expanded = notebook1;
    
    RADataObject *computer1 = [RADataObject dataObjectWithName:@"东南大学"
                                                      children:[NSArray arrayWithObjects:notebook1, notebook2, nil]];
    RADataObject *computer2 = [RADataObject dataObjectWithName:@"Computer 2" children:nil];
    RADataObject *computer3 = [RADataObject dataObjectWithName:@"Computer 3" children:nil];
    
    RADataObject *computer = [RADataObject dataObjectWithName:@"电脑技术"
                                                     children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil]];
    RADataObject *car = [RADataObject dataObjectWithName:@"学术科学" children:nil];
    RADataObject *bike = [RADataObject dataObjectWithName:@"艺术文化" children:nil];
    RADataObject *house = [RADataObject dataObjectWithName:@"乡情校意" children:nil];
    RADataObject *motorbike = [RADataObject dataObjectWithName:@"休闲娱乐" children:nil];
    RADataObject *drinks = [RADataObject dataObjectWithName:@"知性感性" children:nil];
    
    RADataObject *renWen0 = [RADataObject dataObjectWithName:@"飞跃重洋" children:nil];
    RADataObject *renWen1 = [RADataObject dataObjectWithName:@"校园讲座与活动" children:nil];
    RADataObject *renWen2 = [RADataObject dataObjectWithName:@"商业代理" children:nil];
    RADataObject *renWen3 = [RADataObject dataObjectWithName:@"探索之旅" children:nil];
    RADataObject *renWen4 = [RADataObject dataObjectWithName:@"8区区长工作室" children:nil];
    RADataObject *renWen5 = [RADataObject dataObjectWithName:@"党建之窗" children:nil];
    RADataObject *renWen6 = [RADataObject dataObjectWithName:@"经济天地" children:nil];
    RADataObject *renWen7 = [RADataObject dataObjectWithName:@"高考招生" children:nil];
    RADataObject *renWen8 = [RADataObject dataObjectWithName:@"历史" children:nil];
    RADataObject *renWen9 = [RADataObject dataObjectWithName:@"房产信息" children:nil];
    RADataObject *renWen10 = [RADataObject dataObjectWithName:@"实习" children:nil];
    RADataObject *renWen11 = [RADataObject dataObjectWithName:@"招聘特快" children:nil];
    RADataObject *renWen12 = [RADataObject dataObjectWithName:@"打工一族" children:nil];
    RADataObject *renWen13 = [RADataObject dataObjectWithName:@"考研" children:nil];
    RADataObject *renWen14 = [RADataObject dataObjectWithName:@"法网恢恢" children:nil];
    RADataObject *renWen15 = [RADataObject dataObjectWithName:@"失物招领" children:nil];
    RADataObject *renWen16 = [RADataObject dataObjectWithName:@"军事天地" children:nil];
    RADataObject *renWen17 = [RADataObject dataObjectWithName:@"网络资源" children:nil];
    RADataObject *renWen18 = [RADataObject dataObjectWithName:@"跳槽市场" children:nil];
    RADataObject *renWen19 = [RADataObject dataObjectWithName:@"交通信息" children:nil];
    RADataObject *renWen20 = [RADataObject dataObjectWithName:@"统一战线" children:nil];
    RADataObject *renWen = [RADataObject dataObjectWithName:@"人文信息" children:[NSArray arrayWithObjects:renWen0, renWen1, renWen2, renWen3, renWen4, renWen5, renWen6, renWen7, renWen8, renWen9, renWen10, renWen11, renWen12, renWen13, renWen14, renWen15, renWen16, renWen17, renWen18,  renWen19, renWen20, nil]];
    
    RADataObject *sweets = [RADataObject dataObjectWithName:@"体坛风暴" children:nil];
    RADataObject *watches = [RADataObject dataObjectWithName:@"校务信箱" children:nil];
    RADataObject *walls = [RADataObject dataObjectWithName:@"社团群体" children:nil];
    
    self.data = [NSArray arrayWithObjects:phone, computer, car, bike, house, motorbike, drinks, renWen, sweets, watches, walls, nil];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    //[treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    
    self.treeView.frame = self.view.bounds;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //return 47;
    return 40;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return NO;
    }
    
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSLog(@"aItem: %ld bItem:% ld",(long)treeNodeInfo.positionInSiblings,(long)treeNodeInfo.parent.positionInSiblings);
    NSLog(@"item：%@",((RADataObject *)item).name);
    
    [_delegate pushToNextSingleSectionView];
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //NSInteger numberOfChildren = [treeNodeInfo.children count];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return [data.children objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
