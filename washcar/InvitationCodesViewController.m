//
//  InvitationCodesViewController.m
//  washcar
//
//  Created by xiejingya on 1/13/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import "InvitationCodesViewController.h"

@interface InvitationCodesViewController(){
    
    NSString *wdyqm;//我的验证码
    NSDictionary 　*news;
    NSArray  *yqmlist;
    
   
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
    return yqmlist == nil?0:yqmlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InvitationCodeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    UILabel *title = (UILabel*)[cell viewWithTag:1];
   
     NSDictionary *_dic = yqmlist[indexPath.row];
    NSString *uname = [_dic objectForKey:@"uname"];
    
    if ([StringUtil isEmty:uname]) {
        uname = @"用户名未知";
    }
     title.text = uname;
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
    [[MayiHttpRequestManager sharedInstance] POST:InvitationCode parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        DLog(@"responseObject%@",responseObject);
        if (responseObject == nil) {
            return ;
        }
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            wdyqm = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"wdyqm"]];
            news = [responseObject objectForKey:@"news"];
            yqmlist = [responseObject objectForKey:@"yqmlist"];
            if ([StringUtil isEmty:wdyqm]) {
                wdyqm = @"暂无邀请码";
            }
            _myCode.text = wdyqm;
            [_tableview reloadData];
            
        }
    } failture:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    }];
    
    
}

@end
