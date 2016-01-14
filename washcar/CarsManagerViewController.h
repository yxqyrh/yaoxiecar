//
//  CarsManagerViewController.h
//  washcar
//
//  Created by xiejingya on 1/13/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserInfoViewController.h"
#import "StoryboadUtil.h"
#import "MayiHttpRequestManager.h"
@interface CarsManagerViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;@end
