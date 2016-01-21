//
//  WashEditViewController.m
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "WashEditViewController.h"
#import "MayiHttpRequestManager.h"
#import "LocationInfo.h"
#import "VoucherInfo.h"
#import "StringUtil.h"
#import "NIAttributedLabel.h"
#import "Masonry.h"
#import "SmallArea.h"
#import "CarInfo.h"
#import "UserInfoViewController.h"
#import "StoryboadUtil.h"

@interface WashEditViewController () {
    UILabel *_carNumberLabel;
    UILabel *_carColorLabel;
    UILabel *_addressLabel;
    UITextField *_cheWeiNumTextField;
    UILabel *_washTypeLabel;
    UILabel *_voucherLabel;
    NIAttributedLabel *_priceLabel;
    UITextView *_descTextView;
    
    UserInfo *_userInfo;
    
    CGFloat _price;
    
    bool _isFirstEdit;
    
    WashType *_selectWashType;//洗车方式实体类
    VoucherInfo *_voucherInfo;//代金券实体类
    NSArray *washTypeArray;//洗车方式列表
    NSArray *voucherInfoArray;//代金券列表
    
    bool _isFirstEnter;
    
    NSString *_address;
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

@end

@implementation WashEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFirstEdit = YES;
    _isFirstEnter = YES;
    
   
}


-(void)viewDidAppear:(BOOL)animated
{
    if (_isFirstEnter) {
        [WDLocationHelper getInstance].delegate = self;
        [[WDLocationHelper getInstance] startUpdate];
        
        
        _isFirstEnter = NO;
    }
}

// 点击编辑框外面时，隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [_descTextView resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WDLocationHelperDelegate

- (void)didGetLocation:(CLLocationCoordinate2D)coordinate
{
    [self loadMyInfoWithLocation:coordinate.longitude andLatitude:coordinate.latitude];
    [[WDLocationHelper getInstance] stopUpdate];
}

- (void)didGetLocationFail
{
    DLog(@"failed");
    [[WDLocationHelper getInstance] stopUpdate];
}


-(void)loadAddress:(id)responseObject
{
    SmallArea *plot0 = [SmallArea objectWithKeyValues:[responseObject objectForKey:@"plot_user"]];
    SmallArea *plot1 = [SmallArea objectWithKeyValues:[responseObject objectForKey:@"plot_user1"]];
    SmallArea *plot2 = [SmallArea objectWithKeyValues:[responseObject objectForKey:@"plot_user2"]];
    SmallArea *plot3 = [SmallArea objectWithKeyValues:[responseObject objectForKey:@"plot_user3"]];
    SmallArea *plot4 = [SmallArea objectWithKeyValues:[responseObject objectForKey:@"plot_user4"]];
    SmallArea *plot5 = [SmallArea objectWithKeyValues:[responseObject objectForKey:@"plot_user5"]];
    
    NSMutableArray *nearPlotList = [@[plot0,plot1,plot2,plot3,plot4,plot5] mutableCopy];
    
    self.provinceList = [responseObject objectForKey:@"shenglist"];
    self.cityList = [responseObject objectForKey:@"citylist"];
    self.areaList = [LocationInfo getInstance].areaList = [responseObject objectForKey:@"qulist"];
//    self.plotList = [SmallArea objectArrayWithKeyValuesArray:[responseObject objectForKey:@"xq"]];
    self.plotList = nearPlotList;
    self.dz = [responseObject objectForKey:@"dz"];
    
    
    _address = [NSString stringWithFormat:@"%@%@%@%@", [self.dz objectForKey:@"provincemc"],[self.dz objectForKey:@"citymc"],[self.dz objectForKey:@"areamc"],plot0.plot];
    
    [self chooseLocation:_address
              provinceId: [self.dz objectForKey:@"province"] cityId:[self.dz objectForKey:@"city"] areaId:[self.dz objectForKey:@"area"] plotId:plot0.id plotName:plot0.plot];
    
    if (_addressLabel != nil) {
        _addressLabel.text = _address;
    }
}

-(void)loadMyInfoWithLocation:(double)longitude andLatitude:(double)latitude
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[NSNumber numberWithDouble:longitude] forKey:@"Latitude"];
    [parameters setObject:[NSNumber numberWithDouble:latitude] forKey:@"Longitude"];
    
//MayiWYXC
    [[MayiHttpRequestManager sharedInstance] POST:MayiWYXC parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        
        
        if ([@"1" isEqualToString:[responseObject objectForKey:@"res"]] || 1 == [[responseObject objectForKey:@"res"] intValue]) {
            
            [GlobalVar sharedSingleton].carInfoList = [CarInfo objectArrayWithKeyValuesArray: [responseObject objectForKey:@"clgl"]];
            _userInfo = [UserInfo objectWithKeyValues:[responseObject objectForKey:@"grzl"]];
            
            if (_userInfo != nil) {
                [GlobalVar sharedSingleton].userInfo = _userInfo;
                [self.tableView reloadData];
            }
            
            [self loadAddress:responseObject];
            
           washTypeArray = [WashType objectArrayWithKeyValuesArray:[responseObject objectForKey:@"xcfs"]];
            _selectWashType = [washTypeArray objectAtIndex:0];
            voucherInfoArray = [VoucherInfo objectArrayWithKeyValuesArray:[responseObject objectForKey:@"xcj"]];
            if (voucherInfoArray != nil && voucherInfoArray.count > 0) {
                _voucherInfo = [voucherInfoArray objectAtIndex:0];
            }
            return ;
        }
        else if ([@"2" isEqualToString:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
            return ;
        }
       
        
    } failture:^(NSError *error) {
        [self.view makeToast:@"获取信息失败"];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_descTextView resignFirstResponder];
    [_cheWeiNumTextField resignFirstResponder];
    if (indexPath.row == 8) {
        [self washCommit];
    }
}

-(void)washCommit
{
    if ([StringUtil isEmty:_userInfo.plot]) {
        [SVProgressHUD showErrorWithStatus:@"没有小区信息，无法下单"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:_carNumberLabel.text forKey:@"prov"];
    [parameters setValue:_userInfo.province forKey:@"province"];
    [parameters setValue:_userInfo.city forKey:@"city"];
    [parameters setValue:_userInfo.area forKey:@"area"];
//    [parameters setValue:_userInfo.plot forKey:@"plot"];
    [parameters setValue:_userInfo.plotName forKey:@"plot"];
    [parameters setValue:_selectWashType.id forKey:@"methods"];
    [parameters setValue:_cheWeiNumTextField.text forKey:@"cwh"];
    
//    double value = [_selectWashType.value doubleValue] - (_voucherInfo == nil ? 0 : [_voucherInfo.value doubleValue]);
    
    [parameters setValue:_selectWashType.value forKey:@"methodsval"];
    [parameters setValue:_voucherInfo.id forKey:@"xcjid"];
    [parameters setValue:_voucherInfo.value forKey:@"xcjje"];
         [parameters setValue:_userInfo.color forKey:@"color"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    [parameters setValue:[NSNumber numberWithDouble:time] forKey:@"time"];

    if (!_isFirstEdit) {
        [parameters setValue:_descTextView.text forKey:@"remark"];
    }
    
    double value = [_selectWashType.value doubleValue] - (_voucherInfo == nil ? 0 : [_voucherInfo.value doubleValue]);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PayTableViewController"];
    viewController.accountBalance = _userInfo.money;
    viewController.washParameters = parameters;
    viewController.payValue = [NSString stringWithFormat:@"%.2f",value];
    [self.navigationController pushViewController:viewController animated:YES];
    
//
//    [[MayiHttpRequestManager sharedInstance] POST:MayiWYXCing parameters:parameters showLoadingView:self.view success:^(id responseObject) {
//        
//        
//        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
//            [SVProgressHUD showErrorWithStatus:@"获取失败"];
//            return ;
//        }
//        else if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
//            [SVProgressHUD showErrorWithStatus:@"提交成功"];
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            PayTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PayTableViewController"];
//            
//            viewController.payValue = [responseObject objectForKey:@"zfje"];
//            viewController.accountBalance = _userInfo.money;
//            viewController.order = [responseObject objectForKey:@"num"];
//            
//            [self.navigationController pushViewController:viewController animated:YES];
//            return ;
//        }
//        else if ([WDSystemUtils isEqualsInt:3 andJsonData:[responseObject objectForKey:@"res"]]) {
//
//        }
//
//    } failture:^(NSError *error) {
//        [self.view makeToast:@"注册失败"];
//    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 50;
            break;
        case 1:
            height = 50;
            break;
        case 2:
            height = 50;
            break;
        case 3:
            height = 50;
            break;
        case 4:
            height = 50;
            break;
        case 5:
            height = 50;
            break;
        case 6:
            height = 50;
            break;
        case 7:
            height = 112;
            break;
        case 8:
            height = 50;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - PayCompleteDelegate

-(void)PayType:(int)type andValue:(CGFloat)payValue
{
    
}

#pragma mark - LocationChooseDelegate 

-(void)chooseLocation:(NSString *)address
           provinceId:(NSString *)provinceId
               cityId:(NSString *)cityId
               areaId:(NSString *)areaId
               plotId:(NSString *)plotId
             plotName:(NSString *)plotName
{

    _addressLabel.text = address;
    _userInfo.szdqstr =address;
    _userInfo.province =provinceId;
    _userInfo.city = cityId;
    _userInfo.area = areaId;
    _userInfo.plot = plotId;
    _userInfo.plotName = plotName;
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
            reuseIdentifier = @"CheWeiNumCell";
            break;
        case 4:
            reuseIdentifier = @"CarWashTypeCell";
            break;
        case 5:
            reuseIdentifier = @"CuponCell";
            break;
        case 6:
            reuseIdentifier = @"PriceCell";
            break;
        case 7:
            reuseIdentifier = @"DescCell";
            break;
        case 8:
            reuseIdentifier = @"CommitCell";
            break;
        default:
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell != nil) {
        UIView *view = [cell viewWithTag:1];
        view.layer.borderColor = GeneralLineCGColor;
        view.layer.borderWidth = 0.5;
    }
    cell.backgroundColor = GeneralBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        _carNumberLabel = (UILabel *)[cell viewWithTag:2];
//        if (_userInfo != nil) {
//            _carNumberLabel.text = _userInfo.carnumber;
//        }
        if ([GlobalVar sharedSingleton].carInfoList.count>0) {
            CarInfo *info =  [GlobalVar sharedSingleton].carInfoList[0];
            NSString *str = [info.cp1 stringByAppendingFormat:@"%@%@",info.cp2,info.cp3];
            _carNumberLabel.text = str;
        }
      
    }
    
    if (indexPath.row == 1) {
        _carColorLabel = (UILabel *)[cell viewWithTag:2];
        if (_userInfo != nil) {
            _carColorLabel.text = _userInfo.color;
        }
    }
    
    if (indexPath.row == 2) {
        _addressLabel = (UILabel *)[cell viewWithTag:2];
        if (_userInfo != nil) {
//            _addressLabel.text = _userInfo.szdqstr;
            _addressLabel.text = _address;
        }
    }
    
    if (indexPath.row == 3) {
        _cheWeiNumTextField = (UITextField *)[cell viewWithTag:2];
        if (_userInfo != nil) {
            _cheWeiNumTextField.text = _userInfo.cwh;
        }
    }
    
    
    if (indexPath.row == 4) {
        _washTypeLabel = (UILabel *)[cell viewWithTag:2];
        if (_userInfo != nil) {
            _washTypeLabel.text =  _selectWashType.fs;
        }
    }
    
    if (indexPath.row == 5) {
        _voucherLabel = (UILabel *)[cell viewWithTag:2];
        if (_voucherInfo!=nil) {
            _voucherLabel.attributedText = [StringUtil getMenoyText:@"优惠券金额:" :_voucherInfo.value :@"元"];
        }else{
            _voucherLabel.text = @"暂无优惠券";
        }
    }
    if (indexPath.row == 6) {
        _priceLabel = (NIAttributedLabel *)[cell viewWithTag:2];
        if (_voucherInfo!=nil) {
            NSString *numberString = [StringUtil decimalwithFormat:@"0.00" floatV:[_selectWashType.value floatValue]-[_voucherInfo.value integerValue]];
            
            NSString *text = [numberString stringByAppendingFormat:@"%@",@"元"];
            NSRange range = [text rangeOfString:numberString];
            _priceLabel.text = text;
            [_priceLabel setTextColor:menoyTextColor range:range];

        }else{
            NSString *numberString = _selectWashType.value;
            NSString *text = [numberString stringByAppendingFormat:@"%@",@"元"];
            NSRange range = [text rangeOfString:numberString];
            _priceLabel.text = text;
            [_priceLabel setTextColor:menoyTextColor range:range];
        }
    }
    if (indexPath.row == 7) {
       _descTextView = (UITextView *)[cell viewWithTag:3];
        _descTextView.layer.borderWidth = 0.5;
        _descTextView.layer.borderColor = GeneralLineCGColor;
        _descTextView.delegate = self;
        _descTextView.returnKeyType = UIReturnKeyDefault;
    }
    return cell;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_isFirstEdit) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        _isFirstEdit = NO;
    }
}

//xcj =     (

//           {
//               See = 0;
//               id = 10;
//               judge = 0;
//               ssuid = 0;
//               time = 1444110348;
//               uid = 18550031362;
//               validity = 1444120348;
//               value = "1.00";
//           }
//           );
- (IBAction)voucherChoose:(id)sender {
    [_descTextView resignFirstResponder];
    [_cheWeiNumTextField resignFirstResponder];
    if (_voucherInfo==nil) {
        [self.view makeToast:@"暂无代金券"];
    }else{
        VoucherChoosePop *view = [VoucherChoosePop defaultPopupView];
        view.parentVC = self;
        view.delegate = self;
        view.voucherInfoArray =voucherInfoArray;
        [view initDelegate];
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
          
        }];
        
    }
}
- (IBAction)showCarNumList:(id)sender {
    if ([GlobalVar sharedSingleton].carInfoList.count>0) {
        CarNumChoose *view = [CarNumChoose defaultPopupView];
        view.parentVC = self;
        view.delegate = self;
        //    [view initTableView];
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            
        }];

    }else{
        UserInfoViewController  *uivc = [StoryboadUtil getViewController:@"UserInfo" :@"UserInfoViewController"];
        uivc.title = @"添加车辆";
        uivc.clid = nil;
        [self.navigationController pushViewController:uivc animated:YES];
    }

    
}
- (IBAction)washStyle:(id)sender {
    [_descTextView resignFirstResponder];
    [_cheWeiNumTextField resignFirstResponder];
    WashStyleChoose *view = [WashStyleChoose defaultPopupView];
    view.parentVC = self;
    view.delegate = self;
    view.washTypeArray = washTypeArray;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{

    }];
}
- (IBAction)locationChoose:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LocationChoose1" bundle:nil];
    LocationChooseViewController1 *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"LocationChooseViewController1"];
    viewController.delegate = self;
    viewController.provinceList = self.provinceList;
    [viewController initDataDZ:self.dz nearPlots:self.plotList];
    [self.navigationController pushViewController:viewController animated:YES];
    return;
    
    [[LocationInfo getInstance] clear];
    LocationChoosePop *view = [LocationChoosePop defaultPopupView];
    view.parentVC = self;
    view.mydelegate = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
  
    }];
}
- (IBAction)colorChoose:(id)sender {
    [_descTextView resignFirstResponder];
    [_cheWeiNumTextField resignFirstResponder];
    ColorChoosePop *view = [ColorChoosePop defaultPopupView];
    view.parentVC = self;
    view.delegate = self;
   
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
     
    }];
    
    
    
// UIActionSheet   *myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
//    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    switch (buttonIndex) {
        case 0:
          
            break;
            
        case 1:
          
            break;
            
        default:
            break;
    }
}
-(void)sendColorValue:(NSInteger)value{
    [_carColorLabel setText:[ColorChoosePop colorNameByValue:value]];
    _userInfo.color = _carColorLabel.text;
}
-(void)setWashStyle:(NSInteger *)value{
    _selectWashType = [washTypeArray objectAtIndex:value];
    _washTypeLabel.text = _selectWashType.fs;
//     _priceLabel.text = _selectWashType.value;
    [self.tableView reloadData];
}
//地址选择详情界面回调
-(void)showLocationChoose{
    LocationChoosePop *view = [LocationChoosePop defaultPopupView];
    view.parentVC = self;
    view.mydelegate = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
       
    }];
}

//地址选择弹出框需要显示详情界面回调
-(void)showDetailChoose:(int)channel{
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = channel;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
    

    
}

//地址选择确定回调
-(void)ok{
    LocationInfo *info =[LocationInfo getInstance];
    NSString *locationName;
    if ([info.area_name_province isEqualToString: info.area_name_city]) {
        locationName = [info.area_name_province stringByAppendingFormat:@"%@%@" , info.area_name_area,info.area_name_smallArea ];
    }else{
        locationName = [info.area_name_province stringByAppendingFormat:@"%@%@%@",info.area_name_city,info.area_name_area,info.area_name_smallArea ];
        
    }
    _addressLabel.text = locationName;
    _userInfo.szdqstr =locationName;
    _userInfo.province =info.area_id_province;
    _userInfo.city = info.area_id_city;
    _userInfo.area = info.area_id_area;
    _userInfo.plot = info.area_id_smallArea;
    
   

}
//代金券代理回调
-(void)setVoucherInfo:(VoucherInfo *)value{
    _voucherInfo =value;
    [self.tableView reloadData];
}
//车牌选择回调
-(void)setCarNum:(int)index{
//    _carNumberLabel.text =
    CarInfo *info =  [GlobalVar sharedSingleton].carInfoList[index];
    NSString *str = [info.cp1 stringByAppendingFormat:@"%@%@",info.cp2,info.cp3];
    _carNumberLabel.text = str;

}
@end
