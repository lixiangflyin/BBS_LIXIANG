//
//  JsonParseEngine.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "JsonParseEngine.h"


@implementation JsonParseEngine


+(NSArray *)parseTopics:(NSDictionary *)topicsDictionary
{
    BOOL success = [[topicsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        NSArray *topicsArr = [topicsDictionary objectForKey:@"topics"];
        for (int i=0; i<[topicsArr count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * title = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"title"];
            NSString * author = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"author"];
            NSString * board = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"board"];

            NSTimeInterval interval = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"time"] doubleValue];            
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
            
            int replies = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"replies"] intValue];
            int read = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"read"] intValue];
            BOOL unread = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"unread"]boolValue];
            BOOL marked = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"mark"] boolValue];
            BOOL top = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"top"] boolValue];
            
            topic.unread = unread;
            topic.ID = ID;
            topic.title = title;
            topic.author = author;
            topic.board = board;
            topic.time = time;
            topic.replies = replies;
            topic.read = read;
            topic.mark = marked;
            topic.top = top;
            
            [topTen addObject:topic];
        }
        return topTen;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseSectionsTopics:(NSDictionary *)sectionsDictionary
{
    BOOL success = [[sectionsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        NSArray *sectionsArr = [NSArray arrayWithArray:[sectionsDictionary objectForKey:@"topics"]];
        for (int i=0; i<[sectionsArr count]; i++) {
            NSArray *sectionArr = [NSArray arrayWithArray:[[sectionsArr objectAtIndex:i]objectForKey:@"topics"]];
            for (int j=0; j<[sectionArr count]; j++) {
                Topic * topic = [[Topic alloc] init];
                
                NSDictionary *topicDic = [sectionArr objectAtIndex:j];
                int ID = [[topicDic objectForKey:@"id"] intValue];
                NSString * title = [topicDic objectForKey:@"title"];
                NSString * author = [topicDic objectForKey:@"author"];
                NSString * board = [topicDic objectForKey:@"board"];
                
                NSTimeInterval interval = [[topicDic objectForKey:@"time"] doubleValue];
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
                
                int replies = [[topicDic objectForKey:@"replies"] intValue];
                int read = [[topicDic objectForKey:@"read"] intValue];
                BOOL unread = [[topicDic objectForKey:@"unread"]boolValue];
                BOOL marked = [[[[topicDic objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"mark"] boolValue];
                BOOL top = [[topicDic objectForKey:@"top"] boolValue];
                
                topic.unread = unread;
                topic.ID = ID;
                topic.title = title;
                topic.author = author;
                topic.board = board;
                topic.time = time;
                topic.replies = replies;
                topic.read = read;
                topic.mark = marked;
                topic.top = top;
                
                [topTen addObject:topic];
            }
        }
        return topTen;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseSingleTopic:(NSDictionary *)topicsDictionary
{
    BOOL success = [[topicsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        NSArray *topicsArr = [topicsDictionary objectForKey:@"topics"];
        for (int i=0; i<[topicsArr count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"id"] intValue];
            int gID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"gid"] intValue];
            int reid = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"reid"] intValue];
            
            NSString * title = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"title"];
            NSString * content = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"content"];
            NSString * author = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"author"];
            NSString * board = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"board"];
            
            NSTimeInterval interval = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"time"] doubleValue];
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
            
            int read = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"read"] intValue];
            
            NSString * quote = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"quote"];
            NSString * quoter = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"quoter"];
            /////////附件///////
            NSMutableArray * attArray=[[NSMutableArray alloc] init];
            NSDictionary * attDic=[[topicsDictionary objectForKey:@"topics"] objectAtIndex: i];
            //附件
            NSArray *arr = [attDic objectForKey:@"attachments"];
            for (int j=0;  j<[arr count];j++) {
                Attachment *attElement=[[Attachment alloc]init];
                [attElement setAttFileName:[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"filename"]];
                
                [attElement setAttId:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"id"] intValue]];
                
                [attElement setAttPos:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"pos"] intValue]];
                
                [attElement setAttSize:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"size"] intValue]];
                
                [attElement setAttUrl:[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"url"]];
                
                [attArray addObject:attElement];
            }
            ///////////////////
            topic.attachments = attArray;
            ////////modified by joe//////
            topic.ID = ID;
            topic.gID = gID;
            topic.reid = reid;
            
            topic.title = title;
            topic.content = content;
            topic.author = author;
            topic.board = board;
            
            topic.time = time;
            topic.read = read;
            
            if ([quote length] > 12) {
                topic.quote = [quote substringToIndex:12];
            }
            else {
                topic.quote = quote;
            }
            
            topic.quoter =quoter;
            [topTen addObject:topic];
        }
        return topTen;
    }
    else {
        return nil;
    }
}


@end


