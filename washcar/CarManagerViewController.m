//
//  CarManagerViewController.m
//  washcar
//
//  Created by jingyaxie on 16/1/8.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import "CarManagerViewController.h"

@interface CarManagerViewController (){
     NSArray *_array ;
}


@property NSMutableArray *objects;

@end

@implementation CarManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    [addButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addButton;
      self.navigationItem.title = @"车辆管理";
    [self loadData:YES];
}

- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [self showAddOrEditCarManager:@"添加车辆"];
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
    return _array==nil?0:_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"car_manager_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    
    UILabel *carNum = (UILabel*)[cell viewWithTag:1];
     NSDictionary *_dic = _array[indexPath.row];
//    carNum.text = [_dic objectForKey:@"title"];
  
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showAddOrEditCarManager:@"车辆信息编辑"];
    
}

-(void)showAddOrEditCarManager:(NSString *) title{
    UserInfoViewController  *uivc = [StoryboadUtil getViewController:@"UserInfo" :@"UserInfoViewController"];
    
    uivc.title = title;
    [self.navigationController pushViewController:uivc animated:YES];
}

-(void)loadData:(BOOL) isShowLoading{
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
//        [parameters setValue:[GlobalVar sharedSingleton].uid forKey:@"uid"];
//        [parameters setValue:[GlobalVar sharedSingleton].isloginid forKey:@"isloginid"];
    [[MayiHttpRequestManager sharedInstance] POST:CarManager parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        DLog(@"responseObject%@",responseObject);
        if (responseObject == nil) {
            return ;
        }
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            _array= [responseObject objectForKey:@"list"];
            if (_array!=nil&&_array.count>0) {
                
            }
      
        }
    } failture:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    }];
    
    
}

@end
