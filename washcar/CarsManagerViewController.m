//
//  CarsManagerViewController.m
//  washcar
//
//  Created by xiejingya on 1/13/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import "CarsManagerViewController.h"
#import "GlobalVar.h"
@interface CarsManagerViewController  (){
    NSArray *_array ;
}


@property NSMutableArray *objects;

@end

@implementation CarsManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    [addButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"车辆管理";
    [_tableView   setSeparatorColor:[UIColor    grayColor]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [self loadData:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData:YES];
}

- (void)insertNewObject:(id)sender {
    //    if (!self.objects) {
    //        self.objects = [[NSMutableArray alloc] init];
    //    }
    //    [self.objects insertObject:[NSDate date] atIndex:0];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [self showAddOrEditCarManager:@"添加车辆":nil];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [GlobalVar sharedSingleton].carInfoList.count;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"car_manager_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    //    cell.layer.masksToBounds = YES; //没这句话它圆不起来
    //    cell.layer.cornerRadius = 6.0; //设置图片圆角的尺度
    UILabel *carNum = (UILabel*)[cell viewWithTag:1];
    CarInfo *mCarInfo = [GlobalVar sharedSingleton].carInfoList[indexPath.row];
    //    cp1 = "\U6caa";
    //                    cp2 = A;
    //                    cp3 = 12345;
    
    NSString *cp1 =mCarInfo.cp1;
    NSString *cp2 =mCarInfo.cp2;
    NSString *cp3 =mCarInfo.cp3;
    carNum.text = [cp1 stringByAppendingFormat:@"%@%@",cp2, cp3];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self delRow:YES :indexPath];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarInfo *mCarInfo = [GlobalVar sharedSingleton].carInfoList[indexPath.row];
    NSString *clid =mCarInfo.id;
    [self showAddOrEditCarManager:@"车辆信息编辑":clid];
    
}

-(void)showAddOrEditCarManager:(NSString *) title :(NSString*)clid{
    UserInfoViewController  *uivc = [StoryboadUtil getViewController:@"UserInfo" :@"UserInfoViewController"];
    uivc.title = title;
    uivc.clid = clid;
    [self.navigationController pushViewController:uivc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(void)loadData:(BOOL) isShowLoading{
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:CarManager parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        
        if (responseObject == nil) {
            return ;
        }
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            [GlobalVar sharedSingleton].carInfoList  = [CarInfo objectArrayWithKeyValuesArray: [responseObject objectForKey:@"list"]];
            //            if ([GlobalVar sharedSingleton].carInfoList !=nil&&[GlobalVar sharedSingleton].carInfoList .count>0) {
            //
            //            }
            
            [_tableView reloadData];
            
        }
    } failture:^(NSError *error) {
        //                [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
    
    
}

-(void)delRow:(BOOL) isShowLoading :(NSIndexPath *)indexPath{
    CarInfo *mCarInfo = [GlobalVar sharedSingleton].carInfoList[indexPath.row];
    NSString *clid = mCarInfo.id;
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:clid forKey:@"id"];
    [[MayiHttpRequestManager sharedInstance] POST:DelCL parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        if (responseObject == nil) {
            return ;
        }
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            [SVProgressHUD showErrorWithStatus:@"删除成功"];
            [[GlobalVar sharedSingleton].carInfoList  removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
    
    
}

@end
