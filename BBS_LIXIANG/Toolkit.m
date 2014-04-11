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



+ (void)saveTestUrl:(NSString *)url
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:@"ip_test"];
}

+ (void)saveUploadFileName:(NSString *)fileName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:fileName forKey:@"uploadFileName"];
}

+ (void)saveLocalAccess:(BOOL)local_access

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:local_access forKey:@"local_access"];
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



+ (NSString *)getTestUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"ip_test"];
}

+ (NSString *)getUploadFileName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"uploadFileName"];
}

+ (BOOL)getLocalAccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"local_access"]boolValue];
}

@end
