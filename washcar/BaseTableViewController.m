//
//  BaseTableViewController.m
//  WDLinkUp
//
//  Created by William REN on 10/13/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()


@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1];
    
    // hide back button on navigation bar
    self.navigationItem.hidesBackButton = YES;
    if (!_leftButton) {
        UIButton *navigationBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        navigationBarLeftButton.frame = CGRectMake(0, 0, 48, 33);
        [navigationBarLeftButton setBackgroundImage:[UIImage imageNamed:@"navigation_bar_back_button.png"]
                               forState:UIControlStateNormal];
        [navigationBarLeftButton addTarget:self
                        action:@selector(backButtonTouchUpInside:)
              forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:navigationBarLeftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
//    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    
    // navigation bar background color
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.09 green:0.54 blue:0.86 alpha:1];
//    } else {
//        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.09 green:0.54 blue:0.86 alpha:1];
//    }
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // delete navigationbar shadow
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_color.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
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


// back button clicked
- (IBAction)backButtonTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
