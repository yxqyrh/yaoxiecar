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
#import "WDLocationHelper.h"
#import "LocationChooseViewController1.h"
#import "BaseViewController.h"
#import "ChePaiPickView.h"
#import <AMapLocationKit/AMapLocationKit.h>


@interface UserInfoViewController : BaseViewController<ColorChoosePopDelegate,LocationChooseViewControllerDelegate,LocationChoosePopDelegate,ChePaiPickViewDelegate,LocationChooseDelegate,WDLocationHelperDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *CarNum;
@property (weak, nonatomic) IBOutlet UIButton *provinceShort;
@property (weak, nonatomic) IBOutlet UIButton *A_Z;

@property (weak, nonatomic) IBOutlet UITextField *CarColor;

@property (weak, nonatomic) IBOutlet UITextField *Loaction;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoney;
@property (weak, nonatomic) IBOutlet UITextField *cheweihao;
-(void) refresh;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *clid;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end
