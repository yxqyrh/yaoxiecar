//
//  CarVoucher.h
//  washcar
//
//  Created by xiejingya on 9/29/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarVoucher : NSObject

//
//id 洗车卷的id uid 用户账号 value 价值多少的洗车卷 judge 判断是否使用(0为未使用，1为已使用，2未领取 validity 使用有效期（时间戳） See 0为未查看，1为已查看 time 洗车卷被使用的时间
//                                               Res 1 获取成功

@property (nonatomic)NSString *uid;
@property (nonatomic)NSString *uname;
@property (nonatomic)NSString *upicture;
@property (nonatomic)NSString *money;
@property (nonatomic)NSString *carnumber;
@property (nonatomic)NSString *color;
@property (nonatomic)NSString *cwh;
@property (nonatomic)NSString *province;
@property (nonatomic)NSString *city;
@property (nonatomic)NSString *area;
@property (nonatomic)NSString *plot;
@property (nonatomic)NSDate *time;
@property (nonatomic)NSString *szdqstr;
@end
