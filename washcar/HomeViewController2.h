//
//  HomeViewController2.h
//  washcar
//
//  Created by xiejingya on 10/4/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "StringUtil.h"
#import "WebViewController.h"

typedef void(^signCompleteBlock)();

@interface HomeViewController2: BaseViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *lunboBody;


@end

