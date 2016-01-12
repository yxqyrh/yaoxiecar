//
//  WashEditViewController.h
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LocationChoosePop.h"
#import "PayTableViewController.h"

#import "UserInfo.h"
#import "WashType.h"
#import "ColorChoosePop.h"
#import "LocationChoosePop.h"
#import "WashStyleChoose.h"
#import "LocationChooseViewController1.h"
#import "VoucherChoosePop.h"

@interface WashEditViewController : BaseTableViewController <UITextViewDelegate,PayCompleteDelegate,ColorChoosePopDelegate,LocationChoosePopDelegate,WashStyleChooseDelegate,LocationChooseDelegate,VoucherChoosePopDelegate>

@end
