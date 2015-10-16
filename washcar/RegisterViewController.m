//
//  RegisterViewController.m
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "RegisterViewController.h"
#import "MayiHttpRequestManager.h"
#import "UserInfo.h"
#import "StoryboadUtil.h"
#import "WebViewController.h"
#import "StringUtil.h"
@interface RegisterViewController () {
    NSString *_carNumber;
    NSString *_carColor;
    NSString *_address;
    NSString *_carPositionNumber;
    NSString *_telephoneNumber;
    NSString *_verifyCode;
    NSString *_verifyCodeId;
    
    UITextField *_carNumberTextField;
    UILabel *_carColorLabel;
    UILabel *_addresssLabel;
    UITextField *_carPositionTextField;
    UITextField *_telephoneTextField;
    UIButton *_codeButton;
    UITextField *_verifyCodeTextField;
    UserInfo *_userInfo;
    UIImageView *_agreeCheckImageView;
    NIAttributedLabel *_agreeLabel;
    bool _isAgree;
    int _timeInterval;
    NSString *_codeButtonTitle;
     ChePaiPickView *chePaiPickView;
    UIButton *provinceStr;
    UIButton *_A_Z;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _carColor = @"红色";
    _userInfo = [[UserInfo alloc ]init];
    _isAgree = YES;
    _codeButtonTitle = @"获取验证码";
    self.view.backgroundColor = GeneralBackgroundColor;
    chePaiPickView = [ChePaiPickView defaultView];
    chePaiPickView.delegate =self;
    [self.view addSubview:chePaiPickView];
  }
-(void)dismissKeyBoard{
    [_carNumberTextField resignFirstResponder];
    [_carPositionTextField resignFirstResponder];
    [_telephoneTextField resignFirstResponder];
    [_verifyCodeTextField resignFirstResponder];
}
//// 点击编辑框外面时，隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_carNumberTextField resignFirstResponder];
    [_carPositionTextField resignFirstResponder];
    [_telephoneTextField resignFirstResponder];
    [_verifyCodeTextField resignFirstResponder];
}
- (void)provinceShortOnclick{
    [chePaiPickView showView];
    [self dismissKeyBoard];
}
- (void)AZChosseOnclick{
    [chePaiPickView showView];
     [self dismissKeyBoard];
}

-(void)valueChange:(NSString *)provinceShort A_Z:(NSString *)A_Z{
    if(provinceShort!=nil&&provinceShort.length>0){
        [provinceStr setTitle:provinceShort forState:UIControlStateNormal];
    }
    if(A_Z!=nil&&A_Z.length>0){
        [_A_Z setTitle:A_Z forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 55;
            break;
        case 1:
            height = 55;
            break;
        case 2:
            height = 55;
            break;
        case 3:
            height = 55;
            break;
        case 4:
            height = 55;
            break;
        case 5:
            height = 55;
            break;
        case 6:
            height = 31;
            break;
        case 7:
            height = 55;
            break;
        case 8:
            height = 15;
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 1) {
        ColorChoosePop *view = [ColorChoosePop defaultPopupView];
        view.parentVC = self;
        view.delegate = self;
        
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{

        }];
        DLog(@"view:%@",view);
    }
    else if (indexPath.row == 2) {
        LocationChoosePop *view = [LocationChoosePop defaultPopupView];
        view.parentVC = self;
        
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            
        }];
        DLog(@"view:%@",view);
    }
    
    if (indexPath.row == 6) {
        _isAgree = !_isAgree;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
   
    if (indexPath.row == 7) {
        [self registerSubmit];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)registerSubmit
{
    
    if ([WDSystemUtils isEmptyOrNullString:provinceStr.titleLabel.text]||[@"省简称" isEqualToString:provinceStr.titleLabel.text]) {
//        [self.view makeToast:@"车牌号的省份简称不能为空"];
        [SVProgressHUD showErrorWithStatus:@"车牌号的省份简称不能为空"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_A_Z.titleLabel.text]||[@"级别" isEqualToString:_A_Z.titleLabel.text]) {
        [SVProgressHUD showErrorWithStatus:@"车牌号的省份字母级别不能为空"];
        return;
    }
    if ([WDSystemUtils isEmptyOrNullString:_carNumberTextField.text]||_carNumberTextField.text.length!=5) {
//        [self.view makeToast:@"车牌后5位数不合法"];
        [SVProgressHUD showErrorWithStatus:@"车牌后5位数不合法"];
        return;
    }
    
//    if ([WDSystemUtils isEmptyOrNullString:_carNumberTextField.text]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入车牌号"];
//        return;
//    }
    
    if ([WDSystemUtils isEmptyOrNullString:_carPositionTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入车位号"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_telephoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (![StringUtil checkPhoneNumInput:_telephoneTextField.text]) {
         [SVProgressHUD showErrorWithStatus:@"手机号不合法，请重新输入"];
        return;
    }
    if ([WDSystemUtils isEmptyOrNullString:_verifyCodeTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_verifyCodeId]) {
        [SVProgressHUD showErrorWithStatus:@"不正确的验证码，请重新获取"];
        return;
    }
    
    if (!_isAgree) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意《蚂蚁洗车协议》"];
        return;
    }
  
    
    
    NSString *chePaiStr = [provinceStr.titleLabel.text stringByAppendingFormat:@"%@%@",_A_Z.titleLabel.text,_carNumberTextField.text];
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:chePaiStr forKey:@"ucarNumber"];
    [parameters setValue:_carColorLabel.text forKey:@"ucolor"];
    [parameters setValue:_userInfo.province forKey:@"province"];
    [parameters setValue:_userInfo.city forKey:@"city"];
    [parameters setValue:_userInfo.area forKey:@"area"];
    [parameters setValue:_userInfo.plot forKey:@"plot"];
    [parameters setValue:_carPositionTextField.text forKey:@"cwh"];
    [parameters setValue:_telephoneTextField.text forKey:@"uid"];//手机号
    [parameters setValue:_verifyCodeTextField.text forKey:@"yzm"];
    [parameters setValue:_verifyCodeId forKey:@"yzmid"];
    
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiUserRegister parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            return ;
        }
        else if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
            return ;
        }
        else if ([WDSystemUtils isEqualsInt:3 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [GlobalVar sharedSingleton].uid = [responseObject objectForKey:@"uid"];
            [GlobalVar sharedSingleton].isloginid = [responseObject objectForKey:@"isloginid"];
            [[NSUserDefaults standardUserDefaults] setValue:[GlobalVar sharedSingleton].uid forKey:MayiUidKey];
            [[NSUserDefaults standardUserDefaults] setValue:[GlobalVar sharedSingleton].isloginid forKey:MayiIsLoginId];

            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MayiUserIsSignIn];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            
            [self.navigationController pushViewController:viewController animated:YES];
            UINavigationController *nav = self.navigationController;
            [self removeFromParentViewController];
            UIViewController *viewController1 = [nav.viewControllers objectAtIndex:0];
            [viewController1 removeFromParentViewController];
            
            [self registerRemoteNotification];
//            [self initHomeScreen];
        }
        else if ([WDSystemUtils isEqualsInt:4 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"手机号已存在"];
            return ;
        }
        
    } failture:^(NSError *error) {
        [self.view makeToast:@"注册失败"];
    }];
}

-(void)initHomeScreen{
    //1.创建Window
    
    UIViewController *rootViewController1 = [StoryboadUtil getViewController:@"Main" : @"RootViewController1"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController1];
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:0/255.0f green:160/255.0f  blue:230/255.0f alpha:1.0f];
    //设置控制器为Window的根控制器
    //    self.view.window.rootViewController=nav;
    //a.初始化一个tabBar控制器
    //    UITabBarController *tb=[[UITabBarController alloc]init];
    //    [nav pushViewController:tb animated:YES];
    
    
    //    //        //    Root *tb=[[UITabBarController alloc]init];
    //    [nav pushViewController:rootViewController1 animated:YES];
    
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController1];
    [self presentViewController:nav animated:YES completion:nil];
    [self removeFromParentViewController];
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = nil;
    switch (indexPath.row) {
        case 0:
            reuseIdentifier = @"CarNumberCell";
            break;
        case 1:
            reuseIdentifier = @"CarColorCell";
            break;
        case 2:
            reuseIdentifier = @"LocationCell";
            break;
        case 3:
            reuseIdentifier = @"CarParkCell";
            break;
        case 4:
            reuseIdentifier = @"TelephoneCell";
            break;
        case 5:
            reuseIdentifier = @"ChechCodeCell";
            break;
        case 6:
            reuseIdentifier = @"AgreeCell";
            break;
        case 7:
            reuseIdentifier = @"CommitCell";
            break;
        case 8:
            reuseIdentifier = @"PromiseCell";
            break;
        default:
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell != nil) {
        UIView *view = [cell viewWithTag:1];
        view.layer.borderColor = GeneralLineCGColor;
        view.layer.borderWidth = 0.5;
    }
    cell.backgroundColor = GeneralBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (indexPath.row == 6) {
//        UITextView *textView = (UITextView *)[cell viewWithTag:3];
//        textView.layer.borderWidth = 0.5;
//        textView.layer.borderColor = GeneralLineCGColor;
//    }
    
    if (indexPath.row == 0) {
        _carNumberTextField = (UITextField *)[cell viewWithTag:2];
        
        provinceStr  = (UIButton*)[cell viewWithTag:3];
        _A_Z = (UIButton*)[cell viewWithTag:4];
        [provinceStr  addTarget:self action:@selector(provinceShortOnclick) forControlEvents:UIControlEventTouchUpInside];
        [_A_Z  addTarget:self action:@selector(AZChosseOnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row == 1) {
        _carColorLabel = (UILabel *)[cell viewWithTag:2];
//        if (![WDSystemUtils isEmptyOrNullString:_carColor]) {
//            _carColorLabel.text = _carColor;
//        }
    }
    
    if (indexPath.row == 2) {
        _addresssLabel = (UILabel *)[cell viewWithTag:2];
//        if (![WDSystemUtils isEmptyOrNullString:_address]) {
//            _addresssLabel.text = _address;
//        }
    }
    
    if (indexPath.row == 3) {
        _carPositionTextField = (UITextField *)[cell viewWithTag:2];
    }
    
    if (indexPath.row == 4) {
        _telephoneTextField = (UITextField *)[cell viewWithTag:2];
        _codeButton = (UIButton *)[cell viewWithTag:3];
        [_codeButton setTitle:_codeButtonTitle forState:UIControlStateNormal];
    }
    
    if (indexPath.row == 5) {
        _verifyCodeTextField = (UITextField *)[cell viewWithTag:2];
    }
    
    if (indexPath.row == 6) {
        _agreeCheckImageView = (UIImageView *)[cell viewWithTag:2];
        if (_isAgree) {
            _agreeCheckImageView.image = [UIImage imageNamed:@"img_checked"];
        }
        else {
            _agreeCheckImageView.image = [UIImage imageNamed:@"img_unchecked"];
        }
        
        _agreeLabel = (NIAttributedLabel *)[cell viewWithTag:3];
        
        NSRange range = [@"我已阅读并接受《蚂蚁洗车协议》" rangeOfString:@"《蚂蚁洗车协议》"];
        _agreeLabel.text = @"我已阅读并接受《蚂蚁洗车协议》";
        _agreeLabel.linkColor = RGBCOLOR(0x28, 0x8c, 0xcf);
        [_agreeLabel addLink:[NSURL URLWithString:@"http://o2o.ahxiaodian.com/myxc/agreement.html"] range:range];
        _agreeLabel.dataDetectorTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        _agreeLabel.autoDetectLinks = YES;
        _agreeLabel.deferLinkDetection = YES;
        _agreeLabel.delegate = self;
    }
    
    if (indexPath.row == 8) {
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        label.textColor = RGBCOLOR(254, 170, 110);
        label.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

#pragma mark - NIAttributedLabelDelegate
- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    NSString *url = result.URL.absoluteString;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webController = [storyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webController setTitle:@"注册协议" andUrl:url];
    [self.navigationController pushViewController:webController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)codeButtonClicked:(id)sender {
     [self dismissKeyBoard];
    UITextField *textFiled  = nil;
    __block int getCodeStatus = -1;
    _timeInterval = 60;
    
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if ([@"TelephoneCell" isEqualToString:[cell reuseIdentifier]]) {
             textFiled = (UITextField *)[cell viewWithTag:2];
        }
    }
    
    if (textFiled == nil) {
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:textFiled.text]) {
        [self.view makeToast:@"手机号不能为空"];
        return;
    }
    if (![StringUtil checkPhoneNumInput:textFiled.text]) {
        [self.view makeToast:@"手机号不合法，请重新输入"];
        return;
    }
    
    _telephoneNumber = textFiled.text;
    NSDictionary *dic1 = @{@"mobile":textFiled.text};
    [[MayiHttpRequestManager sharedInstance] POST:MayiSendMsg parameters:dic1 showLoadingView:self.view success:^(id responseObject) {
        
        
        if ([@"success" isEqualToString:[responseObject objectForKey:@"res"]]) {
            _verifyCodeId = [responseObject objectForKey:@"yzmid"];
            getCodeStatus = 1;
            [self.view makeToast:@"短信发送成功，请注意查收！"];
            [self startTime];
        }
        else {
            getCodeStatus = 0;
        }
        
    } failture:^(NSError *error) {
        getCodeStatus = 0;
    }];
    
//    while (getCodeStatus == -1)  {
////        sleep(1);
////        DLog(@"getCodeStatus wait");
////        [[NSRunLoop currentRunLoop] runMode:@"getCodeStatus" beforeDate:[NSDate distantFuture]];
//        
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
    
//    if (getCodeStatus == 1) {
////        [_codeButton setEnabled:NO];
//        while ( _timeInterval > 0) {
//            [self timeDesend];
//            sleep(1);
//        }
////        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
////        [_codeButton setEnabled:YES];
//        
//        _codeButtonTitle = @"获取验证码";
//        [_codeButton setEnabled:YES];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

-(void)startTime{
    __block int timeout=60 - 1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _codeButton.userInteractionEnabled = YES;
                [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_codeButton setTitle:[NSString stringWithFormat:@"%@秒后重新获取",strTime] forState:UIControlStateNormal];
                _codeButton.userInteractionEnabled = NO;
                [_codeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

-(void)timeDesend
{
    DLog(@"_timeInterval:%@",[NSString stringWithFormat:@"%i秒",_timeInterval]);
    
    _codeButtonTitle = [NSString stringWithFormat:@"%i秒",_timeInterval--];
    
//    [_codeButton setTitle:[NSString stringWithFormat:@"%i秒",_timeInterval--] forState:UIControlStateNormal];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
   
}


-(void)sendColorValue:(NSInteger)value{
    [_carColorLabel setText:[ColorChoosePop colorNameByValue:value]];
    _userInfo.color = _carColorLabel.text;
}
-(void)showLocationChoose{
    LocationChoosePop *view = [LocationChoosePop defaultPopupView];
    view.parentVC = self;
    view.mydelegate = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
-(void)showDetailChoose:(int)channel{
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = channel;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}
-(void)ok{
    LocationInfo *info =[LocationInfo getInstance];
    NSString *locationName;
    if ([info.area_name_province isEqualToString: info.area_name_city]) {
        locationName = [info.area_name_province stringByAppendingFormat:@"%@%@" , info.area_name_area,info.area_name_smallArea ];
    }else{
        locationName = [info.area_name_province stringByAppendingFormat:@"%@%@%@",info.area_name_city,info.area_name_area,info.area_name_smallArea ];
        
    }
    _addresssLabel.text = locationName;
    _userInfo.province =info.area_id_province;
    _userInfo.city = info.area_id_city;
    _userInfo.area = info.area_id_area;
    _userInfo.plot = info.area_id_smallArea;
    
}
- (IBAction)locationChoose:(id)sender {
     [self dismissKeyBoard];
        [[LocationInfo getInstance] clear];
        LocationChoosePop *view = [LocationChoosePop defaultPopupView];
        view.parentVC = self;
        view.mydelegate = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            
        }];
}

- (IBAction)colorChoose:(id)sender {
     [self dismissKeyBoard];
    ColorChoosePop *view = [ColorChoosePop defaultPopupView];
    view.parentVC = self;
    view.delegate = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        
    }];
}

- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

@end
