//
//  WDHttpRequestManager.h
//  WDLinkUp
//
//  Created by William REN on 9/12/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Toast+UIView.h"
#import "MKnetworkKit.h"

//typedef void (^WDHttpRequestResultBlock)(id);

@interface WDHttpRequestManager : NSObject {
    AFHTTPRequestOperationManager *_manager;
}


@property (strong,nonatomic) NSString *accessToken;

@property (strong, nonatomic)NSString *serverUrl;
@property (strong, nonatomic)NSString *serverWAPIUrl;

+ (WDHttpRequestManager *)sharedInstance;


- (AFHTTPRequestOperation *)POST:(NSString *)methodName
                      parameters:(id)parameters
                 showLoadingView:(UIView *)view
       constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>))block
                         success:(void (^)(id responseObject))success
                        failture:(void(^)(NSError *error))failture;

- (void)POST:(NSString *)methodName
                      parameters:(id)parameters
                 showLoadingView:(UIView *)view
                         success:(void (^)(id responseObject))success
                        failture:(void(^)(NSError *error))failture;


@end
