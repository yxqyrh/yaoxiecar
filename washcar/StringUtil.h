//
//  StringUtil.h
//  washcar
//
//  Created by xiejingya on 10/6/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;

+(NSMutableAttributedString*) getMenoyText:(NSString*)firstText:(NSString*)numText:(NSString*)lastText;
@end
