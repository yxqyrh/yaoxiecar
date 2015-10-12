//
//  RootViewController1.m
//  washcar
//
//  Created by CSB on 15/10/10.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "RootViewController1.h"
#import "StoryboadUtil.h"

#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "QCSlideViewController.h"

@interface RootViewController1 ()

@end

@implementation RootViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *c1 = [StoryboadUtil getViewController:@"home" :@"HomeViewController"];
    //    c1.view.backgroundColor=[UIColor grayColor];
    //    c1.view.backgroundColor=[UIColor greenColor];
    c1.tabBarItem.title=@"首页";
    c1.tabBarItem.image=[UIImage imageNamed:@"img_01_car_pre"];
    //    c1.tabBarItem.badgeValue=@"123";
    
    
    QCSlideViewController *slideSwitchVC = [[QCSlideViewController alloc] init];
    QCViewController * drawerController = [[QCViewController alloc]
                                           initWithCenterViewController:slideSwitchVC
                                           leftDrawerViewController:nil
                                           rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:120];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    
//    UIViewController *c2 = [StoryboadUtil getViewController:@"Order" :@"OrderPageViewController"];
//    //    c2.view.backgroundColor=[UIColor brownColor];
    drawerController.tabBarItem.title=@"订单列表";
    drawerController.tabBarItem.image=[UIImage imageNamed:@"img_02_order_pre"];
    
    UIViewController *c3 = [StoryboadUtil getViewController:@"UserCenter" :@"UserCenterViewController"];
    c3.tabBarItem.title=@"个人中心";
    c3.tabBarItem.image=[UIImage imageNamed:@"img_03_me_pre"];
    //c.添加子控制器到ITabBarController中
    //c.1第一种方式
    //    [tb addChildViewController:c1];
    //    [tb addChildViewController:c2];
    
    //c.2第二种方式
    self.viewControllers=@[c1,drawerController,c3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrder) name:MayiOrderNotifiction object:nil];
    
    //    [NSNotificationCenter defaultCenter] addObserverForName:@"OrderNotifiction" object:nil queue:mo; usingBlock:<#^(NSNotification * _Nonnull note)block#>
}

-(void)showOrder
{
    
    self.selectedIndex = 1;
    
}

-(void)rightOnclick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-877-8675"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
