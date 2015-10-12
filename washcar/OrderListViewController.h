//
//  OrderListViewController.h
//  washcar
//
//  Created by CSB on 15/9/27.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "BaseTableViewController.h"
#import <MJRefresh.h>
#import "CancelChoosePop.h"

@interface OrderListViewController : BaseTableViewController<CancelChoosePopDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

- (void)viewDidCurrentView;

// 1是现在的订单，2是已结束的订单，3是已取消的订单
@property (nonatomic, assign)int pageType;



@end
