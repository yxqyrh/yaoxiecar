//
//  VoucherInfo.h
//  washcar
//
//  Created by xiejingya on 10/6/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoucherInfo : NSObject
//
//id 洗车卷的id uid 用户账号 value 价值多少的洗车卷 judge 判断是否使用(0为未使用，1为已使用，2未领取 validity 使用有效期（时间戳） See 0为未查看，1为已查看 time 洗车卷被使用的时间
//See = 0;
//id = 7;
//judge = 0;
//ssuid = 0;
//time = 1444110348;
//uid = 18550031362;
//validity = 1444120348;
//value = "1.00";

@property (nonatomic)NSString *id;
@property (nonatomic)NSString *See;
@property (nonatomic)NSString *judge;
@property (nonatomic)NSString *ssuid;//发布人的账号

@property (nonatomic)NSString *time;
@property (nonatomic)NSString *uid;
@property (nonatomic)NSString *validity;
@property (nonatomic)NSString *value;


@end
