//
//  UserCenterViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "UserCenterViewController.h"

#import "Constant.h"
#import "GlobalVar.h"
#import "MayiHttpRequestManager.h"
#import "ReChargeViewController.h"
#import "StoryboadUtil.h"
#import "StringUtil.h"
@interface UserCenterViewController ()

{
    UserInfoViewController *uivc;
    VouchersThreeViewController *vvc;
    MyMsgViewController *mmvc;
    ComplaintViewController *clvc;
    CommonProblemViewController *cpvc;
    UIStoryboard *board ;
    NSArray *titles;
    NSArray *icons;
    UILabel *voucherNum;
    UILabel *msgNum;
    NSString *icon_url;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation UserCenterViewController
//充值
- (IBAction)recharge:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReChargeViewController *rechargeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
    rechargeViewController.checkInMoney = 50;
    [self.navigationController pushViewController:rechargeViewController animated:YES];
    
}

- (void)viewDidLoad {
//     [ProgressHUD show:@"加载中..."];
    [super viewDidLoad];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins: UIEdgeInsetsZero];
    }
    board = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    titles = [NSArray arrayWithObjects:@"个人信息",@"洗车券",@"我的消息",@"投诉建议",@"常见问题解答",nil];
    icons = [NSArray arrayWithObjects:@"user_info_icon",@"vouchers_icon",@"user_msg_icon",@"complaint_icon",@"common_problem_icon",nil];
    // Do any additional setup after loading the view.
    _userIcon.layer.masksToBounds = YES; //没这句话它圆不起来
    _userIcon.layer.cornerRadius = _userIcon.frame.size.width/2; //设置图片圆角的尺度
    _surplusMoney.layer.borderWidth = 0.5;
    _surplusMoney.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:204/255.0 green:204/255.0  blue:255/255.0  alpha:1.0]);
    _surplusMoney.attributedText = [StringUtil getMenoyText:@"余额" :@"0.00" :@"元"];
    [self loadData:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData:NO];
    
    self.parentViewController.title = @"个人中心";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置剩余钱数

-(void) setMoney:(NSString *) num{
    if (num==nil) {
        num = @"0.0";
    }
//    NSMutableString *money = [[NSMutableString alloc]init];
//   [money appendFormat:@"余额"];
//        [money appendFormat:num];
//        [money appendFormat:@"元"]
     _surplusMoney.attributedText = [StringUtil getMenoyText:@"余额" :num :@"元"];
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
   
    static NSString *identifier = @"user_center_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    
    UIImageView *icon = (UIImageView*)[cell viewWithTag:1];
    UILabel *title = (UILabel*)[cell viewWithTag:2];
    
    UILabel *num = (UILabel*)[cell viewWithTag:3];
    num.layer.masksToBounds = YES; //没这句话它圆不起来
    num.layer.cornerRadius = num.frame.size.width/2; //设置图片圆角的尺度
    num.hidden = YES;
    if ([@"洗车券" isEqualToString:[titles objectAtIndex:indexPath.row]]) {
        voucherNum = num;
    }
    if ([@"我的消息" isEqualToString:[titles objectAtIndex:indexPath.row]]) {
        msgNum = num;
    }
    title.text = [titles objectAtIndex:indexPath.row];
    icon.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  60.0f;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
//            if (SCREEN_HEIGHT==960) {
//                
//            }else{
//                 uivc = [board instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
//            }
//            
            uivc = [StoryboadUtil getViewController:@"UserInfo" :@"UserInfoViewController"];
            [self.navigationController pushViewController:uivc animated:YES];
            break;
        case 1:
            vvc = [[VouchersThreeViewController alloc]init];
            [self.navigationController pushViewController:vvc animated:YES];
            break;
        case 2:
            mmvc = [board instantiateViewControllerWithIdentifier:@"MyMsgViewController"];
            [ self.navigationController pushViewController:mmvc animated:YES];
            break;
        case 3:
            clvc = [board instantiateViewControllerWithIdentifier:@"ComplaintViewController"];
            [ self.navigationController pushViewController:clvc animated:YES];
            break;
        case 4:
            cpvc = [[CommonProblemViewController alloc]init];
            [ self.navigationController pushViewController:cpvc animated:YES];
            break;
        default:
            break;
    }
}
//{
//    grzx =     {
//        countxcj = 0;
//        countxx = 3;
//        money = "9962.20";
//        uname = "";
//        upicture = "/Home/images/dpxq/pro_pic.png";
//    };
//    res = 1;
//}

-(void)loadData:(BOOL) isShowLoading{
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
     [[MayiHttpRequestManager sharedInstance] POST:UserCenter parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            DLog(@"%@",responseObject)
            NSDictionary *dir = [responseObject objectForKey:@"grzx"];
            NSString *countxcj =[dir objectForKey:@"countxcj"];
            NSString *countxx =[dir objectForKey:@"countxx"];
            NSString *money =(NSString*)[dir objectForKey:@"money"];
            NSString *uname =(NSString*)[dir objectForKey:@"uname"];
            NSString *upicture =(NSString*)[dir objectForKey:@"upicture"];
            if([countxcj integerValue]>0){
                voucherNum.hidden = NO;
            }else{
                 voucherNum.hidden = YES;
            }
            if([countxx integerValue]>0){
                msgNum.hidden = NO;
            }else{
                msgNum.hidden = YES;
            }
            if([@"" isEqualToString:uname]||uname==nil){
                uname = [GlobalVar sharedSingleton].uid ;
            }
            _userPhone.text = uname;
            [self setMoney:money];
            icon_url =[IMGURL stringByAppendingString:upicture];
//            [self performSelectorInBackground:@selector(download) withObject:nil];
        }
    } failture:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    }];

    
   }


-(void)download
{
    //1.根据URL下载图片
    //从网络中下载图片
    if (icon_url!=nil) {
        NSURL *urlstr=[NSURL URLWithString:icon_url];
        //把图片转换为二进制的数据
        NSData *data=[NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
        //把数据转换成图片
        UIImage *image=[UIImage imageWithData:data];
        if (image!=nil) {
            //2.回到主线程中设置图片
            [self performSelectorOnMainThread:@selector(settingImage:) withObject:image waitUntilDone:NO];
        }
       
    }

}



//设置显示图片
-(void)settingImage:(UIImage *)image
{
    self.userIcon.image=image;
}

@end
