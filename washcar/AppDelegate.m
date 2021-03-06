//
//  AppDelegate.m
//  washcar
//
//  Created by CSB on 15/9/25.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "StoryboadUtil.h"
#import "MayiHttpRequestManager.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import <UMengSocial/UMSocial.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

#import <AMapLocationKit/AMapLocationKit.h>



#define NotifyActionKey "NotifyAction"
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

@interface AppDelegate () {
     NSString *_deviceToken;
}

@end

@implementation AppDelegate

- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

-(void)registerShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"ec8926eaf991"
     
          activePlatforms:@[@(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
            case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx207ef4929a384aab"
                                       appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
                      default:
                 break;
         }
     }];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    if (launchOptions == nil) {
//        launchOptions = [NSMutableDictionary dictionary];
//    }
    [AMapLocationServices sharedServices].apiKey = @"95c7c94fe7764df213d5d809d29eb235";
    if (launchOptions == nil) {

    
    }
    else {
         NSDictionary *userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [GlobalVar sharedSingleton].launchOptions = userInfo;
        
    }
    
    [WXApi registerApp:APP_ID withDescription:APP_ID];
    [self registerShareSDK];
    
    application.applicationIconBadgeNumber = 0;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:MayiUserIsNotFirstEnter]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        return YES;
    }
    else {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:MayiUserIsSignIn]) {
            [GlobalVar sharedSingleton].signState = MayiSignStateSigned;
            [GlobalVar sharedSingleton].uid = [[NSUserDefaults standardUserDefaults] stringForKey:MayiUidKey];
            [GlobalVar sharedSingleton].isloginid = [[NSUserDefaults standardUserDefaults] stringForKey:MayiIsLoginId];
            
//            [self initHomeScreen];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = viewController;
            
            [self.window makeKeyAndVisible];
            [self registerRemoteNotification];
        }
        else {
            [GlobalVar sharedSingleton].signState = MayiSignStateUnSigned;
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
//            UIViewController *viewController = [storyboard instantiateInitialViewController];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = viewController;
            
            [self.window makeKeyAndVisible];
            
        }
//        [self dealPush:launchOptions];
        return YES;
    }
}

-(void)dealPush:(NSDictionary *)launchOptions
{
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
//    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN数据
//    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (message) {
//        DLog(@"message:%@",message);
////        NSString *payloadMsg = [message objectForKey:@"payload"];
////        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
////        [_viewController logMsg:record];
//    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    DLog(@"url:%@",url);
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (url == nil) {
        return NO;
    }
    DLog(@"url:%@，url.host:%@,absoluteString:%@",url,url.host, [url absoluteString]);
    //跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"resultDic:%@",resultDic);
            if ([WDSystemUtils isEqualsInt:9000 andJsonData:[resultDic objectForKey:@"resultStatus"]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MayiPaySuccess object:nil userInfo:resultDic];
            }
            
        }];

    }
    else {
        if ([url absoluteString] != nil && [[url absoluteString] rangeOfString:APP_ID].length > 0) {
            if ([[url absoluteString] rangeOfString:@"ret=0"].length > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MayiPaySuccess object:nil userInfo:nil];
            }
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if (url == nil) {
        return NO;
    }
    DLog(@"url:%@，url.host:%@,absoluteString:%@",url,url.host, [url absoluteString]);
    //跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"resultDic:%@",resultDic);
            if ([WDSystemUtils isEqualsInt:9000 andJsonData:[resultDic objectForKey:@"resultStatus"]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MayiPaySuccess object:nil userInfo:resultDic];
            }
            
        }];
        
    }
    else {
        if ([url absoluteString] != nil && [[url absoluteString] rangeOfString:APP_ID].length > 0) {
            if ([[url absoluteString] rangeOfString:@"ret=0"].length > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MayiPaySuccess object:nil userInfo:nil];
            }
        }
    }
    
    DLog(@"url:%@",url);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [GeTuiSdk enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 微信回调

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



-(void)initHomeScreen{
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc]init];
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:0/255.0f green:160/255.0f  blue:230/255.0f alpha:1.0f];
    //设置控制器为Window的根控制器
    self.window.rootViewController=nav;
    //a.初始化一个tabBar控制器
    
    UIViewController *rootViewController1 = [StoryboadUtil getViewController:@"Main" : @"RootViewController1"];
//    Root *tb=[[UITabBarController alloc]init];
    [nav pushViewController:rootViewController1 animated:YES];

    
  
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
}

-(void) stopSdk {
    [GeTuiSdk enterBackground];
}

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    [_deviceToken release];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    
    
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:_deviceToken];
    
   [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
}

-(void)registDeviceToServer:(NSString *)deviceToken
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:deviceToken forKey:@"wym"];
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiBDWYM parameters:parameters showLoadingView:nil success:^(id responseObject) {
        DLog(@"suucess");
//        [SVProgressHUD showSuccessWithStatus:@"绑定唯一码成功"];
    
    } failture:^(NSError *error) {
  
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
//    [_viewController logMsg:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo {
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    if (payloadMsg) {
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
//        [_viewController logMsg:record];
    }
    DLog(@"这里调用了payloadMsg:%@",payloadMsg);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    if (payloadMsg && contentAvailable) {
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
//        [_viewController logMsg:record];
        DLog(@"applicationState:%ld",(long)[UIApplication sharedApplication].applicationState);
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            NSNotification *notifiction = [NSNotification notificationWithName:MayiBackgroundNotifiction object:nil userInfo:[NSDictionary dictionaryWithObject:contentAvailable forKey:@"content-available"]];
            [[NSNotificationCenter defaultCenter] postNotification:notifiction];
        }
    }
//    DLog(@"payloadMsg:%@，aps:%@,contentAvailable:%@",payloadMsg,aps,contentAvailable);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    
    NSError *err = nil;
    
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
    
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    if (err) {
//        [_viewController logMsg:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
        [SVProgressHUD showErrorWithStatus:@"注册个推失败"];
    }
}

- (void)setDeviceToken:(NSString *)aToken
{
    
    [GeTuiSdk registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    return [GeTuiSdk setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    
    return [GeTuiSdk sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    [GeTuiSdk bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    
    [GeTuiSdk unbindAlias:aAlias];
}

- (void)testSdkFunction
{
//    UIViewController *funcsView = [[TestFunctionController alloc] initWithNibName:@"TestFunctionController" bundle:nil];
//    [_naviController pushViewController:funcsView animated:YES];
//    [funcsView release];
}

- (void)testGetClientId {
//    NSString *clientId = [GeTuiSdk clientId];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前的CID" message:clientId delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alertView show];
//    [alertView release];
}

#pragma mark - GexinSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    _clientId = clientId;
    
    if (_deviceToken) {
        [GeTuiSdk registerDeviceToken:_deviceToken];
        
         [self registDeviceToServer:clientId];
    }
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
//    [_payloadId release];
//    _payloadId = [payloadId retain];
////    
    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];
    
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    

    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSNotification *notifiction = [NSNotification notificationWithName:MayiBackgroundNotifiction object:nil userInfo:[NSDictionary dictionaryWithObject:payloadMsg forKey:@"content-available"]];
        [[NSNotificationCenter defaultCenter] postNotification:notifiction];
        DLog(@"UIApplicationStateBackground payloadMsg:%@",payloadMsg);
    }
    DLog(@"payloadMsg:%@",payloadMsg);
//    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"payloadMsg:%@",payloadMsg]];
    
}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//    [_viewController logMsg:record];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
//    _sdkStatus = aStatus;
//    [_viewController updateStatusView:self];
}

//SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
//    if (error) {
//        [_viewController logMsg:[NSString stringWithFormat:@">>>[SetModeOff error]: %@", [error localizedDescription]]];
//        return;
//    }
//    
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@",isModeOff?@"开启":@"关闭"]];
//    
//    UIViewController *vc = _naviController.topViewController;
//    if ([vc isKindOfClass:[DemoViewController class]]) {
//        DemoViewController *nextController = (DemoViewController *)vc;
//        [nextController updateModeOffButton:isModeOff];
//    }
    
}

-(NSString*) formateTime:(NSDate*) date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}

static void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}


@end
