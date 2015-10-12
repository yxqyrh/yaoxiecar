//
//  ComplaintViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ComplaintViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *complaintContent;

@end
