//
//  InvitationCodesViewController.m
//  washcar
//
//  Created by xiejingya on 1/13/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import "InvitationCodesViewController.h"

@interface InvitationCodesViewController(){
   
}



@end

@implementation InvitationCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"邀请码";
 
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self loadData:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InvitationCodeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    title.text = @"2323";
    
    
    return cell;
    
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
- (IBAction)shareAction:(id)sender {
    
    
    
}
-(void)loadData:(BOOL) isShowLoading{
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters setValue:[GlobalVar sharedSingleton].uid forKey:@"uid"];
    //    [parameters setValue:[GlobalVar sharedSingleton].isloginid forKey:@"isloginid"];
    [[MayiHttpRequestManager sharedInstance] POST:MyMsg parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        DLog(@"responseObject%@",responseObject);
        if (responseObject == nil) {
            return ;
        }
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            
            
        }
    } failture:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    }];
    
    
}

@end
