//
//  CommentCell.m
//  SBBS_xiang
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "CommentCell.h"
#import "JsonParseEngine.h"
#import "UIImageView+WebCache.h"
#import "Toolkit.h"

#define EDITTOPIC     200
#define REPLYTOPIC    201

@implementation CommentCell

-(void)dealloc
{
    _headPhotoImage = nil;
    _userLabel = nil;
    _timeLabel = nil;
    _numLabel = nil;
    _contentLabel = nil;
    _commentToLabel = nil;
    _editButton = nil;
    _name = nil;
    _num = nil;
    _time = nil;
    _author = nil;
    _content = nil;
    _quote = nil;
    _quoter = nil;
    _attachments = nil;
    _attachmentsViewArray = nil;
    _headPhotoUrl = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

//给图片添加事件
-(void)addTapToImageView
{
    UITapGestureRecognizer *clickHeadPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadPhoto:)];
    _headPhotoImage.userInteractionEnabled = YES;
    [_headPhotoImage addGestureRecognizer: clickHeadPhoto];
    clickHeadPhoto = nil;
    
}

#pragma -mark tap
-(void) clickHeadPhoto:(id)sender
{
    NSLog(@"click headPhoto!");
    [_delegate tapHeadPhoto:_indexRow];
}

-(void)setReadyToShow
{
    
    if (_isMan) {
        //[_headPhotoImage setImage:[UIImage imageNamed:@"man.jpg"]];
        
        [_headPhotoImage setImageWithURL:_headPhotoUrl placeholderImage:[UIImage imageNamed:@"man.jpg"]];
    }
    else{
        //[_headPhotoImage setImage:[UIImage imageNamed:@"girl.jpg"]];
        
        [_headPhotoImage setImageWithURL:_headPhotoUrl placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    }
   
    _editButton.hidden = YES;
    if ([_author isEqualToString:[Toolkit getUserName]]) {
        _editButton.hidden = NO;
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%@", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;

    [_contentLabel setText:_content];

    NSString *str = [NSString stringWithFormat:@"【在%@的大作中提到:】\n : %@",_quoter,_quote];
    [_commentToLabel setText:str];
    
    //复用问题
    if (_attachmentsViewArray != nil) {
        UIView * view;
        for (view in _attachmentsViewArray) {
            [view removeFromSuperview];
        }
        self.attachmentsViewArray = [[NSMutableArray alloc] init];
    }
    else {
        self.attachmentsViewArray = [[NSMutableArray alloc] init];
    }
    //如果有附件，就加载
    if ([_attachments count] > 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size1 = [_content boundingRectWithSize:CGSizeMake(self.frame.size.width - 35, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        font = nil;
        
        UIFont *font2 = [UIFont boldSystemFontOfSize:13.0];
        CGSize size2 = [str boundingRectWithSize:CGSizeMake(self.frame.size.width - 34, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font2} context:nil].size;
        font2 = nil;
        
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            ImageAttachmentView * imageAttachmentView = [[ImageAttachmentView alloc] initWithFrame:CGRectMake(60, i*180 + _contentLabel.frame.origin.y + size1.height + size2.height + 20, 200, 180)];
            [imageAttachmentView setAttachmentURL:[NSURL URLWithString:att.attUrl] NameText:att.attFileName];
            imageAttachmentView.indexNum = i;
            imageAttachmentView.mDelegate = self;
            [self addSubview:imageAttachmentView];
            [self.attachmentsViewArray addObject:imageAttachmentView];
        }
    }

}

//楼主cell调用
-(void)setReadyToShowOne
{
    if (_isMan) {
        //[_headPhotoImage setImage:[UIImage imageNamed:@"man.jpg"]];
        
        [_headPhotoImage setImageWithURL:_headPhotoUrl placeholderImage:[UIImage imageNamed:@"man.jpg"]];
    }
    else{
        //[_headPhotoImage setImage:[UIImage imageNamed:@"girl.jpg"]];
        
        [_headPhotoImage setImageWithURL:_headPhotoUrl placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    }
    
    _editButton.hidden = YES;
    if ([_author isEqualToString:[Toolkit getUserName]]) {
        _editButton.hidden = NO;
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%@", _num]];
    [_userLabel setText:[NSString stringWithFormat:@"%@", _author]];
    //[_timeLabel setText:[JsonParseEngine dateToString:_time]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_timeLabel setText:[date stringFromDate:_time]];
    date = nil;
    
    //NSLog(@"CommentCell before frame: %@", NSStringFromCGRect(_contentLabel.frame));
    [_contentLabel setText:_content];
    //NSLog(@"CommentCell after frame: %@", NSStringFromCGRect(_contentLabel.frame));
    [_commentToLabel setText:@""];
    
    
    if (_attachmentsViewArray != nil) {
        UIView * view;
        for (view in _attachmentsViewArray) {
            [view removeFromSuperview];
        }
        self.attachmentsViewArray = [[NSMutableArray alloc] init];
    }
    else {
        self.attachmentsViewArray = [[NSMutableArray alloc] init];
    }
    //如果有附件，就加载
    if ([_attachments count] > 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size1 = [_content boundingRectWithSize:CGSizeMake(self.frame.size.width - 35, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        NSArray * picArray = [self getPicList];
        for (int i = 0; i < [picArray count]; i++) {
            Attachment * att = [picArray objectAtIndex:i];
            ImageAttachmentView * imageAttachmentView = [[ImageAttachmentView alloc] initWithFrame:CGRectMake(60, i*180 + _contentLabel.frame.origin.y + size1.height + 10, 200, 180)];
            [imageAttachmentView setAttachmentURL:[NSURL URLWithString:att.attUrl] NameText:att.attFileName];
            imageAttachmentView.indexNum = i;
            imageAttachmentView.mDelegate = self;
            [self addSubview:imageAttachmentView];
            [self.attachmentsViewArray addObject:imageAttachmentView];
        }
    }
    
}

//处理集中图片
-(NSArray *)getPicList
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_attachments count]; i++) {
        NSString * attUrlString=[[[_attachments objectAtIndex:i] attUrl] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            [picArray addObject:[_attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

#pragma - ImageAttachmentViewDelegate
-(void)imageAttachmentViewTaped:(int)indexNum
{
    [_delegate imageAttachmentViewInCellTaped:_indexRow Index:indexNum];
}

#pragma - AttachmentViewDelegate
-(void)attachmentViewTaped:(BOOL)isPhoto IndexNum:(int)indexNum
{
    [_delegate attachmentViewInCellTaped:isPhoto IndexRow:_indexRow IndexNum:indexNum];
}

- (IBAction)replyToTopic:(id)sender {
    
    UIButton *selectBtn = (UIButton *)sender;
    
    int tag = (int)selectBtn.tag;
    
    switch (tag) {
        case EDITTOPIC:
            [_delegate replyTheTopic:_indexRow ButtonNum:EDITTOPIC];
            break;
        case REPLYTOPIC:
            [_delegate replyTheTopic:_indexRow ButtonNum:REPLYTOPIC];
            break;
        default:
            break;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
