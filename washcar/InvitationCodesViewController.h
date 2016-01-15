//
//  InvitationCodesViewController.h
//  washcar
//
//  Created by xiejingya on 1/13/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MayiHttpRequestManager.h"
#import "StringUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface InvitationCodesViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *myCode;
@end
