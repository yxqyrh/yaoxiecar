//
//  DateTool.h
//  washcar
//
//  Created by xiejingya on 10/6/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTool : NSObject
+ (NSString*)getTimeStr1:(long long)time;


+(NSString*) getTimeStrStyle1:(long long)time;
+ (NSString*)getTimeStr1Short:(long long)time;

+(NSString*) getTimeStrStyle2:(long long)time;

+(int)dayCountForMonth:(int)month andYear:(int)year;

+(BOOL)isLeapYear:(int)year;
@end
