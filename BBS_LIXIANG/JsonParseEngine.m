//
//  JsonParseEngine.h.h
//  BBS_LIXIANG
//
//  Created by apple on 14-4-9.
//  Copyright (c) 2014年 apple. All rights reserved.
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

+(NSArray *)parseMails:(NSDictionary *)friendsDictionary Type:(int)type
{
    BOOL success = [[friendsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * mails = [[NSMutableArray alloc] init];
        NSArray *mailsArr = [friendsDictionary objectForKey:@"mails"];
        for (int i=0; i<[mailsArr count]; i++) {
            Mail * mail = [[Mail alloc] init];
            
            mail.ID = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"id"] intValue];
            mail.size = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"size"] intValue];
            mail.unread = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"unread"] boolValue];
            mail.author = [[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"author"];
            mail.title = [[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"title"];
            
            NSTimeInterval interval = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"time"] doubleValue];
            mail.time = [NSDate dateWithTimeIntervalSince1970:interval];
            mail.type = type;
            
            [mails addObject:mail];
        }
        return mails;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseSearchTopics:(NSDictionary *)topicsDictionary
{
    BOOL success = [[topicsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        NSArray *topics = [topicsDictionary objectForKey:@"topics"];
        for (int i=0; i<[topics count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * title = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"title"];
            NSString * author = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"author"];
            NSString * board = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"board"];
            
            NSString *  timeString = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"time"];
            //NSLog(@"%@",timeString);
            NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
            [inputFormat setDateFormat:@"yyyyMMdd"]; //20101208
            //将NSString转换为NSDate
            NSDate *time = [inputFormat dateFromString:timeString];
            
            int replies = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"replies"] intValue];
            int read = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"read"] intValue];
            
            topic.ID = ID;
            topic.title = title;
            topic.author = author;
            topic.board = board;
            topic.time = time;
            topic.replies = replies;
            topic.read = read;
            
            [topTen addObject:topic];
        }
        return topTen;
    }
    else {
        return nil;
    }
}

+(Mail *)parseSingleMail:(NSDictionary *)friendsDictionary  Type:(int)type
{
    BOOL success = [[friendsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        Mail * mail = [[Mail alloc] init];
        
        mail.ID = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"id"] intValue];
        mail.size = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"size"] intValue];
        mail.unread = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"unread"] boolValue];
        mail.author = [[friendsDictionary objectForKey:@"mail"] objectForKey:@"author"];
        mail.title = [[friendsDictionary objectForKey:@"mail"] objectForKey:@"title"];
        mail.content = [[friendsDictionary objectForKey:@"mail"] objectForKey:@"content"];
        
        NSTimeInterval interval = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"time"] doubleValue];
        mail.time = [NSDate dateWithTimeIntervalSince1970:interval];
        mail.type = type;
        
        return mail;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseBoards:(NSDictionary *)boardsDictionary
{
    BOOL success = [[boardsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * boards = [[NSMutableArray alloc] init];
        NSArray *boardArr = [boardsDictionary objectForKey:@"boards"];
        for (int i=0; i<[boardArr count]; i++) {
            Board * board = [[Board alloc] init];
            
            NSString * name = [[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"name"];
            int section = [[[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"id"] intValue];
            BOOL leaf = [[[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"leaf"] boolValue];
            NSString * description = [[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"description"];
            
            board.name = name;
            board.section = section;
            board.leaf = leaf;
            board.description = description;
            
            [boards addObject:board];
        }
        return boards;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseSections:(NSDictionary *)sectionsDictionary
{
    BOOL success = [[sectionsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * boards = [[NSMutableArray alloc] init];
        NSArray *sectionArr = [sectionsDictionary objectForKey:@"boards"];
        for (int i=0; i<[sectionArr count]; i++) {
            Board * board = [[Board alloc] init];
            
            BOOL leaf = [[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"leaf"] boolValue];
            NSString * name = [[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"name"];
            NSString * description = [[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"description"];
            int count = [[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"count"] intValue];
            int users = [[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"users"] intValue];
            NSArray * bm = [[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"bm"];
            
            board.leaf = leaf;
            board.name = name;
            board.description = description;
            board.count = count;
            board.users = users;
            board.bm = bm;
            
            if (!leaf) {
                [JsonParseEngine parseSingleSection:board BoardsDictionary:[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"boards"]];
                
            }
            [boards addObject:board];
        }
        return boards;
    }
    else {
        return nil;
    }
}

+(void)parseSingleSection:(Board *)board BoardsDictionary:(NSArray *)boardsArray
{
    for (int i=0; i<[boardsArray count]; i++) {
        Board * boardcach = [[Board alloc] init];
        BOOL leaf = [[[boardsArray objectAtIndex:i] objectForKey:@"leaf"] boolValue];
        NSString * name = [[boardsArray objectAtIndex:i] objectForKey:@"name"];
        NSString * description = [[boardsArray objectAtIndex:i] objectForKey:@"description"];
        int count = [[[boardsArray objectAtIndex:i] objectForKey:@"count"] intValue];
        int users = [[[boardsArray objectAtIndex:i] objectForKey:@"users"] intValue];
        NSArray * bm = [[boardsArray objectAtIndex:i] objectForKey:@"bm"];
        
        boardcach.leaf = leaf;
        boardcach.name = name;
        boardcach.description = description;
        boardcach.count = count;
        boardcach.users = users;
        boardcach.bm = bm;
        
        if (!leaf) {
            [JsonParseEngine parseSingleSection:boardcach BoardsDictionary:[[boardsArray objectAtIndex:i] objectForKey:@"boards"]];
        }
        
        [board.sectionBoards addObject:boardcach];
    }
}

+(Notification *)parseNotification:(NSDictionary *)notificationDictionary
{
    BOOL success = [[notificationDictionary objectForKey:@"success"] boolValue];
    
    Notification * notification = [[Notification alloc] init];
    if (success)
    {
        NSMutableArray * mails = [[NSMutableArray alloc] init];
        NSArray *mail_array = [notificationDictionary objectForKey:@"mails"];
        for (int i=0; i<[mail_array count]; i++) {
            Mail * mail = [[Mail alloc] init];
            
            int ID = [[[[notificationDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * title = [[[notificationDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"title"];
            NSString * author = [[[notificationDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"sender"];
            mail.ID = ID;
            mail.title = title;
            mail.author = author;
            mail.type = 0;
            mail.unread = YES;
            [mails addObject:mail];
        }
        
        NSMutableArray * ats = [[NSMutableArray alloc] init];
        NSArray *ats_array = [notificationDictionary objectForKey:@"ats"];
        for (int i=0; i<[ats_array count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * board = [[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"board"];
            NSString * title = [[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"title"];
            NSString * user = [[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"user"];
            
            topic.ID = ID;
            topic.board = board;
            topic.author = user;
            topic.title = title;
            
            [ats addObject:topic];
        }
        
        NSMutableArray * replies = [[NSMutableArray alloc] init];
        NSArray *replies_array = [notificationDictionary objectForKey:@"replies"];
        for (int i=0; i<[replies_array count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * board = [[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"board"];
            NSString * title = [[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"title"];
            NSString * user = [[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"user"];
            
            topic.ID = ID;
            topic.board = board;
            topic.author = user;
            topic.title = title;
            
            [replies addObject:topic];
        }
        
        notification.mails = mails;
        notification.ats = ats;
        notification.replies = replies;
        
        return notification;
    }
    else {
        return nil;
    }
    return nil;
}

+(User *)parseUserInfo:(NSDictionary *)loginDictionary2
{
    BOOL success = [[loginDictionary2 objectForKey:@"success"] boolValue];
    NSDictionary * loginDictionary = [loginDictionary2 objectForKey:@"user"];
    if (success)
    {
        User * user = [[User alloc] init];
        user.ID = [loginDictionary objectForKey:@"id"];
        user.name = [loginDictionary objectForKey:@"name"];
        NSString * avatarString = [loginDictionary objectForKey:@"avatar"];
        if ([avatarString hasSuffix:@".png"] || [avatarString hasSuffix:@".jpeg"] || [avatarString hasSuffix:@".jpg"] || [avatarString hasSuffix:@".tiff"] || [avatarString hasSuffix:@".bmp"])
        {
            user.avatar = [NSURL URLWithString:[loginDictionary objectForKey:@"avatar"]];
        }
        else {
            user.avatar = nil;
        }
        
        NSTimeInterval interval = [[loginDictionary objectForKey:@"lastlogin"] doubleValue];
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
        user.lastlogin = time;
        
        user.level = [loginDictionary objectForKey:@"level"];
        
        user.posts = [[loginDictionary objectForKey:@"posts"] intValue];
        user.perform = [[loginDictionary objectForKey:@"perform"] intValue];
        user.experience = [[loginDictionary objectForKey:@"experience"] intValue];
        user.medals = [[loginDictionary objectForKey:@"medals"] intValue];
        user.logins = [[loginDictionary objectForKey:@"logins"] intValue];
        user.life = [[loginDictionary objectForKey:@"life"] intValue];
        
        user.gender = [loginDictionary objectForKey:@"gender"];
        user.astro = [loginDictionary objectForKey:@"astro"];
        user.mode = [loginDictionary objectForKey:@"mode"];
        
        return user;
    }
    else {
        return nil;
    }
}

+ (NSString *)dateToString:(NSDate *)date;
{
    NSMutableString * dateString = [[NSMutableString alloc] init];
    
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents;
    dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        
        [dateString  appendString:@""];
        
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) && (dateComponents.day == todayComponents.day - 1)) {
        
        [dateString  appendString:@"昨天"];
        
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.weekOfYear == todayComponents.weekOfYear)) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"cccc";
        NSArray * array = [NSArray arrayWithObjects:@"开始", @"天", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        [dateString  appendString:[NSString stringWithFormat:@"星期%@", [array objectAtIndex:dateComponents.weekday]]];
        
    } else if (dateComponents.year == todayComponents.year) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"M-d";
        if ([dateFormatter stringFromDate:date] != nil) {
            [dateString  appendString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]]];
        }
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-M-d";
        NSLog(@"%@", [dateFormatter stringFromDate:date]);
        if ([dateFormatter stringFromDate:date] != nil) {
            [dateString  appendString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]]];
        }
    }
    
    [dateString  appendString:@"  "];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    if ([dateFormatter stringFromDate:date] != nil) {
        [dateString  appendString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]]];
    }
    
    return dateString;
}

//色值转换
+(UIColor *) colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:1.0f];
    
}


@end


