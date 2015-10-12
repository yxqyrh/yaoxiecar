//
//  ReChargeViewController.h
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RechargeAmountPop.h"

@interface ReChargeViewController : BaseTableViewController<RechargeAmountPopDelegate>

@property (nonatomic)double checkInMoney;


@end
