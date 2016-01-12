//
//  UserInfoViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationChoosePop.h"
#import "ColorChoosePop.h"
#import "VoucherChoosePop.h"
#import "LocationChooseViewController.h"
#import "BaseViewController.h"
#import "ChePaiPickView.h"
@interface UserInfoViewController : BaseViewController<ColorChoosePopDelegate,LocationChooseViewControllerDelegate,LocationChoosePopDelegate,ChePaiPickViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *CarNum;
@property (weak, nonatomic) IBOutlet UIButton *provinceShort;
@property (weak, nonatomic) IBOutlet UIButton *A_Z;
@property (weak, nonatomic) IBOutlet UILabel *CarColor;
@property (weak, nonatomic) IBOutlet UILabel *Loaction;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoney;
@property (weak, nonatomic) IBOutlet UITextField *cheweihao;
-(void) refresh;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
