//
//  GlobalVar.h
//  WDLinkUp
//
//  Created by CSB on 15-3-3.
//  Copyright (c) 2015年 Wonders information Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef NS_ENUM (NSInteger, MayiSignState) {
    MayiSignStateUnSigned = 0,
    MayiSignStateSigned = 1,
    MayiSignStateSigning = 2
};

@interface GlobalVar : NSObject


@property (nonatomic)NSString *systemUserId;


+ (GlobalVar *)sharedSingleton;


@property (nonatomic)NSString *uid;

@property (nonatomic)NSString *isloginid;

@property (nonatomic)UserInfo *userInfo;

@property (nonatomic)NSDictionary *launchOptions;

@property (nonatomic)MayiSignState signState;

// uid=18550031362  Isloginid=14435112502766

@property (nonatomic)NSMutableArray* carInfoList;
@end
