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
#import "CarsManagerViewController.h"
#import "InvitationCodesViewController.h"
#import "Masonry.h"
#import "StoryboadUtil.h"
#import "VPImageCropperViewController.h"

#define ORIGINAL_MAX_WIDTH 900.0f

@interface UserCenterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoney;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;

@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIView *btnbody;
@property (weak, nonatomic) IBOutlet UIImageView *yeIcon;

@property (weak, nonatomic) IBOutlet UIView *yeBody;
@end
