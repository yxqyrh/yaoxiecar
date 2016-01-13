//
//  ColorChoosePop.h
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
@protocol ColorChoosePopDelegate<NSObject> // 代理传值方法
@required
- (void)sendColorValue:(NSInteger)value;
@end

@interface ColorChoosePop : UIView
@property (nonatomic, weak)UIViewController *parentVC;
@property (strong, nonatomic) IBOutlet UIView *innerView;

@property (strong, nonatomic) IBOutlet UIView *whiteView;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (strong, nonatomic) IBOutlet UIView *yellowView;
@property (strong, nonatomic) IBOutlet UIView *darkBlueView;
@property (strong, nonatomic) IBOutlet UIView *redView;
@property (strong, nonatomic) IBOutlet UIView *greenView;
@property (strong, nonatomic) IBOutlet UIView *brownView;
@property (strong, nonatomic) IBOutlet UIView *silveryGrayView;
@property (strong, nonatomic) IBOutlet UIView *purpleView;
@property (strong, nonatomic) IBOutlet UIView *lightBlueView;
@property (strong, nonatomic) IBOutlet UIView *goldenYellowView;
@property (strong, nonatomic) IBOutlet UIView *creamColorView;



// 委托代理人，代理一般需使用弱引用(weak)
@property (nonatomic) id<ColorChoosePopDelegate> delegate;
+ (instancetype)defaultPopupView;

+(NSString *)colorNameByValue:(int)value;

@end
