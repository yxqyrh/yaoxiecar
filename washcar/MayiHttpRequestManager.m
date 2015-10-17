//
//  WDHttpRequestManager.m
//  WDLinkUp
//
//  Created by William REN on 9/12/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "MayiHttpRequestManager.h"
//#import "WDNetworkUtilsDefine.h"
#import "MJExtension.h"


static MayiHttpRequestManager *_instance = nil;

@implementation MayiHttpRequestManager

#pragma mark - 单例
+ (MayiHttpRequestManager *)sharedInstance
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
        
//        _manager = [AFHTTPRequestOperationManager manager];
////        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//        
////        _manager.requestSerializer= [AFJSONRequestSerializer serializer];
////        _manager.responseSerializer= [AFJSONResponseSerializer serializer];
//        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//        responseSerializer.readingOptions = NSJSONReadingAllowFragments;
//        _manager.responseSerializer = responseSerializer;
//        
////        _manager.responseSerializer.acceptableContentTypes = [AFHTTPResponseSerializer serializer].acceptableContentTypes;
//        _manager.securityPolicy.allowInvalidCertificates = YES;
        
        
        
//        [_manager GET:[NSString stringWithFormat:@"%@", @"http://mayi.ahxdnet.com/index.php?s=/Home/User/"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", string);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
        _manager = [[MKNetworkEngine alloc] initWithHostName:@"mayi.ahxdnet.com/index.php?s=/Home/User" customHeaderFields:nil];
        
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
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




- (void)POST:(NSString *)methodName
  parameters:(id)parameters
showLoadingView:(UIView *)view
     success:(void (^)(id responseObject))success
    failture:(void(^)(NSError *error))failture;
{
    
    if (view != nil) {
        [view makeToastActivity];
    }
    NSMutableDictionary *dic = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", _serverUrl, methodName];
    
    DLog(@"请求 %@\nURL: %@\n参数：%@", [[self methodDescription] objectForKey:methodName], urlString, parameters);
    
    if (parameters == nil) {
        dic = [NSMutableDictionary dictionaryWithCapacity:1];
        
    }
    else {
        if ([parameters isKindOfClass:[NSMutableDictionary class]]) {
            dic = parameters;
        }
        else if ([parameters isKindOfClass:[NSDictionary class]]) {
            dic = [parameters mutableCopy];
        }
    }
    [dic setObject:@"ab1ffd1cbc6cdd121679e8f00e505311" forKey:@"key"];
    if ([GlobalVar sharedSingleton].isloginid != nil) {
        [dic setObject:[GlobalVar sharedSingleton].isloginid forKey:@"isloginid"];
        [dic setObject:[GlobalVar sharedSingleton].uid forKey:@"uid"];
    }
    MKNetworkOperation *op = [_manager operationWithPath:methodName params:dic httpMethod:@"POST" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        id json = [operation responseJSON];
//         DLog(@"response json:%@",json);
        success(json);
       
        if (view != nil) {
            [view hideToastActivity];
        }

    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
        failture(err);
        if (view != nil) {
            [view hideToastActivity];
        }
    }];
    [_manager enqueueOperation:op];
    
   
}



@end
