//
//  VoucherChoosePop.h
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
#import "VoucherInfo.h"
@protocol VoucherChoosePopDelegate<NSObject> // 代理传值方法
@required
- (void)setVoucherInfo:(VoucherInfo*)value:(NSInteger)row;
@end
@interface VoucherChoosePop : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSArray *voucherInfoArray;
@property NSInteger current_seleted_row;
+ (instancetype)defaultPopupView;
// 委托代理人，代理一般需使用弱引用(weak)
@property (nonatomic) id<VoucherChoosePopDelegate> delegate;
@end