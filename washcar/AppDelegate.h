//
//  AppDelegate.h
//  washcar
//
//  Created by CSB on 15/9/25.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"

// production - hangzhou
#define kAppId           @"FG6IQV7oHQAFzDNzRz73O4"
#define kAppKey          @"cxueGTlNfN96y8S0ymL722"
#define kAppSecret       @"gESxBTSxQK8ZuMvwHBLKp2"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSString *appKey;
@property (nonatomic) NSString *appSecret;
@property (nonatomic) NSString *appID;
@property (nonatomic) NSString *clientId;
@property (nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;


@end

