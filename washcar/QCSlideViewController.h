//
//  QCSlideViewController.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "QCListViewController.h"
#import "QCViewController.h"

#import "OrderListViewController.h"

@interface QCSlideViewController : UIViewController<QCSlideSwitchViewDelegate>
{
}

@property (nonatomic, strong) IBOutlet QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) OrderListViewController *runningOrderController;
@property (nonatomic, strong) OrderListViewController *finnishOrderController;
@property (nonatomic, strong) OrderListViewController *cancelOrderController;
//@property (nonatomic, strong) QCListViewController *vc4;
//@property (nonatomic, strong) QCListViewController *vc5;
//@property (nonatomic, strong) QCListViewController *vc6;

@end

