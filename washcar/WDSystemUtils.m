//
//  WDSystemUtils.m
//  WDLinkUp
//
//  Created by William REN on 10/14/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "WDSystemUtils.h"
#import "sys/sysctl.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WDSystemUtils



+ (BOOL)isEmptyOrNullString:(id)str
{
    BOOL flag = YES;
    if (str) {
        if (![str isKindOfClass:[NSString class]]) {
            flag = NO;
        }
        else {
            if (![str isEqualToString:@""]) {
                flag = NO;
            }
        }
    }
    return flag;
}

+ (NSString *)getDateString:(NSString *)str
{
    long long sec = [str longLongValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:sec];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (BOOL)isEqualsInt:(int)res andJsonData:(id)object
{
    if (object == nil) {
        return NO;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        NSString *resString = [NSString stringWithFormat:@"%i",res];
        return [resString isEqualToString:object];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        return res == [object intValue];
    }
    return NO;
}

+ (BOOL)isEmail:(NSString *)email
{
    
    NSString * regex = @"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:email];
    return isMatch;
}


+ (BOOL)isSignIn
{
    
    BOOL flag = false;
//    flag = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsIsSignIn] boolValue];
    return flag;
}

+ (NSString*) doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        platform = @"iPhone";
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        platform = @"iPhone 3G";
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        platform = @"iPhone 3GS";
    } else if ([platform isEqualToString:@"iPhone3,1"]) {
        platform = @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        platform = @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]) {
        platform = @"iPhone 5";
    } else if ([platform isEqualToString:@"iPod4,1"]) {
        platform = @"iPod touch 4";
    } else if ([platform isEqualToString:@"iPad3,2"]) {
        platform = @"iPad 3 3G";
    } else if ([platform isEqualToString:@"iPad3,1"]) {
        platform = @"iPad 3 WiFi";
    } else if ([platform isEqualToString:@"iPad2,2"]) {
        platform = @"iPad 2 3G";
    } else if ([platform isEqualToString:@"iPad2,1"]) {
        platform = @"iPad 2 WiFi";
    }
    
    return platform;
}

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    DLog(@"result:%@", result);
    return result;
}

+(bool)is4Or4s
{
    if ([[WDSystemUtils doDevicePlatform] isEqualToString:@"iPhone 4"]
        || [[WDSystemUtils doDevicePlatform] isEqualToString:@"iPhone 4S"]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
