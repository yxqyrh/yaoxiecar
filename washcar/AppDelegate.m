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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [GlobalVar sharedSingleton].launchOptions = userInfo;
        application.applicationIconBadgeNumber = 0;
    }
    
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
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
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
    [self registerRemoteNotification];
    
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
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
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    [self registDeviceToServer:_deviceToken];
    
}

-(void)registDeviceToServer:(NSString *)deviceToken
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:deviceToken forKey:@"wym"];
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiBDWYM parameters:parameters showLoadingView:nil success:^(id responseObject) {
        DLog(@"suucess");

    
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
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    if (payloadMsg && contentAvailable) {
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
//        [_viewController logMsg:record];
    }
    
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
    }
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
//    [_payloadId release];
//    _payloadId = [payloadId retain];
//    
//    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];
//    
//    NSString *payloadMsg = nil;
//    if (payload) {
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
//                                              length:payload.length
//                                            encoding:NSUTF8StringEncoding];
//    }
//    
//    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg];
//    [_viewController logMsg:record];
//    [_viewController updateMsgCount:_lastPaylodIndex];
    
    DLog(@"task id : %@, messageId:%@", taskId, aMsgId);
    
//    [payloadMsg release];
    
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
