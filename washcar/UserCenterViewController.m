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
   
    [self initBtnLayout];
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
//            uivc = [StoryboadUtil getViewController:@"UserInfo" :@"UserInfoViewController"];
//            [self.navigationController pushViewController:uivc animated:YES];
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
-(void)initBtnLayout{
    [self initBtn:_btn1 :@"user_car_manager_icon" :_btn1.titleLabel.text];
    [self initBtn:_btn2 :@"user_coupon_icon" :_btn2.titleLabel.text];
    [self initBtn:_btn3 :@"user_invitation_icon" :_btn3.titleLabel.text];
    [self initBtn:_btn4 :@"user_msg_icon" :_btn4.titleLabel.text];
    [self initBtn:_btn5 :@"user_complaint_icon" :_btn5.titleLabel.text];
    [self initBtn:_btn6 :@"user_update_icon" :_btn6.titleLabel.text];
    [self initBtn:_btn7 :@"user_common_problem_icon" :_btn7.titleLabel.text];
    [self initBtn:_btn8 :@"user_exit_icon" :_btn8.titleLabel.text];
    float deviceNum = [StoryboadUtil getDeviceNum];
    
    int magin_bottom = 10;
    if (deviceNum == 4.0) {
        magin_bottom = 5;
    }
    if(deviceNum == 5.0){
        magin_bottom = 80;
    }
    if (deviceNum == 6.0) {
        magin_bottom = 100;
    }
    
    if (deviceNum == 6.5) {
        magin_bottom = 120;
    }

    [_btn8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnbody.mas_bottom).offset(-magin_bottom);
        //别的
    }];
}

-(void) initBtn:(UIButton*)btn:(NSString*)iconName :(NSString*)btnTitle{
    //UIImage *image =[self reSizeImage:[UIImage imageNamed:iconName] toSize:CGSizeMake(40, 40)];
   UIImage *image =[UIImage imageNamed:iconName] ;
    NSString *title = btnTitle;
    [btn setTitle:title forState:UIControlStateNormal];

    [btn setImage:image forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + 5);
    
    // raise the image and push it right to center it
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    
    [[btn layer]setCornerRadius:8.0];
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

- (IBAction)btn1Click:(id)sender {
    
   CarManagerViewController *uivc = [StoryboadUtil getViewController:@"InvitationCode" :@"CarManagerViewController"];
    [self.navigationController pushViewController:uivc animated:YES];
}
- (IBAction)btn2Click:(id)sender {
    vvc = [[VouchersThreeViewController alloc]init];
    [self.navigationController pushViewController:vvc animated:YES];
}
- (IBAction)btn3Click:(id)sender {
    
    InvitationCodeViewController *invitationCode =[StoryboadUtil getViewController:@"InvitationCode" :@"InvitationCodeViewController"];
    [self.navigationController pushViewController:invitationCode animated:YES];
}

- (IBAction)btn4Click:(id)sender {
    mmvc = [board instantiateViewControllerWithIdentifier:@"MyMsgViewController"];
    [ self.navigationController pushViewController:mmvc animated:YES];
}

- (IBAction)btn5Click:(id)sender {
    clvc = [board instantiateViewControllerWithIdentifier:@"ComplaintViewController"];
    [ self.navigationController pushViewController:clvc animated:YES];
}

- (IBAction)btn6Click:(id)sender {
}

- (IBAction)btn7Click:(id)sender {
    cpvc = [[CommonProblemViewController alloc]init];
    [ self.navigationController pushViewController:cpvc animated:YES];
}
- (IBAction)btn8Click:(id)sender {
    
    [self exitMayi];
}
//Res   1 退出成功  2退出失败
-(void) exitMayi{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:Quitlogin parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功！"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MayiUserIsSignIn];
            
            [GlobalVar sharedSingleton].uid = nil;
            
            [GlobalVar sharedSingleton].isloginid = nil;
            [GlobalVar sharedSingleton].signState = MayiSignStateUnSigned;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiIndexPageNotifiction object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
            //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sign" bundle:nil];
            //            UIViewController *loginViewController = [storyboard instantiateInitialViewController];
            //            loginViewController.modalTransitionStyle = UIModalPresentationFormSheet;//跳转效果
            //            [self presentModalViewController:loginViewController animated:YES];//在这里一跳就行了。
            //
            //            //[self dismissModalViewControllerAnimated:YES];
            //            [self removeFromParentViewController];
        }else{
            [SVProgressHUD showErrorWithStatus:@"退出失败！"];
        }
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败！"];
    }];
    
}

@end
