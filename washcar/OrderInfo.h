//
//  OrderInfo.h
//  washcar
//
//  Created by CSB on 15/9/29.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic)NSString *id;
@property (nonatomic)NSString *num;
@property (nonatomic)NSString *numtime;
@property (nonatomic)NSString *xctime;
@property (nonatomic)NSString *uid;//发布人的账号

@property (nonatomic)NSString *xcgsjh;

@property (nonatomic)NSString *province;
@property (nonatomic)NSString *city;
@property (nonatomic)NSString *area;
@property (nonatomic)NSString *plot;

@property (nonatomic)NSString *cwh;

@property (nonatomic)NSString *methods;
@property (nonatomic)NSString *methodsval;


@property (nonatomic)NSDate *time;
@property (nonatomic)NSString *yjxcsj;
@property (nonatomic)NSString *remark;

@property (nonatomic)NSString *bz;//洗车工备注

@property (nonatomic)NSString *judge_zt;
@property (nonatomic)NSString *judge_zf;

@property (nonatomic)NSString *pj;

@property (nonatomic)NSString *unsubscribe;
@property (nonatomic)NSString *guser;
@property (nonatomic)NSString *xc_picture;
@property (readwrite)NSString *szdqstr;
@property (readwrite)NSString *address;

-(NSArray *)xc_pictures;



@end
