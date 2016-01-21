//
//  VouchersViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "BaseTableViewController.h"
@interface VouchersViewController : BaseTableViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property int  voucherType ;//0 代表未领取的洗车卷 1：已使用的洗车卷 2：未使用的洗车卷

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end
