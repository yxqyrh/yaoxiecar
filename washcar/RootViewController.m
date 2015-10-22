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
#import <SVProgressHUD.h>
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
    

    
    
    
    UIViewController *orderPage = [StoryboadUtil getViewController:@"Order" :@"OrderPageViewController"];
    
    
    [self addChildViewController:orderPage];
    [orderPage didMoveToParentViewController:self];
    

    UIViewController *controller2 = [StoryboadUtil getViewController:@"UserCenter" :@"UserCenterViewController"];
    
    
    [self addChildViewController:controller2];
    [controller2 didMoveToParentViewController:self];
    
    _viewControllers = @[controller0, orderPage, controller2];
    
//        [_tabBar selectItem:0];
   
    [self.view addSubview:_transparentView];
    [self.navigationController.view addSubview:_titleTransparentView];
    
//    UIActionSheet *sheet1 = [[UIActionSheet alloc] initWithTitle:@"没报错1" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
//    [sheet1 showInView:_contentView];
//    return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrder) name:MayiOrderNotifiction object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIndexPage) name:MayiIndexPageNotifiction object:nil];
    
    _selectedIndex = -1;
    
    if ([GlobalVar sharedSingleton].launchOptions) {
        [self dealNotifiction:[GlobalVar sharedSingleton].launchOptions];
    }
    else {
        [self selectItem:0 completion:nil];
        _tabBar.selectedItem = [_tabBar.items objectAtIndex:0];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealBackgroudNotifiction:) name:MayiBackgroundNotifiction object:nil];
    
}

-(void)jumpPageWithJudge:(bool)isJudgeSignState andSignedBlock:(CompleteBlock)signedBlock andUnSignedBlock:(CompleteBlock)unSignedBlock
{
    if (signedBlock == nil) {
        DLog(@"completeBlock is nil");
        return;
    }
    
    if (!isJudgeSignState) {
        if ([GlobalVar sharedSingleton].signState == MayiSignStateSigned) {
            signedBlock();
        }
        else if ([GlobalVar sharedSingleton].signState == MayiSignStateUnSigned) {
            unSignedBlock();
        }
    }
    else {
        if ([GlobalVar sharedSingleton].signState == MayiSignStateSigned) {
            signedBlock();
        }
        else if ([GlobalVar sharedSingleton].signState == MayiSignStateUnSigned) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
            UIViewController *viewController = [storyBoard instantiateInitialViewController];
            [self presentViewController:viewController animated:YES completion:nil];
            [GlobalVar sharedSingleton].signState = MayiSignStateSigning;
            
            while ([GlobalVar sharedSingleton].signState == MayiSignStateSigning) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            if ([GlobalVar sharedSingleton].signState == MayiSignStateSigned) {
                signedBlock();
            }
            else if ([GlobalVar sharedSingleton].signState == MayiSignStateUnSigned) {
                unSignedBlock();
            }
        }
    }
    
}

-(void)dealBackgroudNotifiction:(NSNotification *)notificition
{
    NSDictionary *userInfo = notificition.userInfo;
    
    NSString *contentAvailable = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"content-available"]];
//    UINavigationController *nav = self.navigationController;
//    if (self.navigationController.viewControllers.count > 1) {
//        UIViewController *vc = [self.navigationController.topViewController];
//        
////        for (int i = self.navigationController.viewControllers.count - 1; i > 0; i--) {
////            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:i];
////            [vc removeFromParentViewController];
////        }
//        
//    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    
     [self jumpController:contentAvailable];
}

-(void)dealNotifiction:(NSDictionary *)userInfo
{
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *contentAvailable = [NSString stringWithFormat:@"%@",[aps objectForKey:@"content-available"]];
    
    
    
    [self jumpController:contentAvailable];

    
}

-(void)jumpController:(NSString *)contentAvailable
{
    if ([contentAvailable rangeOfString:@"1"].length > 0) {
        
        
        [self selectItem:1 completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiOrderRunningNotifiction object:nil];
        }];
        _tabBar.selectedItem = [_tabBar.items objectAtIndex:1];
    }
    //    else {
    else if ([contentAvailable rangeOfString:@"2"].length > 0) {
        
        
        [self selectItem:1 completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiOrderFinishedNotifiction object:nil];
        }];
        _tabBar.selectedItem = [_tabBar.items objectAtIndex:1];
    }
    
    [GlobalVar sharedSingleton].userInfo = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
    if ([item.title isEqualToString:@"蚂蚁洗车"]) {
        index = 0;
    }
    else if ([item.title isEqualToString:@"我的订单"]) {
        index = 1;
    }
    else {
        index = 2;
    }
    
    bool isJudge = YES;
    if (index == 0) {
        isJudge = NO;//当前处于第一个tabitem时点第一个不跳转
    }

    [self jumpPageWithJudge:isJudge andSignedBlock:^{
        DLog(@"signed");
        [self selectItem:index completion:nil];
    } andUnSignedBlock:^{
        DLog(@"unSigned");
        if (index != 0) {
            _selectedIndex = 0;
            _tabBar.selectedItem = [_tabBar.items objectAtIndex:0];
        }
        else {
            [self selectItem:index completion:nil];
        }
    }];
    
//    [self selectItem:index completion:nil];
}

-(void)showOrder
{
    _tabBar.selectedItem = [_tabBar.items objectAtIndex:1];
    
    [self tabBar:_tabBar didSelectItem:[_tabBar.items objectAtIndex:1]];
}

-(void)showIndexPage
{
    _tabBar.selectedItem = [_tabBar.items objectAtIndex:0];
    [self tabBar:_tabBar didSelectItem:[_tabBar.items objectAtIndex:0]];
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
            self.titleLabel.text = @"蚂蚁洗车";
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
