//
//  LocationChooseViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "LocationChooseViewController1.h"
#import "MayiHttpRequestManager.h"
#import "Constant.h"
#import "LocationInfo.h"


@interface LocationChooseViewController1 (){
     NSArray *_arrayList;
    NSMutableArray *_searchResult;
    NSArray *_nearPlots;
    NSArray *_ssxPlots;
    UISearchDisplayController *_searchDisplayController;

     NSString *_provinceId;
    NSString *_provinceName;
    NSString *_cityId;
    NSString *_cityName;
    NSString *_areaId;
    NSString *_areaName;
    NSString *_plotId;
    NSString *_plotName;
    SmallArea *_locationPlot;
}


@property (strong, nonatomic) IBOutlet UIControl *provinceControl;
@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;
@property (strong, nonatomic) IBOutlet UIControl *cityControl;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIControl *areaControl;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UITextView *smallAreaTextView;


@property (strong, nonatomic) IBOutlet UITableView *tableView;




@end

@implementation LocationChooseViewController1
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    _provinceControl.layer.borderWidth = 0.5;
    _provinceControl.layer.borderColor = GeneralLineCGColor;
    _cityControl.layer.borderWidth = 0.5;
    _cityControl.layer.borderColor = GeneralLineCGColor;
    _areaControl.layer.borderWidth = 0.5;
    _areaControl.layer.borderColor = GeneralLineCGColor;
    _smallAreaTextView.layer.borderColor = GeneralLineCGColor;
    _smallAreaTextView.layer.borderWidth = 0.5;

    [self.tableView setTableFooterView:[[UIView alloc] init]];
    

    
    self.title = @"设置地址";
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.view addGestureRecognizer:tapGesture];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
    searchBar.placeholder = @"模糊查找小区";
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
    
    _searchDisplayController.delegate = self;
    [_searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PlotCell" bundle:nil] forCellReuseIdentifier:@"PlotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlotCell" bundle:nil] forCellReuseIdentifier:@"PlotCell"];
  
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [_smallAreaTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshView];
}

-(void)initDataDZ:(NSDictionary *)dz
        nearPlots:(NSArray *)nearPlots
        ssxPlots:(NSArray *)ssxPlots
  andLocationPlot:(SmallArea *)smallArea

{
    _nearPlots = nearPlots;
    _ssxPlots = ssxPlots;
    _provinceId = [dz objectForKey:@"province"];
    _provinceName = [dz objectForKey:@"provincemc"];;
    _cityId = [dz objectForKey:@"city"];;
    _cityName = [dz objectForKey:@"citymc"];;
    _areaId = [dz objectForKey:@"area"];;
    _areaName = [dz objectForKey:@"areamc"];;
    _locationPlot = smallArea;
    if (_locationPlot != nil) {
        _provinceId = smallArea.province;
        _cityId = smallArea.city;
        _areaId = smallArea.area;
//        _plotId = smallArea.plot;
    }
    
//    _plotId = [dz objectForKey:@"plot"];
//    _plotName = [dz objectForKey:@"plotmc"];
//    if (_plotName == nil || [@"" isEqualToString:_plotName]) {
//        if (nearPlots != nil) {
//            SmallArea *smallArea = [nearPlots objectAtIndex:0];
//            _plotName = smallArea.plot;
//            _plotId = smallArea.id;
//            
//            _provinceId = smallArea.province;
//            _cityId = smallArea.city;
//            _areaId = smallArea.area;
//        }
//    }

    
    if (_areaId != nil && (nearPlots == nil || nearPlots.count == 0)) {
        [self findSmallArea];
    }
    
   
    
}


-(void)initDataProvinceId:(NSString *)provinceId
             provinceName:(NSString *)provinceName
                   cityId:(NSString *)cityId
                 cityName:(NSString *)cityName
                   areaId:(NSString *)areaId
                 areaName:(NSString *)areaName
                   plotId:(NSString *)plotId
                 plotName:(NSString *)plotName
                nearPlots:(NSArray *)nearPlots

{
    _nearPlots = nearPlots;
    _provinceId = provinceId;
    _provinceName = provinceName;
    _cityId = cityId;
    _cityName = cityName;
    _areaId = areaId;
    _areaName = areaName;
    _plotId = plotId;
    _plotName = plotName;
    
    if (_provinceName!=nil) {
        _provinceLabel.text = _provinceName;
    }else{
        _provinceLabel.text = @"选省";
    }
    
    if (_cityName!=nil) {
        _cityLabel.text = _cityName;
    }else {
        _cityLabel.text = @"选城市";

    }
    
    
    if (_areaName!=nil) {
        _areaLabel.text = _areaName;
        
    }else{
        _areaLabel.text = @"选区县";
    }
    
    if (_plotName!=nil) {
        _smallAreaTextView.text = _plotName;
//        NSString *tmp =[LocationInfo getInstance].area_name_smallArea;
//        if(tmp == nil ||[tmp isEqualToString:@""]||tmp.length == 0){
//            [self.chooseStreet setTitle:@"该地区暂无服务网点" forState:UIControlStateNormal];
//        }else{
//            [self.chooseStreet setTitle:[LocationInfo getInstance].area_name_smallArea forState:UIControlStateNormal];
//        }
    }else{
//        [self.chooseStreet setTitle:@"选小区" forState:UIControlStateNormal];
    }
    
    if (_areaId != nil) {
        [self findSmallArea];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextViewDelegate


- (void)textViewDidEndEditing:(UITextView *)textView
{
    DLog(@"end");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_smallAreaTextView resignFirstResponder];
}



-(NSString *)generalAddress
{

    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",_provinceName,_cityName,
                         _areaName,_plotName];
    return address;
}

-(void)findSmallArea
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:[LocationInfo getInstance].area_id_province forKey:@"province"];
//    [parameters setObject:[LocationInfo getInstance].area_id_city forKey:@"city"];
    [parameters setObject:_areaId forKey:@"area"];

    [[MayiHttpRequestManager sharedInstance] POST:@"area" parameters:parameters showLoadingView:nil success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            _ssxPlots = [SmallArea objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
//            [self.tableView reloadData];
        }
        
    } failture:^(NSError *error) {
        DLog(@"error:%@",error);
    }];
}


#pragma mark - 界面事件
- (IBAction)provinceControlClick:(id)sender {
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = 0;
    mLocationChooseViewController.arrayList = _provinceList;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}

- (IBAction)cityControlClick:(id)sender {
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = 1;
    mLocationChooseViewController.parentId = _provinceId;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}

- (IBAction)areaControlClicked:(id)sender {
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = 2;
    mLocationChooseViewController.parentId = _cityId;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}

#pragma mark - LocationChooseViewControllerDelegate

-(void)refreshView
{
    if (_provinceName!=nil) {
        _provinceLabel.text = _provinceName;
    }else{
        _provinceLabel.text = @"选省";
    }
    
    if (_cityName!=nil) {
        _cityLabel.text = _cityName;
    }else {
        _cityLabel.text = @"选城市";
        
    }
    
    
    if (_areaName!=nil) {
        _areaLabel.text = _areaName;
        
    }else{
        _areaLabel.text = @"选区县";
    }
    
    if (_plotName!=nil) {
        _smallAreaTextView.text = _plotName;
        
    }else{
        _smallAreaTextView.text = @"";
    }
    [self.tableView reloadData];
}

- (void) showAreaChannel:(int)chanel
                      id:(NSString *)id
                    name:(NSString *)name
{
    switch(chanel) {
        case 0:
            if (_provinceId == nil || [@"" isEqualToString:_provinceId]) {
                _provinceId = id;
                _provinceName = name;
                _provinceLabel.text = name;
                
                
            }
            else {//_provinceId is not empty
                if ([_provinceId isEqualToString:id]) {
                    
                }
                else {
                    _provinceId = id;
                    _provinceName = name;
                    _provinceLabel.text = name;
                    
                    _cityId = nil;
                    _cityName = nil;
                    
                    _areaId = nil;
                    _areaName = nil;
                    
                    _plotId = nil;
                    _plotName = nil;
                    
                    _ssxPlots = nil;
                    
                    
                }
            }
            
            break;
        case 1:
            
            if (_cityId == nil || [@"" isEqualToString:_cityId]) {
                _cityId = id;
                _cityName = name;
                _cityLabel.text = name;
            }
            else {//_provinceId is not empty
                if ([_provinceId isEqualToString:id]) {
                    
                }
                else {
                    _cityId = id;
                    _cityName = name;
                    _cityLabel.text = name;
                    
                    _areaName = nil;
                    _areaId = nil;
                    
                    _plotId = nil;
                    _plotName = nil;
                    
                    _ssxPlots = nil;
                    
                    
                }
            }
            break;
        case 2:
            _areaId = id;
            _areaName = name;
            _areaLabel.text = name;
            
            if (_areaId == nil || [@"" isEqualToString:_areaId]) {
                _areaId = id;
                _areaName = name;
                _areaLabel.text = name;
                
                [self findSmallArea];
            }
            else {//_provinceId is not empty
                if ([_provinceId isEqualToString:id]) {
                    
                }
                else {
                    _areaId = id;
                    _areaName = name;
                    _areaLabel.text = name;
                    
                    _plotId = nil;
                    _plotName = nil;
                    
                    _ssxPlots = nil;
                    
                    [self findSmallArea];
                }
            }
            
            break;
        case 3:
            break;
    }
    [self refreshView];
}



#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        
        if (_nearPlots != nil) {
            return @"附近的网点";
        }
        else {
            return @"";
        }
        
        
    }
    else {
        return @"";
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"PlotCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    UILabel *labelPlot = (UILabel *)[cell viewWithTag:1];
    
    if (tableView == self.tableView) {
        SmallArea *smallArea = [_nearPlots objectAtIndex:indexPath.row];
        labelPlot.text = smallArea.plot;
        
    }
    else {
        SmallArea *smallArea = [_searchResult objectAtIndex:indexPath.row];
        labelPlot.text = smallArea.plot;
    }

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView == self.tableView) {
//        return 1;
//    }
//    else {
//        return 1;
//    }
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (_nearPlots == nil) {
            return 0;
        }
        else {
            return _nearPlots.count;
        }
    }
    else
    {
        _searchResult = [NSMutableArray array];
        NSString *searchText = _searchDisplayController.searchBar.text;
        DLog(@"searchText:%@",searchText);
        if (searchText == nil || [@"" isEqualToString:searchText]) {
            [_searchResult addObjectsFromArray:_ssxPlots];
        }
        else {
            for (SmallArea *smallArea in _ssxPlots) {
                if ([smallArea.plot rangeOfString:searchText].length > 0) {
                    [_searchResult addObject:smallArea];
                }
            }
        }
        DLog(@"_searchResult count:%i", _searchResult.count);
        return _searchResult.count;
    }
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  60.0f;
//}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            SmallArea *smallArea  = [_nearPlots objectAtIndex:indexPath.row];
//            _smallAreaTextView.text = smallArea.plot;
//            _plotId = smallArea.id;
//            _plotName = smallArea.plot;
            
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@",smallArea.provincemc,smallArea.citymc,smallArea.areamc,smallArea.plot];
            
            if (_delegate && [_delegate conformsToProtocol:@protocol(LocationChooseDelegate)]) {
                [_delegate chooseLocation:address provinceId:smallArea.province cityId:smallArea.city areaId:smallArea.area plotId:smallArea.id plotName:smallArea.plot];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {

            
        }
        
    }
    else {
        SmallArea *smallArea  = [_searchResult objectAtIndex:indexPath.row];
        _smallAreaTextView.text = smallArea.plot;
        
        _plotId = smallArea.id;
        _plotName = smallArea.plot;
        [_searchDisplayController setActive:NO animated:YES];
    }

    
    
}


-(void)viewWillDisappear:(BOOL)animated{
     
}

- (IBAction)rightButtonClicked:(id)sender {
    if ([WDSystemUtils isEmptyOrNullString:_provinceName]) {
        [SVProgressHUD showErrorWithStatus:@"未选择省份"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_cityId]) {
        [SVProgressHUD showErrorWithStatus:@"未选择城市"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_areaId]) {
        [SVProgressHUD showErrorWithStatus:@"未选择区县"];
        return;
    }
    
    if ([WDSystemUtils isEmptyOrNullString:_plotId]) {
        [SVProgressHUD showErrorWithStatus:@"未选择小区"];
        return;
    }
    
    
    if (_delegate && [_delegate conformsToProtocol:@protocol(LocationChooseDelegate)]) {
        [_delegate chooseLocation:[self generalAddress] provinceId:_provinceId cityId:_cityId areaId:_areaId plotId:_plotId plotName:_plotName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
