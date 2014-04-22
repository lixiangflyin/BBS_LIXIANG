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
#import "BoardCell.h"
#import "SectionCell.h"
#import "Toolkit.h"
#import "JsonParseEngine.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SectionsViewController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation SectionsViewController

-(void)dealloc
{
    _sectionsArr = nil;
    _pictureArr = nil;
}

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

    [self getdataFormLocation];
    
    _pictureArr = @[@"home.png",@"amuse.png",@"fasion.png",@"science.png",@"art.png",@"society.png",@"game.png",@"art.png",@"fasion.png",@"game.png",@"fasion.png",@"art.png"];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 64 - 44)];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    //加载数据
    [treeView reloadData];
    //[treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
}

-(void)getdataFormLocation
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sections_info" ofType:@"plist"];
    _sectionsArr = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
 
    //具体填写cell
    NSArray *sArr;
    
    sArr = _sectionsArr[0];
    NSMutableArray *benzhan = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [benzhan addObject:obj];
    }
    RADataObject *board1 = [RADataObject dataObjectWithName:@"本站系统"
                                                  children:benzhan];
    
    sArr = _sectionsArr[1];
    NSMutableArray *dongnan = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [dongnan addObject:obj];
    }
    RADataObject *board2 = [RADataObject dataObjectWithName:@"东南大学"
                                                   children:dongnan];
    
    sArr = _sectionsArr[2];
    NSMutableArray *diannao = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [diannao addObject:obj];
    }
    RADataObject *board3 = [RADataObject dataObjectWithName:@"电脑技术"
                                                     children:diannao];
    
    sArr = _sectionsArr[3];
    NSMutableArray *xueshu = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [xueshu addObject:obj];
    }
    RADataObject *board4 = [RADataObject dataObjectWithName:@"学术科学" children:xueshu];
    
    sArr = _sectionsArr[4];
    NSMutableArray *yishu = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [yishu addObject:obj];
    }
    RADataObject *board5 = [RADataObject dataObjectWithName:@"艺术文化" children:yishu];
    
    sArr = _sectionsArr[5];
    NSMutableArray *xiangqing = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [xiangqing addObject:obj];
    }
    RADataObject *board6 = [RADataObject dataObjectWithName:@"乡情校意" children:xiangqing];
    
    sArr = _sectionsArr[6];
    NSMutableArray *xiuxian = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [xiuxian addObject:obj];
    }
    RADataObject *board7 = [RADataObject dataObjectWithName:@"休闲娱乐" children:xiuxian];
    
    sArr = _sectionsArr[7];
    NSMutableArray *zhixing = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [zhixing addObject:obj];
    }
    RADataObject *board8 = [RADataObject dataObjectWithName:@"知性感性" children:zhixing];
    
    sArr = _sectionsArr[8];
    NSMutableArray *renwen = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [renwen addObject:obj];
    }
    RADataObject *board9 = [RADataObject dataObjectWithName:@"人文信息" children:renwen];
    
    sArr = _sectionsArr[9];
    NSMutableArray *titan = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [titan addObject:obj];
    }
    RADataObject *board10 = [RADataObject dataObjectWithName:@"体坛风暴" children:titan];
    
    sArr = _sectionsArr[10];
    NSMutableArray *xiaowu = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [xiaowu addObject:obj];
    }
    RADataObject *board11 = [RADataObject dataObjectWithName:@"校务信箱" children:xiaowu];
    
    sArr = _sectionsArr[11];
    NSMutableArray *shetuan = [[NSMutableArray alloc]init];
    for (int i=0; i<[sArr count]; i++) {
        NSDictionary *sDic = sArr[i];
        RADataObject *obj = [RADataObject dataObjectWithName:[sDic objectForKey:@"description"] children:nil];
        [shetuan addObject:obj];
    }
    RADataObject *board12 = [RADataObject dataObjectWithName:@"社团群体" children:shetuan];
    
    self.data = [NSArray arrayWithObjects:board1, board2, board3, board4, board5, board6, board7, board8, board9, board10, board11, board12, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
//        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
//    }
//    
//    self.treeView.frame = self.view.bounds;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 44;
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
        return YES;
    }
    
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF1F1F1);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xF1F1F1);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //获取cell信息
    NSLog(@"aItem: %ld bItem:% ld",(long)treeNodeInfo.positionInSiblings,(long)treeNodeInfo.parent.positionInSiblings);
    NSLog(@"item：%@",((RADataObject *)item).name);
    NSString *title = ((RADataObject *)item).name;
    if ([title isEqualToString:@"本站系统"] | [title isEqualToString:@"东南大学"] | [title isEqualToString:@"电脑技术"] | [title isEqualToString:@"学术科学"] | [title isEqualToString:@"艺术文化"] | [title isEqualToString:@"乡情校意"] | [title isEqualToString:@"休闲娱乐"] | [title isEqualToString:@"知性感性"] | [title isEqualToString:@"人文信息"] | [title isEqualToString:@"体坛风暴"] | [title isEqualToString:@"校务信箱"] | [title isEqualToString:@"社团群体"]) {
        
        NSLog(@"do nothing!");
        
        //[_treeView reloadData];
    }
    else{
    
        NSArray *selectArr = [self.sectionsArr objectAtIndex:treeNodeInfo.parent.positionInSiblings];
        NSDictionary *detailDic = [selectArr objectAtIndex:treeNodeInfo.positionInSiblings];
        NSString *boardName = [detailDic objectForKey:@"sectionName"];
    
        [_delegate pushToNextSingleSectionViewWithValue:boardName];
    }
}


#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    
    if (treeNodeInfo.treeDepthLevel == 0) {
        
        static NSString * identi = @"BoardCell";
        //第一次需要分配内存
        BoardCell * cell = (BoardCell *)[treeView dequeueReusableCellWithIdentifier:identi];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BoardCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            
        }
        
        [cell.boardLabel setText:((RADataObject *)item).name];
        [cell.titleImageView setImage:[UIImage imageNamed:_pictureArr[treeNodeInfo.positionInSiblings]]];
        
        return cell;
    }
    
    else if (treeNodeInfo.treeDepthLevel == 1) {
        
        static NSString * identi = @"SectionCell";
        //第一次需要分配内存
        SectionCell * cell = (SectionCell *)[treeView dequeueReusableCellWithIdentifier:identi];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SectionCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        
        NSArray *selectArr = self.sectionsArr[treeNodeInfo.parent.positionInSiblings];
        NSDictionary *detailDic = selectArr[treeNodeInfo.positionInSiblings];
        
        cell.sectionDic = detailDic;
        
        [cell setReadyToShow];
        
        return cell;
    }
    
    else{
        
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
  
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
