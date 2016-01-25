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
- (void)setRechargeValue:(int)value:(NSInteger)row;
@end

@interface RechargeAmountPop : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
+ (instancetype)defaultPopupView;
@property (nonatomic) id<RechargeAmountPopDelegate> delegate;
@property NSInteger current_seleted_row;
@property (nonatomic)bool isSC;
//@property (nonatomic)int prevSelectMoney;
@property NSArray *rechargeArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end