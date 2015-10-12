//
//  MainViewController.m
//  WDLinkUp
//
//  Created by William REN on 11/6/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "RootViewController.h"

#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "QCSlideViewController.h"
#import "StoryboadUtil.h"

#import "WDTabBar.h"


#define kTabBarHeight = 40.0f;

@interface RootViewController () {
    NSArray *_viewControllers;
    UIViewController *_selectedViewController;
    UIView *_transparentView;
    UIView *_titleTransparentView;
    int _selectedIndex;
    
    NSDictionary *_userInfo;
}


@property (retain, nonatomic) IBOutlet WDTabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *navigationLeftView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _transparentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _transparentView.backgroundColor = [UIColor blackColor];
    _transparentView.alpha = 0.0;
    _transparentView.hidden = YES;
    
    _titleTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    _titleTransparentView.backgroundColor = [UIColor blackColor];
    _titleTransparentView.alpha = 0.0;
    _titleTransparentView.hidden = YES;
    
//    _tabBar.selectBlock = ^(int index) {
//        [self selectItem:index completion:nil];
//    };
    
    _tabBar.delegate = self;
    
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"home" bundle:nil];
    UIViewController *controller0 = [StoryboadUtil getViewController:@"home" :@"HomeViewController"];
    [self addChildViewController:controller0];
    [controller0 didMoveToParentViewController:self];
    
    UIViewController *controller1 = [StoryboadUtil getViewController:@"Order" :@"OrderPageViewController"];
    
    
    [self addChildViewController:controller1];
    
    [controller1 didMoveToParentViewController:self];
    
    
//    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
//    navTabBarController.subViewControllers = vcs;
//    navTabBarController.showArrowButton = FALSE;
//    [navTabBarController addParentController:self];
//    
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
    
    
    
    UIViewController *orderPage = [StoryboadUtil getViewController:@"Order" :@"OrderPageViewController"];
    
    
    [self addChildViewController:orderPage];
    [orderPage didMoveToParentViewController:self];
    
    
    
    //    UIViewController *controller2 = [[UIViewController alloc] init];
    //    controller2.view.backgroundColor = [UIColor orangeColor];
    UIViewController *controller2 = [StoryboadUtil getViewController:@"UserCenter" :@"UserCenterViewController"];
    
    
    [self addChildViewController:controller2];
    [controller2 didMoveToParentViewController:self];
    
    _viewControllers = @[controller0, orderPage, controller2];
    
//        [_tabBar selectItem:0];
   
    [self.view addSubview:_transparentView];
    [self.navigationController.view addSubview:_titleTransparentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrder) name:MayiOrderNotifiction object:nil];
    
    _selectedIndex = -1;
     [self selectItem:0 completion:nil];
    
    //    [NSNotificationCenter defaultCenter] addObserverForName:@"OrderNotifiction" object:nil queue:mo; usingBlock:<#^(NSNotification * _Nonnull note)block#>
    _tabBar.selectedItem = [_tabBar.items objectAtIndex:0];
}

//- (void)tabBarItemBeSelected:(int)index
//{
//     [self selectItem:index completion:nil];
//}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    if ([item isEqual:_tabBar.selectedItem]) {
//        return;
//    }
    
    int index = 0;
    if ([item.title isEqualToString:@"首页"]) {
        index = 0;
    }
    else if ([item.title isEqualToString:@"订单"]) {
        index = 1;
    }
    else {
        index = 2;
    }
    [self selectItem:index completion:nil];
}

-(void)showOrder
{
    _tabBar.selectedItem = [_tabBar.items objectAtIndex:1];
    
    [self tabBar:_tabBar didSelectItem:[_tabBar.items objectAtIndex:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)selectItem:(int)index completion:(void (^)(BOOL finished))completion {
    if (_viewControllers.count <= index) {
        return;
    }
    self.title = @"";
    _navigationLeftView.hidden = YES;
    
    switch (index) {
        case 0: {
            self.titleLabel.text = @"首页";
            //            _navigationTitleLabel.hidden = NO;
            //            _navigationTitleLabel.text = @"动态";
            //            _navigationBarRightButton.hidden = NO;
            //            _rightSearchButton.hidden = NO;
            //            [_navigationBarRightButton setTitle:@"发动态" forState:UIControlStateNormal];
            //            [_navigationBarRightButton setImage:[UIImage imageNamed:@"btn_create_new.png"] forState:UIControlStateNormal];
            break;
        }
        case 1: {
            self.titleLabel.text = @"我的订单";
            //            self.title = @"消息";
            //            _navigationTitleLabel.hidden = NO;
            //            _navigationTitleLabel.text = @"消息";
            //            _navigationBarRightButton.hidden = NO;
            //            [_navigationBarRightButton setImage:[UIImage imageNamed:@"btn_create_new.png"] forState:UIControlStateNormal];
            break;
        }
        case 2: {
            self.titleLabel.text = @"个人中心";
            //            self.title = @"任务";
            //            _navigationLeftView.hidden = NO;
            //            _navigationTitleView.hidden = NO;
            //            _navigationBarRightButton.hidden = NO;
            
            
            //            if (_taskRootViewController.isProject) {
            //
            //                [_navigationBarRightButton setImage:[UIImage imageNamed:@"btn_create_new.png"] forState:UIControlStateNormal];
            //            } else {
            //               [_navigationBarRightButton setImage:[UIImage imageNamed:@"btn_create_new.png"] forState:UIControlStateNormal];
            //            }
            break;
        }
        case 3: {
            _navigationLeftView.hidden = NO;
            //            _calendarNavigationView.hidden = NO;
            //            if (_calendarRootViewController.isColleagueCalendar) {
            //                _navigationBarRightButton.hidden = YES;
            //            }
            //            else {
            //                _navigationBarRightButton.hidden = NO;
            //            }
            
            break;
        }
    }
    
    if (index == _selectedIndex) {
        return;
    }
    
    int previousIndex = _selectedIndex;
    _selectedIndex = index;
    UIViewController *fromViewController;
    UIViewController *toViewController;
    fromViewController = _selectedViewController;
    _selectedViewController = [_viewControllers objectAtIndex:index];
    toViewController = _selectedViewController;
    if (toViewController == nil) {
        [fromViewController.view removeFromSuperview];
        return;
    }
    if (fromViewController == nil) {
        toViewController.view.frame = _contentView.bounds;
        [_contentView addSubview:toViewController.view];
        
        if (completion != nil) {
            completion(YES);
        }
        
//        [_tabBar selectItem:index hasOperation:NO];
        
        return;
    }
    
    CGRect rect = _contentView.bounds;
    if (previousIndex < index) {
        rect.origin.x = rect.size.width;
    } else {
        rect.origin.x = -rect.size.width;
    }
    
    toViewController.view.frame = rect;
    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0.3
                               options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                            animations:^ {
                                
//                                _tabBar.itemsEnable = NO;
                                CGRect rect = fromViewController.view.frame;
                                if (previousIndex < index) {
                                    rect.origin.x = -rect.size.width;
                                } else {
                                    rect.origin.x = rect.size.width;
                                }
                                
                                fromViewController.view.frame = rect;
                                toViewController.view.frame = _contentView.bounds;
                            }
                            completion:^(BOOL finished) {
//                                _tabBar.itemsEnable = YES;
                                if (completion != nil) {
                                    completion(finished);
                                }
                                
                            }];
    
    if (completion != nil) {
//        [_tabBar selectItem:index hasOperation:NO];
    }
}

- (IBAction)callPhoneClick:(id)sender {
    [self dialPhoneNumber:@"4008778675"];
    
}

- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    UIWebView *phoneCallWebView = nil;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}


@end
