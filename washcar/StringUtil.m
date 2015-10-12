//
//  StringUtil.m
//  washcar
//
//  Created by xiejingya on 10/6/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

+(NSMutableAttributedString*) getMenoyText:(NSString*)firstText:(NSString*)numText:(NSString*)lastText{
    
//    [@"确认领取" stringByAppendingFormat:@"%@%@",  [_voucherInfo objectForKey:@"value"] ,@"元洗车券" ];
    NSUInteger a = 0;
    NSUInteger b = numText.length;
    NSString *str ;
    if (firstText!=nil&&firstText.length>0) {
        a = firstText.length;
        str =[firstText stringByAppendingFormat:@"%@%@",numText,lastText];
    }else{
        str =[numText stringByAppendingFormat:@"%@",lastText];
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                        value:menoyTextColor
                          range:NSMakeRange(a, b)];
    return  AttributedStr;
}

@end

