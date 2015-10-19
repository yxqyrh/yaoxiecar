//
//  PayTableViewController.h
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol PayCompleteDelegate <NSObject>

-(void)PayType:(int)type andValue:(CGFloat)payValue;

@end

@interface PayTableViewController : BaseTableViewController

@property (nonatomic)NSString *order;

@property (nonatomic)NSString *accountBalance;

@property (nonatomic)NSString *payValue;

@property (nonatomic)id<PayCompleteDelegate> delegate;

@property (nonatomic)NSMutableDictionary *washParameters;



@end
