//
//  WashStyleChoose.h
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
@protocol WashStyleChooseDelegate<NSObject> // 代理传值方法
@required
- (void)setWashStyle:(NSInteger*)value;
@end

@interface WashStyleChoose : UIView
@property (nonatomic, weak)UIViewController *parentVC;

@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIButton *carOut;
@property (weak, nonatomic) IBOutlet UIButton *carIn;
+ (instancetype)defaultPopupView;
@property (nonatomic) id<WashStyleChooseDelegate> delegate;
-(void)refresh:(NSString*)washStyle;
@end