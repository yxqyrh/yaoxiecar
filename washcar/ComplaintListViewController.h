//
//  ComplaintListViewController.h
//  washcar
//
//  Created by jingyaxie on 16/1/21.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StringUtil.h"

@interface ComplaintListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
