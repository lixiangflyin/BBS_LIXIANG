//
//  Toolkit.m
//  weitaozhi
//
//  Created by admin  on 13-8-3.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "Toolkit.h"
#import <Foundation/Foundation.h>

@implementation Toolkit

+ (void)saveUserName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"userName"];
}

+ (void)saveID:(NSString *)ID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ID forKey:@"ID"];
}

+ (void)saveName:(NSString *)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"name"];
}

+ (void)saveToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
}

+ (void)saveCollectedSections:(NSMutableArray *)sections
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sections forKey:@"collect_sections"];
}



+ (NSString *)getUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"userName"];
}

+ (NSString *)getID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"ID"];
}

+ (NSString *)getName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"name"];
}

+ (NSString *)getToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"token"];
}

+ (NSMutableArray *)getCollectedSections
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSMutableArray *)[defaults objectForKey:@"collect_sections"];
}




@end
