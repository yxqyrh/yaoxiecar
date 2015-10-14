//
//  OrderInfo.m
//  washcar
//
//  Created by CSB on 15/9/29.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo

- (BOOL)isEqual:(id)object
{
    if (object == nil) {
        return FALSE;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return FALSE;
    }
    
    OrderInfo *o = (OrderInfo *)object;
    if ([_num isEqualToString:o.num]) {
        return TRUE;
    }
    
    return FALSE;
    
}

-(NSArray *)xc_pictures
{
    if (_xc_picture == nil) {
        return nil;
    }
    
    NSMutableArray *mArray = nil;
    NSArray *array = [_xc_picture componentsSeparatedByString:@"|"];
    if (array != nil) {
        mArray = [array mutableCopy];
    }
    
    for (NSString *str in mArray) {
        if ([@"" isEqualToString:str]) {
            [mArray removeObject:str];
            break;
        }
    }
    return mArray;
}

@end
