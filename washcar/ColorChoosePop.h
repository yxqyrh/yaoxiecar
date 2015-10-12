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


// 委托代理人，代理一般需使用弱引用(weak)
@property (nonatomic) id<ColorChoosePopDelegate> delegate;
+ (instancetype)defaultPopupView;

+(NSString *)colorNameByValue:(int)value;

@end
