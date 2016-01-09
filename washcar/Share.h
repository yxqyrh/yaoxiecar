//
//  Share.h
//  washcar
//
//  Created by jingyaxie on 16/1/9.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"
#import "Constant.h"
@interface Share : UIView
@property (nonatomic, weak)UIViewController *parentVC;
@property (strong, nonatomic) IBOutlet UIView *innerView;
+ (instancetype)defaultPopupView;
-(void)showView;
-(void)hideView;
@end
