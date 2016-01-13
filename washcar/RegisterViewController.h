//
//  RegisterViewController.h
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ColorChoosePop.h"
#import "LocationChoosePop.h"
#import "LocationChooseViewController.h"
#import "LocationInfo.h"
#import "NIAttributedLabel.h"
#import "ChePaiPickView.h"
#import "WDLocationHelper.h"

@interface RegisterViewController : BaseTableViewController<ColorChoosePopDelegate,LocationChoosePopDelegate,LocationChooseViewControllerDelegate,NIAttributedLabelDelegate,ChePaiPickViewDelegate,WDLocationHelperDelegate>


@end
