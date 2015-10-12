//
//  GlobalVar.h
//  WDLinkUp
//
//  Created by CSB on 15-3-3.
//  Copyright (c) 2015年 Wonders information Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"


@interface GlobalVar : NSObject


@property (nonatomic)NSString *systemUserId;


+ (GlobalVar *)sharedSingleton;


@property (nonatomic)NSString *uid;

@property (nonatomic)NSString *isloginid;

@property (nonatomic)UserInfo *userInfo;

// uid=18550031362  Isloginid=14435112502766


@end
