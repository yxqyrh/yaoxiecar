//
//  UserCenterViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "MyMsgViewController.h"
#import "VouchersThreeViewController.h"
#import "CommonProblemViewController.h"
#import "ComplaintViewController.h"
#import "ProgressHUD.h"
@interface UserCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoney;

@end
