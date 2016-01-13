//
//  UserInfoViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MayiHttpRequestManager.h"
#import "GlobalVar.h"
#import "Constant.h"
#import "UserInfo.h"
#import "LocationInfo.h"
#import "CancelChoosePop.h"
#import "AppDelegate.h"
#import "StringUtil.h"
@interface UserInfoViewController (){
    int area;
    NSString *carnumber ;
    int city;
    NSString *color;
    NSString *cwh;
    int id;
    float money;
    int  plot;
    int province ;
    NSString *szdqstr;
    
    long time;
    
    long uid;
    
    NSString *uname;
    NSString *upicture;
    UserInfo *_userInfo;
    
    ChePaiPickView *chePaiPickView;
    NSDictionary *dic;
    NSDictionary *dz;
    
    
}


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    chePaiPickView = [ChePaiPickView defaultView];
    chePaiPickView.delegate =self;
    [self.view addSubview:chePaiPickView];
    self.navigationItem.title = self.title;
    if ([self.title isEqualToString:@"车辆信息编辑"]) {
     [self loadData];
    }else{
        [_actionBtn setTitle:@"确认添加" forState:UIControlStateNormal];
//        _actionBtn.titleLabel.text = @"确认添加";
    }
}
// 点击编辑框外面时，隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_CarNum resignFirstResponder];
    [_cheweihao resignFirstResponder];
    
}
- (IBAction)provinceShort:(id)sender {
    [chePaiPickView showView];
}
- (IBAction)AZChosse:(id)sender {
     [chePaiPickView showView];
}

-(void)valueChange:(NSString *)provinceShort A_Z:(NSString *)A_Z{
    
    
    if(provinceShort!=nil&&provinceShort.length>0){
        
    
        [_provinceShort setTitle:provinceShort forState:UIControlStateNormal];
    }
    if(A_Z!=nil&&A_Z.length>0){
          [_A_Z setTitle:A_Z forState:UIControlStateNormal];
    }
   
    
}
- (IBAction)chooseLocation:(id)sender {
    [[LocationInfo getInstance] clear];
    LocationChoosePop *view = [LocationChoosePop defaultPopupView];
        view.parentVC = self;
    view.mydelegate = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            NSLog(@"动画结束");
        }];
    
}

- (IBAction)chooseColor:(id)sender {
        ColorChoosePop *view = [ColorChoosePop defaultPopupView];
        view.parentVC = self;
    view.delegate = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            NSLog(@"动画结束");
        }];
    
//    CancelChoosePop *view = [CancelChoosePop defaultPopupView];
//    view.parentVC = self;
////    view.delegate = self;
//    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
//        NSLog(@"动画结束");
//    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置颜色
-(void)sendColorValue:(NSInteger)value{
    NSLog(@"dsdsd");
    [self.CarColor setText:[ColorChoosePop colorNameByValue:value]];
    _userInfo.color = _CarColor.text;
}

//设置地址

-(void) showLocationChoose{
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
    
    [self.Loaction setText:locationName];

    _userInfo.province =info.area_id_province;
    _userInfo.city = info.area_id_city;
    _userInfo.area = info.area_id_area;
    _userInfo.plot = info.area_id_smallArea;
    
    NSLog(@"_userInfo.plot=%@",_userInfo.plot);

   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)commitInfo:(id)sender {
    if ([@"确认添加" isEqualToString :_actionBtn.titleLabel.text]) {
        [self addCarNum];
    }else{
        [self commitInfo];
    }
    
    
}
- (IBAction)exit:(id)sender {
    [self exitMayi];
}
//从网上加载数据
-(void)loadData{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    if (_clid!=nil) {
       [parameters setValue:_clid forKey:@"id"];
    }
    
    [[MayiHttpRequestManager sharedInstance] POST:CarEdit parameters:parameters showLoadingView:self.view success:^(id responseObject) {
         NSLog(@"responseObject=%@",responseObject);
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
//             _userInfo = [UserInfo objectWithKeyValues:[responseObject objectForKey:@"0"]];
            
//
            dic =[responseObject objectForKey:@"res_cl"];
            dz  = [responseObject objectForKey:@"dz"];
             [self refresh];
                   }
    } failture:^(NSError *error) {
        
    }];
}
//"dz": {
//    "provincemc": "上海",
//    "citymc": "上海",
//    "areamc": "徐汇区",
//    "plotmc": "上海小区",
//    "province": "25",
//    "city": "321",
//    "area": "2706",
//    "plot": "37"
//},
-(void)refresh{
    
    _CarColor.text = [dic objectForKey:@"color"];
    _cheweihao.text = [dic objectForKey:@"cwh"];
    NSString *cp1 =[dic objectForKey:@"cp1"];
    NSString *cp2 =[dic objectForKey:@"cp2"];
    NSString *cp3 =[dic objectForKey:@"cp3"];
 
    
    [_provinceShort setTitle:cp1 forState:UIControlStateNormal];
    [_A_Z setTitle:cp2 forState:UIControlStateNormal];
    _CarNum.text = cp3;
    
    
    NSString *provincemc =[dz objectForKey:@"provincemc"];
     NSString *citymc =[dz objectForKey:@"citymc"];
     NSString *areamc =[dz objectForKey:@"areamc"];
     NSString *plotmc =[dz objectForKey:@"plotmc"];
   _Loaction.text = [provincemc stringByAppendingFormat:@"%@%@%@",citymc,areamc,plotmc];
 
}

//提交信息编辑
-(void)commitInfo{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    // uid=18550031362  Isloginid=14435112502766
    //    [parameters setValue:[GlobalVar sharedSingleton].uid forKey:@"uid"];
    //    [parameters setValue:[GlobalVar sharedSingleton].isloginid forKey:@"isloginid"];
    if ([WDSystemUtils isEmptyOrNullString:_provinceShort.titleLabel.text]||[@"省简称" isEqualToString:_provinceShort.titleLabel.text]) {
        [self.view makeToast:@"车牌号的省份简称不能为空"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_A_Z.titleLabel.text]||[@"级别" isEqualToString:_A_Z.titleLabel.text]) {
        [self.view makeToast:@"车牌号的省份字母级别不能为空"];
        return;
    }
    if ([WDSystemUtils isEmptyOrNullString:_CarNum.text]||_CarNum.text.length!=5) {
        [self.view makeToast:@"车牌后5位数不合法"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_CarColor.text]) {
        [self.view makeToast:@"汽车颜色不能为空"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_Loaction.text]) {
        [self.view makeToast:@"地址不能为空"];
        return;
    }
    if ([StringUtil isEmty:_userInfo.plot]) {
        [SVProgressHUD showErrorWithStatus:@"没有小区信息，无法修改个人信息"];
        return;
    }
    
//    if ([WDSystemUtils isEmptyOrNullString:_cheweihao.text]) {
//        [self.view makeToast:@"车位号不能为空"];
//        return;
//    }
    
//    uid  注册或者登陆的标识  carnumber 车牌号 color颜色 province省  city市 area 县  plot小区 cwh车位号
//    uid  是否登录的标识，所有必须登录才能使用的功能必须post过来这个参数
//    Isloginid 是否登录的标识，所有必须登录才能使用的功能必须post过来这个参数
//    返回值
//    Data res 1 编辑资料成功  2编辑资料失败
    NSString *chePaiStr = [_provinceShort.titleLabel.text stringByAppendingFormat:@"%@%@",_A_Z.titleLabel.text,_CarNum.text];
    [parameters setValue:_provinceShort.titleLabel.text forKey:@"prov"];
    [parameters setValue:_A_Z.titleLabel.text forKey:@"nevel"];
    [parameters setValue:_CarNum.text forKey:@"LPN"];
    [parameters setValue:_userInfo.color forKey:@"color"];
    [parameters setValue:_userInfo.province forKey:@"province"];
    [parameters setValue:_userInfo.city forKey:@"city"];
    [parameters setValue:_userInfo.area forKey:@"qu"];
    [parameters setValue:_userInfo.plot forKey:@"address"];
    [parameters setValue:_cheweihao.text forKey:@"parkNum"];
    [[MayiHttpRequestManager sharedInstance] POST:UserInfoEdit parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
     
            [SVProgressHUD showSuccessWithStatus:@"车牌编辑成功！"];
                       _userInfo.cwh =_cheweihao.text;
        }else if([@"2" isEqualToString:res]){
            [SVProgressHUD showErrorWithStatus:@"车牌编辑失败！"];
        }else if([@"5" isEqualToString:res]){
            [SVProgressHUD showErrorWithStatus:@"该网点尚未开通，敬请期待"];
        }
       
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"车牌编辑失败！"];
    }];
}


//功能名称
//用户退出
//接口方法名
//quitlogin
//参数描述
//uid  注册或者登陆的标识 isloginid 登录标识
//uid  是否登录的标识，所有必须登录才能使用的功能必须post过来这个参数
//Isloginid 是否登录的标识，所有必须登录才能使用的功能必须post过来这个参数
//返回值
//Res   1 退出成功  2退出失败
-(void) exitMayi{
     NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:Quitlogin parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功！"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MayiUserIsSignIn];
          
                [GlobalVar sharedSingleton].uid = nil;
                
                [GlobalVar sharedSingleton].isloginid = nil;
            [GlobalVar sharedSingleton].signState = MayiSignStateUnSigned;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiIndexPageNotifiction object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
//            UIViewController *loginViewController = [storyboard instantiateInitialViewController];
//            loginViewController.modalTransitionStyle = UIModalPresentationFormSheet;//跳转效果
//            [self presentModalViewController:loginViewController animated:YES];//在这里一跳就行了。
//            
//            //[self dismissModalViewControllerAnimated:YES];
//            [self removeFromParentViewController];
        }else{
            [SVProgressHUD showErrorWithStatus:@"退出失败！"];
        }
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败！"];
    }];

}


//提交信息编辑
-(void)addCarNum{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    // uid=18550031362  Isloginid=14435112502766
    //    [parameters setValue:[GlobalVar sharedSingleton].uid forKey:@"uid"];
    //    [parameters setValue:[GlobalVar sharedSingleton].isloginid forKey:@"isloginid"];
//    if ([WDSystemUtils isEmptyOrNullString:_provinceShort.titleLabel.text]||[@"省简称" isEqualToString:_provinceShort.titleLabel.text]) {
//        [self.view makeToast:@"车牌号的省份简称不能为空"];
//        return;
//    }
//    
//    if ([WDSystemUtils isEmptyOrNullString:_A_Z.titleLabel.text]||[@"级别" isEqualToString:_A_Z.titleLabel.text]) {
//        [self.view makeToast:@"车牌号的省份字母级别不能为空"];
//        return;
//    }
//    if ([WDSystemUtils isEmptyOrNullString:_CarNum.text]||_CarNum.text.length!=5) {
//        [self.view makeToast:@"车牌后5位数不合法"];
//        return;
//    }
//    
//    if ([WDSystemUtils isEmptyOrNullString:_CarColor.text]) {
//        [self.view makeToast:@"汽车颜色不能为空"];
//        return;
//    }
//    
//    if ([WDSystemUtils isEmptyOrNullString:_Loaction.text]) {
//        [self.view makeToast:@"地址不能为空"];
//        return;
//    }
//    if ([StringUtil isEmty:_userInfo.plot]) {
//        [SVProgressHUD showErrorWithStatus:@"没有小区信息，无法添加车牌"];
//        return;
//    }
//    
//        if ([WDSystemUtils isEmptyOrNullString:_cheweihao.text]) {
//            [self.view makeToast:@"车位号不能为空"];
//            return;
//        }
    
    //    uid  注册或者登陆的标识  carnumber 车牌号 color颜色 province省  city市 area 县  plot小区 cwh车位号
    //    uid  是否登录的标识，所有必须登录才能使用的功能必须post过来这个参数
    //    Isloginid 是否登录的标识，所有必须登录才能使用的功能必须post过来这个参数
    //    返回值
    //    Data res 1 编辑资料成功  2编辑资料失败
    NSString *chePaiStr = [_provinceShort.titleLabel.text stringByAppendingFormat:@"%@%@",_A_Z.titleLabel.text,_CarNum.text];
    
    [parameters setValue:_provinceShort.titleLabel.text forKey:@"prov"];
    [parameters setValue:_A_Z.titleLabel.text forKey:@"nevel"];
    [parameters setValue:_CarNum.text forKey:@"LPN"];
    [parameters setValue:_userInfo.color forKey:@"color"];
    [parameters setValue:_userInfo.province forKey:@"province"];
    [parameters setValue:_userInfo.city forKey:@"city"];
    [parameters setValue:_userInfo.area forKey:@"qu"];
    [parameters setValue:_userInfo.plot forKey:@"address"];
    [parameters setValue:_cheweihao.text forKey:@"parkNum"];
    
    
//    [parameters setValue:@"沪" forKey:@"prov"];
//    [parameters setValue:@"A" forKey:@"nevel"];
//    [parameters setValue:@"12345" forKey:@"LPN"];
//    [parameters setValue:@"黑色" forKey:@"color"];
//    [parameters setValue:@"上海" forKey:@"province"];
//    [parameters setValue:@"上海" forKey:@"city"];
//    [parameters setValue:@"徐汇区" forKey:@"qu"];
//    [parameters setValue:@"上海小区" forKey:@"address"];
//    [parameters setValue:@"123" forKey:@"parkNum"];
//    
    
    [[MayiHttpRequestManager sharedInstance] POST:AddCarNum parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            [SVProgressHUD showSuccessWithStatus:@"添加车牌成功！"];
            _userInfo.cwh =_cheweihao.text;
        }else if([@"2" isEqualToString:res]){
            [SVProgressHUD showErrorWithStatus:@"添加车牌失败！"];
        }else if([@"5" isEqualToString:res]){
            [SVProgressHUD showErrorWithStatus:@"该网点尚未开通，敬请期待"];
        }
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"添加车牌失败！"];
    }];
}
@end
