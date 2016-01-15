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
#import "SmallArea.h"

@interface LocationChooseViewController1 (){
     NSArray *_arrayList;
    NSMutableArray *_searchResult;
    NSArray *_nearPlots;
    UISearchDisplayController *_searchDisplayController;
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
    searchBar.placeholder = @"搜索";
    
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
    
    
    [self initData:2];
  
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [_smallAreaTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData:(int)chanel
{
    _nearPlots = [LocationInfo getInstance].plotList;
    
    if ([LocationInfo getInstance].area_name_province!=nil) {
        _provinceLabel.text = [LocationInfo getInstance].area_name_province;
    }else{
        _provinceLabel.text = @"选省";
    }
    
    if ([LocationInfo getInstance].area_name_city!=nil) {
        _cityLabel.text = [LocationInfo getInstance].area_name_city;
    }else {
        _cityLabel.text = @"选城市";

    }
    
    
    if ([LocationInfo getInstance].area_name_area!=nil) {
        _areaLabel.text = [LocationInfo getInstance].area_name_area;
        
    }else{
        _areaLabel.text = @"选区县";
    }
    
    if ([LocationInfo getInstance].area_name_smallArea!=nil) {
        _smallAreaTextView.text = [LocationInfo getInstance].area_name_smallArea;
//        NSString *tmp =[LocationInfo getInstance].area_name_smallArea;
//        if(tmp == nil ||[tmp isEqualToString:@""]||tmp.length == 0){
//            [self.chooseStreet setTitle:@"该地区暂无服务网点" forState:UIControlStateNormal];
//        }else{
//            [self.chooseStreet setTitle:[LocationInfo getInstance].area_name_smallArea forState:UIControlStateNormal];
//        }
    }else{
//        [self.chooseStreet setTitle:@"选小区" forState:UIControlStateNormal];
    }
    
    if (chanel == 2 && [LocationInfo getInstance].area_id_area != nil) {
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
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    DLog(@"text:%@",text);
    
    if (_allPlots == nil || _allPlots.count == 0) {
        return;
    }
    
    _filtedPlots = [NSMutableArray array];
    for (SmallArea *smallArea in _allPlots) {
        if ([smallArea.plot rangeOfString:text].length > 0) {
            [_filtedPlots addObject:smallArea];
        }
    }
    [self.tableView reloadData];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    DLog(@"end");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_smallAreaTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (_delegate && [_delegate conformsToProtocol:@protocol(LocationChooseDelegate)]) {
            [_delegate chooseLocation:[self generalAddress]];
        }
        
        return NO;
    }
    
    return YES;
}

-(NSString *)generalAddress
{
    [LocationInfo getInstance].area_id_smallArea = @"";
    [LocationInfo getInstance].area_name_smallArea = @"";
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",[LocationInfo getInstance].area_name_province,[LocationInfo getInstance].area_name_city,
                         [LocationInfo getInstance].area_name_area,_smallAreaTextView.text];
    return address;
}

-(void)findSmallArea
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:[LocationInfo getInstance].area_id_province forKey:@"province"];
//    [parameters setObject:[LocationInfo getInstance].area_id_city forKey:@"city"];
    [parameters setObject:[LocationInfo getInstance].area_id_area forKey:@"area"];

    [[MayiHttpRequestManager sharedInstance] POST:@"area" parameters:parameters showLoadingView:nil success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            _allPlots = [SmallArea objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
//            _filtedPlots = [NSMutableArray arrayWithArray:_allPlots];
            [self.tableView reloadData];
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
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}

- (IBAction)cityControlClick:(id)sender {
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = 1;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}

- (IBAction)areaControlClicked:(id)sender {
    UIStoryboard  *board=  [UIStoryboard storyboardWithName:@"LocationChoose" bundle:nil];
    LocationChooseViewController *mLocationChooseViewController = [board instantiateViewControllerWithIdentifier:@"LocationChooseViewController"];
    mLocationChooseViewController.mydelegate = self;
    mLocationChooseViewController.channel = 2;
    [self.navigationController pushViewController:mLocationChooseViewController animated:YES];
}

#pragma mark - LocationChooseViewControllerDelegate

- (void) showLocationChoose:(int)chanel
{
    [self initData:chanel];
}



#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return @"附近的小区";
        }
        else {
            return @"全部";
        }
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"PlotCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    UILabel *labelPlot = (UILabel *)[cell viewWithTag:1];
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            SmallArea *smallArea = [_nearPlots objectAtIndex:indexPath.row];
            labelPlot.text = smallArea.plot;
        }
        else if (indexPath.section == 1) {
            SmallArea *smallArea = [_allPlots objectAtIndex:indexPath.row];
            labelPlot.text = smallArea.plot;
        }
    }
    else {
        SmallArea *smallArea = [_searchResult objectAtIndex:indexPath.row];
        labelPlot.text = smallArea.plot;
    }

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 1;
    }
    else {
        return 1;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            if (_nearPlots == nil) {
                return 0;
            }
            else {
                return _nearPlots.count;
            }
        }
        else  {
            if (_allPlots == nil) {
                return 0;
            }
            return _allPlots.count;
        }

    }
    else
    {
        _searchResult = [NSMutableArray array];
        NSString *searchText = _searchDisplayController.searchBar.text;
        
        for (SmallArea *smallArea in _allPlots) {
            if ([smallArea.plot rangeOfString:searchText].length > 0) {
                [_searchResult addObject:smallArea];
            }
        }
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
            _smallAreaTextView.text = smallArea.plot;
            [LocationInfo getInstance].area_id_smallArea = smallArea.id;
            [LocationInfo getInstance].area_name_smallArea = smallArea.plot;
        }
        else {
            SmallArea *smallArea  = [_allPlots objectAtIndex:indexPath.row];
            _smallAreaTextView.text = smallArea.plot;
            [LocationInfo getInstance].area_id_smallArea = smallArea.id;
            [LocationInfo getInstance].area_name_smallArea = smallArea.plot;
            
        }
        
    }
    else {
        SmallArea *smallArea  = [_searchResult objectAtIndex:indexPath.row];
        _smallAreaTextView.text = smallArea.plot;
        
        [LocationInfo getInstance].area_id_smallArea = smallArea.id;
        [LocationInfo getInstance].area_name_smallArea = smallArea.plot;
        [_searchDisplayController setActive:NO animated:YES];
    }

    
    
}


-(void)viewWillDisappear:(BOOL)animated{
     
}

- (IBAction)rightButtonClicked:(id)sender {
    if (_delegate && [_delegate conformsToProtocol:@protocol(LocationChooseDelegate)]) {
        [_delegate chooseLocation:[self generalAddress]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
