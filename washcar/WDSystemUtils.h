//
//  WDSystemUtils.h
//  WDLinkUp
//
//  Created by William REN on 10/14/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDSystemUtils : NSObject


+ (BOOL)isEmptyOrNullString:(id)str;

+ (NSString *)getDateString:(NSString *)str;


+ (BOOL)isEqualsInt:(int)res andJsonData:(id)object;

+ (BOOL)isEmail:(NSString *)email;
+ (BOOL)isSignIn;

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

+(bool)is4Or4s;

@end
