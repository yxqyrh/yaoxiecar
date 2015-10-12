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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
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
        }
        else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = viewController;
            
            [self.window makeKeyAndVisible];
        }
        return YES;
    }
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

@end
