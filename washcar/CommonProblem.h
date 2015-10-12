//
//  CommonProblem.h
//  TestSlidebar
//
//  Created by xiejingya on 7/6/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonProblem : NSObject
@property NSString *title;
@property NSString *content;
@property NSString *updated_at;

+(NSMutableArray*) getCommonProblemFromJson:(id)json;

@end
