//
//  CommonProblem.m
//  TestSlidebar
//
//  Created by xiejingya on 7/6/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "CommonProblem.h"

@implementation CommonProblem
+(NSMutableArray *)getCommonProblemFromJson:(id)json{
    if (json==nil) {
        return nil;
    }
    NSArray *array = [json objectForKey:@"data"];
    int num = array.count;
    if (num <=0 ) {
        return nil;
    }
    NSMutableArray *_array = [[NSMutableArray alloc]init];
    for (int i = 0; i < num ; i++) {
        CommonProblem *_commpro = [[CommonProblem alloc]init];
        _commpro.title = [array[i] objectForKey:@"title"];
        _commpro.content = [array[i] objectForKey:@"content"];
        _commpro.updated_at = [array[i] objectForKey:@"updated_at"];
        [_array addObject:_commpro];
    }
    return _array;
}
@end
