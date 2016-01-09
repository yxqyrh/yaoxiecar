//
//  CarManagerViewController.h
//  washcar
//
//  Created by jingyaxie on 16/1/8.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserInfoViewController.h"
#import "StoryboadUtil.h"

@interface CarManagerViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
