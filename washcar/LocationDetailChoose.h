//
//  LocationDetailChoose.h
//  washcar
//
//  Created by xiejingya on 9/30/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"

@protocol LocationDetailChooseDelegate<NSObject> // 代理传值方法
@required
- (void)sendValue:(NSInteger)value;
@end
@interface LocationDetailChoose : UIView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
// 委托代理人，代理一般需使用弱引用(weak)
@property (nonatomic) id<LocationDetailChooseDelegate> delegate;
@property (nonatomic, weak)UIViewController *parentVC;
+ (instancetype)defaultPopupView;
@property NSString *area_id;//地区id
@property int channel;//代表是0 代表省份  1：city  2：area   3：smallArea
@end
