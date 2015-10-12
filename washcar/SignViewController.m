//
//  SignViewController.m
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "SignViewController.h"
#import "WDHttpRequestManager.h"
#import "MayiHttpRequestManager.h"
#import "StoryboadUtil.h"

@interface SignViewController () {
    long _verifyCodeId;
    
}
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UIView *codeView;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"登陆";
    // Do any additional setup after loading the view.
    _verifyCodeId = 0;
    _phoneView.layer.borderWidth = 0.5;
    _phoneView.layer.borderColor = GeneralLineCGColor;
    
    _codeView.layer.borderWidth = 0.5;
    _codeView.layer.borderColor = GeneralLineCGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 点击编辑框外面时，隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signButtonClick:(id)sender {
    if ([WDSystemUtils isEmptyOrNullString:_phoneTextField.text]) {
        [self.view makeToast:@"手机号不能为空"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_codeTextField.text]) {
        [self.view makeToast:@"验证码不能为空"];
        return;
    }
    
//    if (_verifyCodeId == 0) {
//        [self.view makeToast:@"请重新获取验证码"];
//        return;
//    }

    NSDictionary *dic1 = @{@"uid":_phoneTextField.text,@"yzmid":@(_verifyCodeId),@"yzm":_codeTextField.text};
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiUserLogin parameters:dic1 showLoadingView:self.view success:^(id responseObject) {
        DLog(@"responseObject=%@",responseObject)
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        
        if ([@"1" isEqualToString:res]) {
            [self.view makeToast:@"账号不存在"];
            [SVProgressHUD showErrorWithStatus:@"账号不存在"];
            return ;
        }
        else if ([@"2" isEqualToString:res]) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            return ;
        }
        else if ([@"3" isEqualToString:res]) {
            [GlobalVar sharedSingleton].uid = [responseObject objectForKey:@"uid"];

            [GlobalVar sharedSingleton].isloginid = [responseObject objectForKey:@"isloginid"];
            [[NSUserDefaults standardUserDefaults] setValue:[GlobalVar sharedSingleton].isloginid forKey:MayiIsLoginId];
            [[NSUserDefaults standardUserDefaults] setValue:[GlobalVar sharedSingleton].uid forKey:MayiUidKey];

            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MayiUserIsSignIn];

            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
//            [self initHomeScreen];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
            [self removeFromParentViewController];
        }
        
    } failture:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
    
    
    return ;
    
    
}

-(void)startTime{
    __block int timeout=59; //倒计时时间
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


- (IBAction)codeButtonClicked:(id)sender {
    
    if ([WDSystemUtils isEmptyOrNullString:_phoneTextField.text]) {
        [self.view makeToast:@"手机号不能为空"];
        return;
    }
    
    NSDictionary *dic1 = @{@"mobile":_phoneTextField.text};
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiSendMsg parameters:dic1 showLoadingView:self.view success:^(id responseObject) {
        if ([@"success" isEqualToString:[responseObject objectForKey:@"res"]]) {
            _verifyCodeId = [[responseObject objectForKey:@"yzmid"] longValue];
            [self.view makeToast:@"短信发送成功，请注意查收！"];
            [self startTime];
        }
        
    } failture:^(NSError *error) {
        
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
@end
