//
//  QCSlideViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCSlideViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "QCListViewController.h"

@interface QCSlideViewController ()

@end

@implementation QCSlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"滑动切换视图";
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [UIColor blueColor];
//    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
//                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    OrderListViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    
    viewController.pageType = 1;
    self.runningOrderController = viewController;
    self.runningOrderController.title = @"当前订单";
    
    viewController = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    viewController.pageType = 2;
    self.finnishOrderController = viewController;
    self.finnishOrderController.title = @"已完成订单";
    
    viewController = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    viewController.pageType = 3;
    self.cancelOrderController = viewController;
    self.cancelOrderController.title = @"已退订单";

    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法


- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 3;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.runningOrderController;
    } else if (number == 1) {
        return self.finnishOrderController;
    } else if (number == 2) {
        return self.cancelOrderController;
    }  else {
        return nil;
    }
}

//- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
//{
//    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
//}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    OrderListViewController *vc = nil;
    if (number == 0) {
        vc = self.runningOrderController;
    } else if (number == 1) {
        vc = self.finnishOrderController;
    } else if (number == 2) {
        vc = self.cancelOrderController;
    }
    [vc viewDidCurrentView];
}

#pragma mark - 内存报警

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
