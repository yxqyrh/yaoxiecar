//
//  LocationChooseViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "LocationChooseViewController.h"
#import "MayiHttpRequestManager.h"
#import "Constant.h"
#import "LocationInfo.h"
@interface LocationChooseViewController (){
     NSArray *_arrayList;
    UIView *mengban;
}


@end

@implementation LocationChooseViewController
@synthesize channel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view from its nib.
    _tableview.delegate = self;
    _tableview.dataSource = self;
    mengban = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mengban.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mengban];
    DLog(@"_channel=%d",self.channel);
    switch (self.channel) {
        case 0:
            [self loadProvinceList];
            self.navigationItem.title = @"省份列表";
            break;
        case 1:
            self.navigationItem.title = @"城市列表";
            self.area_id = [LocationInfo getInstance].area_id_province;
            [self loadCityList];
            break;
        case 2:
            self.navigationItem.title = @"地区列表";
            self.area_id = [LocationInfo getInstance].area_id_city;
            [self loadAreaList];
            break;
        case 3:
            self.navigationItem.title = @"小区列表";
             self.area_id = [LocationInfo getInstance].area_id_area;
             [self loadSmallAreaList];
            break;
            
        default:
            break;
    }
    [self.navigationItem.backBarButtonItem setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"location_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    UILabel *title = [cell viewWithTag:1];
    NSDictionary *_dic = _arrayList[indexPath.row];
    switch (self.channel) {
        case 0:
        case 1:
        case 2:
             title.text = [_dic objectForKey:@"area_name"];
            break;
        case 3:
            
             title.text = [_dic objectForKey:@"plot"];
            break;
        default:
            break;
    }
    
    
   
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrayList==nil) {
        return 0;
    }
    return _arrayList.count;
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  60.0f;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *_data =[_arrayList objectAtIndex:indexPath.row];
    NSString *area_id;
    NSString *name;
    switch (self.channel) {
        case 0:
        case 1:
        case 2:
            area_id = (NSString*)[_data objectForKey:@"area_id"];
            name = (NSString*)[_data objectForKey:@"area_name"];
            break;
        case 3:
            area_id = (NSString*)[_data objectForKey:@"id"];
            name = (NSString*)[_data objectForKey:@"plot"];
            break;
        default:
            break;
    }
 
    [self chooseLoaction:area_id :name];
 
}

-(void)chooseLoaction:(NSString*)area_id:(NSString*)name{
    if (_mydelegate != nil && [_mydelegate conformsToProtocol:@protocol(LocationChooseViewControllerDelegate)]) { // 如果协议响应了
        switch (self.channel) {
            case 0:
                [LocationInfo getInstance].area_id_province =area_id;
                [LocationInfo getInstance].area_name_province =name;
                [LocationInfo getInstance].area_id_city =nil;
                [LocationInfo getInstance].area_name_city =nil;
                [LocationInfo getInstance].area_id_area =nil;
                [LocationInfo getInstance].area_name_area =nil;
                [LocationInfo getInstance].area_id_smallArea =nil;
                [LocationInfo getInstance].area_name_smallArea =nil;
                break;
            case 1:
                [LocationInfo getInstance].area_id_city =area_id;
                [LocationInfo getInstance].area_name_city =name;
                [LocationInfo getInstance].area_id_area =nil;
                [LocationInfo getInstance].area_name_area =nil;
                [LocationInfo getInstance].area_id_smallArea =nil;
                [LocationInfo getInstance].area_name_smallArea =nil;
                break;
            case 2:
                [LocationInfo getInstance].area_id_area =area_id;
                [LocationInfo getInstance].area_name_area =name;
                [LocationInfo getInstance].area_id_smallArea =nil;
                [LocationInfo getInstance].area_name_smallArea =nil;
                break;
            case 3:
                [LocationInfo getInstance].area_id_smallArea =area_id;
                [LocationInfo getInstance].area_name_smallArea =name;
                break;
            default:
                break;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
 
    

    
}

-(void)viewWillDisappear:(BOOL)animated{
     [_mydelegate showLocationChoose];
}


-(void)loadProvinceList{
    [self loadData:ProvinceApi];
}
-(void)loadCityList{
    [self loadData:CityApi];
    
}
-(void)loadAreaList{
    [self loadData:AreaApi];
}
-(void)loadSmallAreaList{
    [self loadData:SmallAreaApi];
}


-(void) loadData:(NSString *) api{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSLog(@"_area_id=%@",_area_id);
    NSString *key;
    
      if (_area_id!=nil) {
          switch (self.channel) {
              case 0:
                  
                break;
              case 1:
                  key = @"province";
                  break;
              case 2:
                  key = @"city";
                  break;
              case 3:
                  key = @"area";
                  break;
              default:
                  break;
          }
          [parameters setValue:_area_id forKey:key];
      }
    
    

    
    [[MayiHttpRequestManager sharedInstance] POST:api parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        
         DLog(@"res=%@",res)
        if ([@"1" isEqualToString:res]) {
            @try {
                 _arrayList = [responseObject objectForKey:@"list"];
                _arrayList.count;
            }
            @catch (NSException *exception) {
                _arrayList = nil;
                if(self.channel==3){
                    [LocationInfo getInstance].area_id_smallArea =@"";
                    [LocationInfo getInstance].area_name_smallArea =@"";
                    [SVProgressHUD showErrorWithStatus:@"该地区暂无服务网点"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            [self.tableview reloadData];
            [mengban removeFromSuperview];
        }else{
          
        }
    } failture:^(NSError *error) {
        DLog(@"error=")
    }];
    
}


@end
