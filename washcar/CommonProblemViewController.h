//
//  CommonProblemViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollapseClick.h"
#import "Constant.h"
#import "BaseViewController.h"
#import "TQMultistageTableView.h"
@interface CommonProblemViewController : BaseViewController<UITextFieldDelegate,TQTableViewDataSource,TQTableViewDelegate>{

    
}
@property (nonatomic, strong) TQMultistageTableView *mTableView;

@end
