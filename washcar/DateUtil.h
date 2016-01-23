//
//  DataUtil.h
//  washcar
//
//  Created by xiejingya on 10/6/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+(long)getTimeSp;
+(NSDate *)changeSpToTime:(NSString*)spString;
+(NSDate*)zoneChange:(NSString*)spString;
+(long)timeDifference:(NSDate *)date;
+(NSString*)nsdateToString:(NSDate *)date:(NSString*)strDateFormat;
+(long)changeTimeToTimeSp:(NSString *)timeStr;
+(NSString *)getTime;
+(long)changeTimeToTimeSp:(NSString *)timeStr :(NSString *)fm;
@end
