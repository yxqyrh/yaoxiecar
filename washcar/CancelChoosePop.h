//
//  CancelChoosePop.h
//  washcar
//
//  Created by CSB on 15/9/29.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"
#import "PopVoucherTableViewCell.h"
@protocol CancelChoosePopDelegate<NSObject> // 代理传值方法
@required
- (void)complete:(NSString *)unsubscribe1 andSubscribe2:(NSString *)unsubscribe2;
@end
@interface CancelChoosePop : UIView<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITextView *content;
// 委托代理人，代理一般需使用弱引用(weak)
@property (nonatomic) id<CancelChoosePopDelegate> delegate;
@property (nonatomic, weak)UIViewController *parentVC;
+ (instancetype)defaultPopupView;
@property (weak, nonatomic) IBOutlet UIImageView *icon_1;
@property (weak, nonatomic) IBOutlet UIImageView *icon_2;
@property (weak, nonatomic) IBOutlet UIImageView *icon_3;
@property (weak, nonatomic) IBOutlet UIImageView *icon_4;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end
