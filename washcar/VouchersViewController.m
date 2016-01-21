//
//  VouchersViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "VouchersViewController.h"
#import "MayiHttpRequestManager.h"
#import "Constant.h"
#import "VoucherInfo.h"
#import "DateUtil.h"
@interface VouchersViewController (){
    
    NSMutableArray *_arry;
    int page;
    int selectIndex;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation VouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    page = 1;
    _arry = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    //    NSString* timeStr = @"2011-01-26 17:40:50";
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    
    
}
-(void)headerRereshing{
    [_tableview.header beginRefreshing];
    [self refreshData:1 :NO];
}

-(void)footerRereshing{
    [self refreshData:page+1:NO];
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


-(void)viewWillAppear:(BOOL)animated{
    
    [self refreshData:1 :YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"voucher_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    UILabel *money = [cell viewWithTag:1];
    UILabel *time = [cell viewWithTag:2];
    UIImageView *bg = [cell viewWithTag:3];
    NSDictionary *_voucherInfo = _arry[indexPath.row];
    if (_voucherInfo!=nil) {
        money.text =[_voucherInfo objectForKey:@"value"];
        NSMutableString *str = [[NSMutableString alloc]init];
        [str appendFormat:@"有效期至："];
        [str appendFormat:[DateUtil nsdateToString:[DateUtil changeSpToTime:[_voucherInfo objectForKey:@"validity"]]:@"yyyy-MM-dd"]];
        time.text = [NSString stringWithString:str];
    }
    if (self.voucherType==1) {
        NSMutableString *str = [[NSMutableString alloc]init];
        [str appendFormat:@"使用时间："];
        [str appendFormat:[DateUtil nsdateToString:[DateUtil changeSpToTime:[_voucherInfo objectForKey:@"time"]]:@"yyyy-MM-dd"]];
    }
    
    if (self.voucherType==1) {
        [bg setImage:[UIImage imageNamed:@"voucher_nouse.png"]];
    }
    if (self.voucherType==2) {
        [bg setImage:[UIImage imageNamed:@"voucher_used.png"]];
    }
    if (self.voucherType==3) {
        [bg setImage:[UIImage imageNamed:@"voucher_reciver.png"]];
    }
    NSString *isvalidity = [NSString stringWithFormat:@"%@",[_voucherInfo objectForKey:@"isvalidity"]];
    
    if ([@"2" isEqualToString:isvalidity]) {
        
        [bg setImage:[UIImage imageNamed:@"voucher_timeover.png"]];
    }
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arry==nil) {
        return 0;
    }
    return _arry.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.voucherType==0) {
        selectIndex = indexPath.row;
        NSDictionary *_voucherInfo = _arry[selectIndex];
        NSString *isvalidity = [NSString stringWithFormat:@"%@",[_voucherInfo objectForKey:@"isvalidity"]];
        DLog(@"didSelectRowAtIndexPath isvalidity=%@",isvalidity);
        if ([@"2" isEqualToString:isvalidity]) {
            [self.view makeToast:@"洗车券已经过期"];
            return;
        }
        NSString *info = [@"确认领取" stringByAppendingFormat:@"%@%@",  [_voucherInfo objectForKey:@"value"] ,@"元洗车券" ];
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:info message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [_alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self reciveVoucher:@"xcjlq" :YES];
    }
}

-(void)refreshData:(int)pager:(BOOL) isShowLoading{
    DLog(@"viewWillAppear voucherType=%d",self.voucherType);
    
    
    //    //未领取洗车券
    //    NSString * const NotReceivingVoucher = @"xcjwlq";
    //
    //    //已领取洗车券
    //    NSString * const HasReceivingVoucher = @"xcjysy";
    //
    //    //未使用洗车券
    //    NSString * const NoUseVoucher = @"xcjwsy";
    //获取未使用的代金券
    if (self.voucherType==1) {
        [self loadData:NoUseVoucher :pager:isShowLoading];
    }
    //获取已经使用的代金券
    if (self.voucherType==2) {
        [self loadData:HasReceivingVoucher :pager :isShowLoading];
    }
    //获取未领取洗车券
    if (self.voucherType==3) {
        [self loadData:NotReceivingVoucher :pager :isShowLoading];
    }
}


-(void)loadData:(NSString*)url:(int)pager:(BOOL)isShowLoading{
    UIView *loadingView;
    if (isShowLoading) {
        loadingView = self.view;
    }
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *stringInt = [NSString stringWithFormat:@"%d",pager];
    [parameters setValue:stringInt forKey:@"page"];
    [[MayiHttpRequestManager sharedInstance] POST:url parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            NSArray  *arry_tmp;
            if ([[responseObject objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                arry_tmp= [responseObject objectForKey:@"list"];
            }
            @try {
                arry_tmp.count;
                if (pager ==1) {
                    [_arry removeAllObjects];
                    [_arry addObjectsFromArray:arry_tmp];
                    if (_arry.count==10) {
                        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
                        //                        [_tableview addFooterWithTarget:self action:@selector(footerRereshing)];
                        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                        page = 1;
                    }
                }else{
                    if (arry_tmp.count>0) {
                        [_arry addObjectsFromArray:arry_tmp];
                        page++;
                    }
                    if (arry_tmp.count<10) {
                        //                        [_tableview removeFooter];
                    }
                }
            }
            @catch (NSException *exception) {
                if (pager ==1) {
                    _arry = nil;
                }
            }
            @finally {
                [self.tableview reloadData];
                [_tableview.header endRefreshing];
                [_tableview.footer endRefreshing];
            }
            
        }else{
            //            [SVProgressHUD showErrorWithStatus:@"洗车券获取失败！"];
        }
    } failture:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"洗车券获取失败！"];
    }];
}

//xcjlq接口
-(void)reciveVoucher:(NSString*)url:(BOOL)isShowLoading{
    UIView *loadingView;
    if (isShowLoading) {
        loadingView = self.view;
    }
    NSDictionary *_voucherInfo = _arry[selectIndex];
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[_voucherInfo objectForKey:@"id"] forKey:@"id"];
    [[MayiHttpRequestManager sharedInstance] POST:url parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"2" isEqualToString:res]) {
            [SVProgressHUD showSuccessWithStatus:@"洗车券领取成功！"];
            [self headerRereshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"洗车券领取失败！"];
        }
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"洗车券领取失败！"];
    }];
    
}
@end
