
//
//  VouchersAllViewController.m
//  washcar
//
//  Created by xiejingya on 9/28/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import "VouchersThreeViewController.h"

@interface VouchersThreeViewController (){
    UIStoryboard *board ;
}

@end

@implementation VouchersThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"洗车券";
    board = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    VouchersViewController *noused = [board instantiateViewControllerWithIdentifier:@"VouchersViewController"];
    noused.title = @"未使用";
    noused.voucherType = 1;
    [vcs addObject:noused];
    VouchersViewController *used = [board instantiateViewControllerWithIdentifier:@"VouchersViewController"];
    used.title = @"已使用";
    used.voucherType = 2;
    
    [vcs addObject:used];
    VouchersViewController * all =[board instantiateViewControllerWithIdentifier:@"VouchersViewController"];
    all.title = @"已过期";
    all.voucherType = 3;
    [vcs addObject:all];
    
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = vcs;
    navTabBarController.showArrowButton = FALSE;
    [navTabBarController addParentController:self];
    
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
