//
//  WDHttpRequestManager.h
//  WDLinkUp
//
//  Created by William REN on 9/12/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Toast+UIView.h"
#import "MKnetworkKit.h"

//typedef void (^WDHttpRequestResultBlock)(id);

@interface MayiHttpRequestManager : NSObject {
    MKNetworkEngine *_manager;
}


@property (strong,nonatomic) NSString *accessToken;

@property (strong, nonatomic)NSString *serverUrl;
@property (strong, nonatomic)NSString *serverWAPIUrl;

+ (MayiHttpRequestManager *)sharedInstance;




- (void)POST:(NSString *)methodName
                      parameters:(id)parameters
                 showLoadingView:(UIView *)view
                         success:(void (^)(id responseObject))success
                        failture:(void(^)(NSError *error))failture;


@end
