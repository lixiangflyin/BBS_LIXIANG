//
//  JsonParseEngine.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.


//该文件主要实现从服务器中获取的信息中获取我们想要的信息，
//并且存入我们定义的数据模型中，
//给bbsapp提供一个函数
#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "JSONKit.h"


@interface JsonParseEngine : NSObject

//解析十大
+(NSArray *)parseTopics:(NSDictionary *)topicsDictionary;
//解析所有section十大
+(NSArray *)parseSectionsTopics:(NSDictionary *)sectionsDictionary;
//解析单个话题
+(NSArray *)parseSingleTopic:(NSDictionary *)topicsDictionary;
//解析搜索结果
+(NSArray *)parseSearchTopics:(NSDictionary *)topicsDictionary;
//分类解析邮件
+(NSArray *)parseMails:(NSDictionary *)friendsDictionary Type:(int)type;
//解析单个邮件
+(Mail *)parseSingleMail:(NSDictionary *)friendsDictionary  Type:(int)type;
//解析版面
+(NSArray *)parseBoards:(NSDictionary *)boardsDictionary;
//时间转换
+ (NSString *)dateToString:(NSDate *)date;

@end
