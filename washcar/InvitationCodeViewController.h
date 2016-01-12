//
//  InvitationCodeViewController.h
//  washcar
//
//  Created by jingyaxie on 16/1/8.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Share.h"
#import "MayiHttpRequestManager.h"
@interface InvitationCodeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *myCode;

@end
