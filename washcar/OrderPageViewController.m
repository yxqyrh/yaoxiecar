//
//  OrderPageViewController.m
//  washcar
//
//  Created by CSB on 15/9/25.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "OrderPageViewController.h"
#import "SCNavTabBarController.h"
#import "OrderListViewController.h"

@interface OrderPageViewController () {
    SCNavTabBarController *_navTabBarController;
}

@end

@implementation OrderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *vcs = [NSMutableArray array];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    OrderListViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    viewController.pageType = 1;
    viewController.title = @"当前订单";
    [vcs addObject:viewController];
    
    viewController = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    viewController.pageType = 2;
    viewController.title = @"已完成订单";
    [vcs addObject:viewController];
    
    viewController = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    viewController.pageType = 3;
    viewController.title = @"已退订单";
    [vcs addObject:viewController];
    
    _navTabBarController = [[SCNavTabBarController alloc] init];
    _navTabBarController.subViewControllers = vcs;
    _navTabBarController.showArrowButton = FALSE;
    _navTabBarController.pageTagString = @"OrderPage";
    [_navTabBarController addParentController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectRunningOrder) name:MayiOrderRunningNotifiction object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFinishedOrder) name:MayiOrderFinishedNotifiction object:nil];
        
//    QCSlideViewController *slideSwitchVC = [[QCSlideViewController alloc] init];
//    QCViewController * drawerController = [[QCViewController alloc]
//                                           initWithCenterViewController:slideSwitchVC
//                                           leftDrawerViewController:nil
//                                           rightDrawerViewController:nil];
//    [drawerController setMaximumLeftDrawerWidth:120];
//    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//        MMDrawerControllerDrawerVisualStateBlock block;
//        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
//        block(drawerController, drawerSide, percentVisible);
//    }];
//    [self addChildViewController:drawerController];
//    
//    [drawerController didMoveToParentViewController:self];
}

-(void)selectRunningOrder
{
    [_navTabBarController setCurrentIndex:0];
}

-(void)selectFinishedOrder
{
    [_navTabBarController setCurrentIndex:1];
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
