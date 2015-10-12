//
//  MyMsgViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "MyMsgViewController.h"
#import "MayiHttpRequestManager.h"
#import "Constant.h"
#import "DateUtil.h"
@interface MyMsgViewController (){
    NSMutableArray *_arry;
    int page ;
    NSMutableDictionary *isReadMap;
    float detail_width;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _arry = [[NSMutableArray alloc]init];
    page = 1;
    [self loadData:MyMsg :page:YES];
    
    [_tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    isReadMap = [[NSMutableDictionary alloc]init ];
    
}
-(void)headerRereshing{
    
    [self loadData:MyMsg :1:NO];
}

-(void)footerRereshing{
    [self loadData:MyMsg :page+1:NO];
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
    static NSString *identifier = @"my_msg";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *time = (UILabel*)[cell viewWithTag:2];
    UILabel *detail = (UILabel*)[cell viewWithTag:4];
    UIView *isRead = (UIView*)[cell viewWithTag:5];
    UIButton *more = (UIButton*)[cell viewWithTag:6];
    NSDictionary *_dic = _arry[indexPath.row];
    title.text = [_dic objectForKey:@"title"];
    time.text = [DateUtil nsdateToString:[DateUtil changeSpToTime:[_dic objectForKey:@"time"]]:@"yyyy-MM-dd HH:mm:ss"];
    detail.text = [_dic objectForKey:@"news"];
    detail_width =detail.frame.size.width;
    int judge = 0;
    @try {
        judge =[[_dic objectForKey:@"judge"] integerValue];
    }
    @catch (NSException *exception) {
        judge = 0;
    }
    if (judge==0) {
        isRead.hidden = NO;
    }else{
        isRead.hidden = YES;
    }
    NSString *key = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    detail.hidden = YES;
     more.hidden = NO;
    if ([[isReadMap allKeys]containsObject:key] ) {
        detail.hidden = NO;
        isRead.hidden = YES;
        more.hidden = YES;
    }
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arry==nil) {
        return  0;
    }
    return _arry.count;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%d",(int)indexPath.row];
  
    if ([[isReadMap allKeys]containsObject:key] ) {
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:14];
        // 該行要顯示的內容
        NSDictionary *_dic = _arry[indexPath.row];
        NSString *content = [_dic objectForKey:@"news"];
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(detail_width, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        // 這裏返回需要的高度
        return size.height+75;
    }else{
        return 75;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     int  row = indexPath.row;
    NSString *key = [NSString stringWithFormat:@"%d",row];
    if ([[isReadMap allKeys]containsObject:key] ) {
        //        [isReadMap removeObjectForKey:key];
    }else{
        [isReadMap setValue:key forKey:key];
        NSDictionary *_dic = _arry[row];
        int judge = 0;
        @try {
            judge =[[_dic objectForKey:@"judge"] integerValue];
        }
        @catch (NSException *exception) {
            judge = 0;
        }
        if(judge==0){
            NSString *msgid = [_dic objectForKey:@"id"];
            [self seenMoreHttp:msgid];
        }
    }
    
    [self.tableview reloadData];
}

//-(void)seeDetail:(UIButton*)btn{
//    int  row = btn.tag;
//    NSString *key = [NSString stringWithFormat:@"%d",row];
//    if ([[isReadMap allKeys]containsObject:key] ) {
////        [isReadMap removeObjectForKey:key];
//    }else{
//        [isReadMap setValue:key forKey:key];
//        NSDictionary *_dic = _arry[row];
//        int judge = 0;
//        @try {
//            judge =[[_dic objectForKey:@"judge"] integerValue];
//        }
//        @catch (NSException *exception) {
//            judge = 0;
//        }
//        if(judge==0){
//            NSString *msgid = [_dic objectForKey:@"id"];
//            [self seenMoreHttp:msgid];
//        }
//    }
//    
//    [self.tableview reloadData];
//    
//    
//}

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
                        [_tableview addFooterWithTarget:self action:@selector(footerRereshing)];
                        page = 1;
                    }
                }else{
                    if (arry_tmp.count>0) {
                        [_arry addObjectsFromArray:arry_tmp];
                        page++;
                    }
                    if (arry_tmp.count<10) {
                        [_tableview removeFooter];
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

-(void)seenMoreHttp:(NSString*)msgid{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:msgid forKey:@"id"];
    [[MayiHttpRequestManager sharedInstance] POST:MyMsgDetail parameters:parameters showLoadingView:nil success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            
            
        }else{
            
        }
    } failture:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"洗车券获取失败！"];
    }];
    
    
}

@end
