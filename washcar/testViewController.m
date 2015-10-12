//
//  testViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController
- (IBAction)show1:(id)sender {
    LocationChoosePop *view = [LocationChoosePop defaultPopupView];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
 
}
- (IBAction)show2:(id)sender {
    ColorChoosePop *view = [ColorChoosePop defaultPopupView];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
    
}
- (IBAction)show3:(id)sender {
    
    WashStyleChoose *view = [WashStyleChoose defaultPopupView];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
    
}
- (IBAction)show4:(id)sender {
    
    
    VoucherChoosePop *view = [VoucherChoosePop defaultPopupView];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
- (IBAction)show5:(id)sender {
    
  
}
- (IBAction)show6:(id)sender {
    RechargeAmountPop *view = [RechargeAmountPop defaultPopupView];
    view.parentVC = self;
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
