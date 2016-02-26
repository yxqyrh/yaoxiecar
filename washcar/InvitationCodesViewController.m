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
    
    NSString *_title;
    NSString *_description;
    NSString *_imageUrl;
    NSString *_url;
   
}



@end

@implementation InvitationCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"邀请码";
 
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSString *uname = [_dic objectForKey:@"uid"];
    
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
    
    if (_title == nil || [@"" isEqualToString:_title]) {
        return;
    }
    

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_description
                                         images:[NSURL URLWithString:_imageUrl]
                                            url:[NSURL URLWithString:_url]
                                          title:_title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    
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
            _title = [news objectForKey:@"Title"];
            _description = [news objectForKey:@"Description"];
            _imageUrl = [news objectForKey:@"PicUrl"];
            _url = [news objectForKey:@"Url"];
            
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
