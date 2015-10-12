//
//  LocationChoosePop.h
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
#import "BaseViewController.h"
@protocol LocationChoosePopDelegate<NSObject> // 代理传值方法
@required
- (void)showDetailChoose:(int)channel;
-(void)ok;
@end

@interface LocationChoosePop : UIView




@property (nonatomic, weak)UIViewController *parentVC;

@property (strong, nonatomic) IBOutlet UIView *innerView;

@property (weak, nonatomic) IBOutlet UIButton *chooseProvince;

@property (weak, nonatomic) IBOutlet UIButton *chooseCity;
@property (weak, nonatomic) IBOutlet UIButton *chooseArea;

@property (weak, nonatomic) IBOutlet UIButton *chooseStreet;

-(void)initWithDic:(NSDictionary *)result;

+ (instancetype)defaultPopupView;

@property (nonatomic) id<LocationChoosePopDelegate> mydelegate;

@end
