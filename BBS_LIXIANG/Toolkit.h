//
//  Toolkit.h
//  weitaozhi
//
//  Created by admin  on 13-8-3.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toolkit : NSObject

+ (void)saveUserName:(NSString *)userName;
+ (void)saveID:(NSString *)ID;
+ (void)saveName:(NSString *)name;
+ (void)saveToken:(NSString *)token;

+ (void)saveTestUrl:(NSString *)url;
+ (void)saveUploadFileName:(NSString *)fileName;
+ (void)saveLocalAccess:(BOOL)local_access;

+ (NSString *)getUserName;
+ (NSString *)getID;
+ (NSString *)getName;
+ (NSString *)getToken;

+ (NSString *)getTestUrl;
+ (NSString *)getUploadFileName;
+ (BOOL)getLocalAccess;
@end
