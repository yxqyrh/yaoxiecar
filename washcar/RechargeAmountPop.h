//
//  RechargeAmountPop.h
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"
@protocol RechargeAmountPopDelegate<NSObject> // 代理传值方法
@required
- (void)setRechargeValue:(int)value;
@end

@interface RechargeAmountPop : UIView
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UIImageView *_100Check;
@property (weak, nonatomic) IBOutlet UIImageView *_200Check;
@property (weak, nonatomic) IBOutlet UIImageView *_300Check;
@property (weak, nonatomic) IBOutlet UIImageView *_600Check;
@property (weak, nonatomic) IBOutlet UIImageView *_50Check;
+ (instancetype)defaultPopupView;
@property (nonatomic) id<RechargeAmountPopDelegate> delegate;

@property (nonatomic)bool isSC;
@property (nonatomic)int prevSelectMoney;

@end