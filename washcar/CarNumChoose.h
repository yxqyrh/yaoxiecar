//
//  CarNumChoose.h
//  washcar
//
//  Created by xiejingya on 1/15/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"
@protocol CarNumChooseDelegate<NSObject> // 代理传值方法
@required
- (void)setWashStyle:(NSDictionary*)dic;
@end
@interface CarNumChoose : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak)UIViewController *parentVC;
@property (strong, nonatomic) IBOutlet UIView *innerView;
+ (instancetype)defaultPopupView;
@property (nonatomic) id<CarNumChooseDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *dataArray;

-(void)initTableView;

@end
