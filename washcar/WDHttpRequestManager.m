//
//  WDHttpRequestManager.m
//  WDLinkUp
//
//  Created by William REN on 9/12/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "WDHttpRequestManager.h"
//#import "WDNetworkUtilsDefine.h"
#import "MJExtension.h"


static WDHttpRequestManager *_instance = nil;

@implementation WDHttpRequestManager

#pragma mark - 单例
+ (WDHttpRequestManager *)sharedInstance
{
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];

            _instance.serverUrl = @"http://mayi.ahxdnet.com/index.php?s=/Home/User/";

        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        
        _manager = [AFHTTPRequestOperationManager manager];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
//        _manager.requestSerializer= [AFJSONRequestSerializer serializer];
//        _manager.responseSerializer= [AFJSONResponseSerializer serializer];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.readingOptions = NSJSONReadingAllowFragments;
        _manager.responseSerializer = responseSerializer;
        
//        _manager.responseSerializer.acceptableContentTypes = [AFHTTPResponseSerializer serializer].acceptableContentTypes;
        _manager.securityPolicy.allowInvalidCertificates = YES;
        
        
        
//        [_manager GET:[NSString stringWithFormat:@"%@", @"http://mayi.ahxdnet.com/index.php?s=/Home/User/"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", string);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (AFHTTPRequestOperation *)POST:(NSString *)methodName
                      parameters:(id)parameters
                         success:(void (^)(id))success
{
    return [self POST:methodName parameters:parameters success:success failure:^(NSError *error) {
        
    }];
}

- (AFHTTPRequestOperation *)POST:(NSString *)methodName
                      parameters:(id)parameters
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *error))failure
{
    //    [SVProgressHUD showWithStatus:@"加载中...."];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?format=json", _serverUrl, methodName];
    DLog(@"请求 %@\n参数：%@", [[self methodDescription] objectForKey:methodName], parameters);
    
    return [_manager POST:urlString
               parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      DLog(@"%@ 请求成功！\n结果：%@", [[self methodDescription] objectForKey:methodName], responseObject);

                      success(responseObject);

                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failure(error);
                      DLog(@"%@ 请求失败！\n错误：%@", [[self methodDescription] objectForKey:methodName], error);

                  }];
}

- (NSString *)convertMethodName:(NSString *)methodName
{
    NSString *resultString = [methodName capitalizedStringWithLocale:[NSLocale currentLocale]];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"_" withString:@""];
    resultString = [NSString stringWithFormat:@"WD%@Entity", resultString];
    //    DLog(@"convertMethodName: %@", resultString);
    return resultString;
}

// convert UnderScoreCase to CamelCase
- (NSString *)convertFieldName:(NSString *)fieldName
{
    NSString *resultString = @"";
    NSArray *components = [fieldName componentsSeparatedByString:@"_"];
    //    DLog(@"components: %@", components);
    for (int index = 0; index < components.count; index ++) {
        NSString *component = [components objectAtIndex:index];
        if (index == 0) {
            resultString = [resultString stringByAppendingString:component];
        } else {
            resultString = [resultString stringByAppendingString:[component capitalizedStringWithLocale:[NSLocale currentLocale]]];
        }
    }
    //    DLog(@"convertMethodName: %@", resultString);
    return resultString;
}

- (NSDictionary *)methodDescription
{
    return @{@"/oauth2/access_token": @"登录/验证接口：获取授权过的令牌"};
}

- (AFHTTPRequestOperation *)POST:(NSString *)methodName
                      parameters:(id)parameters
       constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>))block
                         success:(void (^)(id responseObject))success
                        failture:(void(^)(NSError *error))failture
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?format=json", _serverUrl, methodName];

    DLog(@"请求 %@\nURL: %@\n参数：%@", [[self methodDescription] objectForKey:methodName], urlString, parameters);
    
    return [_manager POST:urlString parameters:parameters constructingBodyWithBlock:block
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      DLog(@"%@ 请求成功！\n结果：%@", [[self methodDescription] objectForKey:methodName], responseObject);
                      success(responseObject);
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error){
                      DLog(@"error");
                      
                      failture(error);

                  }];
}

- (AFHTTPRequestOperation *)POST:(NSString *)methodName
                      parameters:(id)parameters
                 showLoadingView:(UIView *)view
       constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>))block
                         success:(void (^)(id responseObject))successBlock
                        failture:(void(^)(NSError *error))failture
{
    
    if (view != nil) {
        [view makeToastActivity];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?format=json", _serverUrl, methodName];

    DLog(@"请求 %@\nURL: %@\n参数：%@", [[self methodDescription] objectForKey:methodName], urlString, parameters);
    
    return [_manager POST:urlString parameters:parameters constructingBodyWithBlock:block
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DLog(@"%@ 请求成功！\n结果：%@", [[self methodDescription] objectForKey:methodName], responseObject);
                //                             DLog(@"%@", operation.response);
                
                    if (view != nil) {
                        [view hideToastActivity];
                    }
                  successBlock(responseObject);
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
                DLog(@"error:%@",error);
                [view hideToastActivity];
                
                failture(error);

            }];
}



@end
