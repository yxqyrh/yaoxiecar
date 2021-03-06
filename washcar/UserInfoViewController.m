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
#import "SmallArea.h"

@interface UserInfoViewController (){
    
    NSString *carnumber ;
    NSString *_address;
    NSString *color;
    NSString *cwh;
    float money;
   
    NSString *province ;
    NSString *area;
    NSString *city;
    NSString *plot;
    NSString *szdqstr;
    NSString *plotmc;//小区名称
    
    //自动定位的地址信息
    NSString *location_province ;
    NSString *location_area;
    NSString *location_city;
    NSString *location_plot;
    NSString *location_plotmc;//小区名称
    
    
    long time;
    
    long uid;
    
    NSString *uname;
    NSString *upicture;
    
    ChePaiPickView *chePaiPickView;
    NSDictionary *dic;
    NSDictionary *dz;
    
    //当本页是编辑页的时候，初次点击地址使用车辆之前的地址信息；
    bool isFirstEnterLocation;
}

@property   (nonatomic)NSString *area_id_province;
@property    (nonatomic)NSString *area_id_city;
@property    (nonatomic)NSString *area_id_area;
@property    (nonatomic) NSString *area_id_smallArea;

@property    (nonatomic) NSString *area_name_province;
@property    (nonatomic) NSString *area_name_city;
@property    (nonatomic) NSString *area_name_area;
@property    (nonatomic) NSString *area_name_smallArea;

@property (nonatomic)NSArray *provinceList;
@property (nonatomic)NSArray *cityList;
@property (nonatomic)NSArray *areaList;
@property (nonatomic)NSArray *plotList;
@property (nonatomic)NSDictionary *dz;

@property (nonatomic)NSDictionary *location_dz;

@property (assign)bool isEdit;

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
        _isEdit = true;
        [self loadData];
    }else{
        _isEdit = false;
        [_actionBtn setTitle:@"确认添加" forState:UIControlStateNormal];
//        [WDLocationHelper getInstance].delegate = self;
//        [[WDLocationHelper getInstance] startUpdate];
        
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            if (error)
            {
                DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                //                if (error.code == AMapLocatingErrorLocateFailed)
                //                {
                //                    return;
                //                }
            }
            
            DLog(@"location:%@", location);
            
            [self registerShow:location.coordinate.longitude andLatitude:location.coordinate.latitude];
            
            if (regeocode)
            {
                DLog(@"reGeocode:%@", regeocode);
            }
        }];
    }

    _CarNum.delegate = self;
    

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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _CarNum.text = [_CarNum.text uppercaseString];
}

#pragma mark - WDLocationHelperDelegate

- (void)didGetLocation:(CLLocationCoordinate2D)coordinate
{
    [self registerShow:coordinate.longitude andLatitude:coordinate.latitude];
    [[WDLocationHelper getInstance] stopUpdate];
}

- (void)didGetLocationFail
{
    DLog(@"failed");
    [[WDLocationHelper getInstance] stopUpdate];
}

-(void)registerShow:(double)longitude andLatitude:(double)latitude
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithDouble:latitude] forKey:@"Longitude"];
    [parameters setObject:[NSNumber numberWithDouble:longitude] forKey:@"Latitude"];
    //    [parameters setObject:[NSNumber numberWithDouble:117.27] forKey:@"Longitude"];
    //    [parameters setObject:[NSNumber numberWithDouble:31.85] forKey:@"Latitude"];
    [[MayiHttpRequestManager sharedInstance] POST:MayiRegShow parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
//            self.provinceList = [responseObject objectForKey:@"shenglist"];
//            self.cityList = [responseObject objectForKey:@"citylist"];
//            self.areaList = [LocationInfo getInstance].areaList = [responseObject objectForKey:@"qulist"];
//            self.plotList = [SmallArea objectArrayWithKeyValuesArray:[responseObject objectForKey:@"xq"]];
//            self.dz = [responseObject objectForKey:@"dz"];
//            
//            
//            _address = [NSString stringWithFormat:@"%@%@%@%@", [self.dz objectForKey:@"provincemc"],[self.dz objectForKey:@"citymc"],[self.dz objectForKey:@"areamc"],[self.dz objectForKey:@"plotmc"]];
            
            if (_isEdit) {
                self.provinceList = [responseObject objectForKey:@"shenglist"];
                self.cityList = [responseObject objectForKey:@"citylist"];
                self.areaList = [LocationInfo getInstance].areaList = [responseObject objectForKey:@"qulist"];
                self.plotList = [SmallArea objectArrayWithKeyValuesArray:[responseObject objectForKey:@"xq"]];
                self.location_dz = [responseObject objectForKey:@"dz"];
                
                
                _address = [NSString stringWithFormat:@"%@%@%@%@", [self.location_dz objectForKey:@"provincemc"],[self.location_dz objectForKey:@"citymc"],[self.location_dz objectForKey:@"areamc"],[self.location_dz objectForKey:@"plotmc"]];
                

            }
            else {
                self.provinceList = [responseObject objectForKey:@"shenglist"];
                self.cityList = [responseObject objectForKey:@"citylist"];
                self.areaList = [LocationInfo getInstance].areaList = [responseObject objectForKey:@"qulist"];
                self.plotList = [SmallArea objectArrayWithKeyValuesArray:[responseObject objectForKey:@"xq"]];
                self.dz = [responseObject objectForKey:@"dz"];
                
//                _address = [NSString stringWithFormat:@"%@%@%@%@", [self.dz objectForKey:@"provincemc"],[self.dz objectForKey:@"citymc"],[self.dz objectForKey:@"areamc"],[self.dz objectForKey:@"plotmc"]];
//                
//                [self chooseLocation:_address
//                      provinceId: [self.dz objectForKey:@"province"] cityId:[self.dz objectForKey:@"city"] areaId:[self.dz objectForKey:@"area"] plotId:[self.dz objectForKey:@"plot"] plotName:[self.dz objectForKey:@"plotmc"]];
            }
            
            
        }
        
    } failture:^(NSError *error) {
        
    }];
}


- (IBAction)showLocation:(id)sender {
//    [[LocationInfo getInstance] clear];
//    LocationChoosePop *view = [LocationChoosePop defaultPopupView];
//        view.parentVC = self;
//    view.mydelegate = self;
//        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
//            NSLog(@"动画结束");
//        }];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LocationChoose1" bundle:nil];
    LocationChooseViewController1 *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"LocationChooseViewController1"];
    viewController.delegate = self;
    viewController.provinceList = self.provinceList;
    if (_isEdit) {
//        [viewController initDataDZ:self.location_dz nearPlots:self.plotList];
        [viewController initDataDZ:self.location_dz nearPlots:nil ssxPlots:nil andLocationPlot:nil];
    }
    else {
//        [viewController initDataDZ:self.dz nearPlots:self.plotList];
        [viewController initDataDZ:self.dz nearPlots:nil ssxPlots:nil andLocationPlot:nil];
    }

    [self.navigationController pushViewController:viewController animated:YES];
    return;
    
}

- (IBAction)chooseColor:(id)sender {
        ColorChoosePop *view = [ColorChoosePop defaultPopupView];
        view.parentVC = self;
        view.delegate = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            NSLog(@"动画结束");
        }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置颜色
-(void)sendColorValue:(NSInteger)value{
    NSLog(@"dsdsd");
    _CarColor.text = [ColorChoosePop colorNameByValue:value];
    color = _CarColor.text;
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

    province =info.area_id_province;
    city = info.area_id_city;
    area = info.area_id_area;
    plot = info.area_id_smallArea;


   
}

#pragma mark - LocationChooseDelegate

-(void)chooseLocation:(NSString *)address
           provinceId:(NSString *)provinceId
               cityId:(NSString *)cityId
               areaId:(NSString *)areaId
               plotId:(NSString *)plotId
             plotName:(NSString *)plotName
{
    
    _Loaction.text = address;
    province =provinceId;
    city = cityId;
    area = areaId;
    plot = plotId;
    plotmc = plotName;
}

//-(void)chooseLocation:(NSString *)address
//{
//    LocationInfo *info = [LocationInfo getInstance];
//    _Loaction.text = address;
//    province =info.area_id_province;
//    city = info.area_id_city;
//    area = info.area_id_area;
//    plot = info.area_id_smallArea;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)commitInfo:(id)sender {
    [_CarNum resignFirstResponder];
    [_cheweihao resignFirstResponder];
    [self textFieldDidEndEditing:_CarNum];
    if ([@"确认添加" isEqualToString :_actionBtn.titleLabel.text]) {
        
        [self addCarNum];
    }else{
        [self commitEditCarInfo];
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

            dic =[responseObject objectForKey:@"res_cl"];
            dz  = [responseObject objectForKey:@"dz"];
             [self refresh];
            
            [WDLocationHelper getInstance].delegate = self;
            [[WDLocationHelper getInstance] startUpdate];
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
    color = [dic objectForKey:@"color"];
    _CarColor.text = color;
    cwh = [dic objectForKey:@"cwh"];
    _cheweihao.text = cwh;
    NSString *cp1 =[dic objectForKey:@"cp1"];
    NSString *cp2 =[dic objectForKey:@"cp2"];
    NSString *cp3 =[dic objectForKey:@"cp3"];
    province =[dic objectForKey:@"province"];
    city = [dic objectForKey:@"city"];
    area = [dic objectForKey:@"area"];
    plot = [dic objectForKey:@"plot"];
   
    NSLog(@"plot=%@",plot);
    
    [_provinceShort setTitle:cp1 forState:UIControlStateNormal];
    [_A_Z setTitle:cp2 forState:UIControlStateNormal];
    _CarNum.text = cp3;
    
    
    NSString *provincemc =[dz objectForKey:@"provincemc"];
     NSString *citymc =[dz objectForKey:@"citymc"];
     NSString *areamc =[dz objectForKey:@"areamc"];
     plotmc =[dz objectForKey:@"plotmc"];
  
   _Loaction.text = [provincemc stringByAppendingFormat:@"%@%@%@",citymc,areamc,plotmc];

}

//提交信息编辑
-(void)commitEditCarInfo{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
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
    
    if ([WDSystemUtils isEmptyOrNullString:_CarColor.text]||[@"请选择车辆颜色" isEqualToString :_CarColor.text]) {
        [self.view makeToast:@"汽车颜色不能为空"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_Loaction.text]) {
        [self.view makeToast:@"地址不能为空"];
        return;
    }
 
    if ([StringUtil isEmty:plot]) {
        [SVProgressHUD showErrorWithStatus:@"请选择车辆地址"];
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
//    NSString *chePaiStr = [_provinceShort.titleLabel.text stringByAppendingFormat:@"%@%@",_A_Z.titleLabel.text,_CarNum.text];
    [parameters setValue:_provinceShort.titleLabel.text forKey:@"prov"];
    [parameters setValue:_A_Z.titleLabel.text forKey:@"nevel"];
    [parameters setValue:_CarNum.text forKey:@"LPN"];
    [parameters setValue:color forKey:@"color"];
    [parameters setValue:province forKey:@"province"];
    [parameters setValue:city forKey:@"city"];
    [parameters setValue:area forKey:@"qu"];
    [parameters setValue:plotmc forKey:@"address"];
    [parameters setValue:_clid forKey:@"bj"];
    [parameters setValue:_cheweihao.text forKey:@"parkNum"];
    [[MayiHttpRequestManager sharedInstance] POST:CarEditAction parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            [SVProgressHUD showSuccessWithStatus:@"车牌编辑成功！"];
                       cwh =_cheweihao.text;
            [self.navigationController popViewControllerAnimated:YES];
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
    
    if ([WDSystemUtils isEmptyOrNullString:_CarColor.text]||[@"请选择车辆颜色" isEqualToString :_CarColor.text]) {
        [self.view makeToast:@"汽车颜色不能为空"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_Loaction.text]) {
        [self.view makeToast:@"地址不能为空"];
        return;
    }
    if ([StringUtil isEmty:plot]) {
        [SVProgressHUD showErrorWithStatus:@"没有小区信息，无法添加车牌"];
        return;
    }
    NSString *chePaiStr = [_provinceShort.titleLabel.text stringByAppendingFormat:@"%@%@",_A_Z.titleLabel.text,_CarNum.text];
    
    [parameters setValue:_provinceShort.titleLabel.text forKey:@"prov"];
    [parameters setValue:_A_Z.titleLabel.text forKey:@"nevel"];
    [parameters setValue:_CarNum.text forKey:@"LPN"];
    [parameters setValue:color forKey:@"color"];
    [parameters setValue:province forKey:@"province"];
    [parameters setValue:city forKey:@"city"];
    [parameters setValue:area forKey:@"qu"];
    [parameters setValue:plotmc forKey:@"address"];
    [parameters setValue:_cheweihao.text forKey:@"parkNum"];
    [[MayiHttpRequestManager sharedInstance] POST:AddCarNum parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            [SVProgressHUD showSuccessWithStatus:@"添加车牌成功！"];
            cwh =_cheweihao.text;
            [self.navigationController popViewControllerAnimated:YES];
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
