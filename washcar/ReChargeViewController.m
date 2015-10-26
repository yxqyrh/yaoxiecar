//
//  ReChargeViewController.m
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//



#import "ReChargeViewController.h"
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MayiHttpRequestManager.h"
#import "UserInfo.h"
#import "NIAttributedLabel.h"

#import "WXApi.h"
#import "payRequsestHandler.h"


@interface ReChargeViewController () {
    //1 为 支付宝支付  2为微信支付 4未充值卡
    int _payType;
    NSString *_sc;
    NSString *_accountLeft;
}

@end

@implementation ReChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值中心";
    
    _payType = 1;
    _accountLeft = @"0.00";
    _checkInMoney = 100;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:MayiPaySuccess object:nil];
    
    [self loadData];
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

//从网上加载数据
-(void)loadData{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:MayiCZZX parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            _accountLeft = [responseObject objectForKey:@"money"];
            _sc = [responseObject objectForKey:@"sc"];
            
            if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"sc"]]) {
                _checkInMoney = 50;
            }
            else {
                _checkInMoney = 100;
            }
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
    } failture:^(NSError *error) {
        
    }];
}

-(void)paySuccess
{
    [SVProgressHUD showSuccessWithStatus:@"充值成功"];
    [self loadData];
}



- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    
    return result;
}

-(void)czzxtj
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(_checkInMoney) forKey:@"value"];
    [parameters setValue:@(_payType) forKey:@"type"];
    [[MayiHttpRequestManager sharedInstance] POST:MayiCZZXTJ parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
        
            
            if (_payType == 1) {
            //
            [self runAliPayWithTitle:[responseObject objectForKey:@"name"] andDesc:[responseObject objectForKey:@"description"] andOrderNumber:[responseObject objectForKey:@"num"] andPrice:[responseObject objectForKey:@"value"] andNotifyURL:[responseObject objectForKey:@"notifyURL"] completionBlock:^(NSDictionary *resultDic) {
                
            }];
            }
            else if (_payType == 2) {
//                [self sendPayWXWithName:@"蚂蚁洗车充值" orderNumber:[responseObject objectForKey:@"num"] andPrice:@"0.02"];
                
                [self newPay:[responseObject objectForKey:@"num"]];
            }

        }

        
    } failture:^(NSError *error) {
        
    }];
}

- (void)runAliPayWithTitle:(NSString *)title
                   andDesc:(NSString *)desc
            andOrderNumber:(NSString *)orderNum
                  andPrice:(NSString *)price
              andNotifyURL:(NSString *)url
           completionBlock:(CompletionBlock)completionBlock
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = orderNum; //订单ID（由商家自行制定）
    order.productName = title; //商品标题
    order.productDescription = desc; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",price]; //商品价格
    order.notifyURL =  url; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"washcar";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;

    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:completionBlock];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            DLog(@"result :%@", resultDic);
            if ([WDSystemUtils isEqualsInt:9000 andJsonData:[resultDic objectForKey:@"resultStatus"]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MayiPaySuccess object:nil userInfo:resultDic];
            }
            
        }];
    }
}

//============================================================
// V3&V4支付流程实现
// 注意:参数配置请查看服务器端Demo
// 更新时间：2015年3月3日
// 负责人：李启波（marcyli）
//============================================================
- (void)sendPayWXWithName:(NSString *)orderName orderNumber:(NSString *)orderNumber andPrice:(NSString *)orderPrice
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    CGFloat price = [orderPrice floatValue];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderName andOrderNumber:orderNumber  andOrderPrice:price];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        [SVProgressHUD showErrorWithStatus:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = orderNumber;
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

-(void)newPay:(NSString *)repayId
{
//    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
//
//    NSMutableDictionary *dict = [req sendPay_demo:orderName andOrderNumber:orderNumber  andOrderPrice:price];
    
    
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [WXUtil md5:time_stamp];
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    //package       = [NSString stringWithFormat:@"Sign=%@",package];
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: APP_ID        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: MCH_ID        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: repayId     forKey:@"prepayid"];
    //[signParams setObject: @"MD5"       forKey:@"signType"];
    //生成签名
    NSString *sign  = [req createMd5Sign:signParams];
    
    PayReq* req1             = [[PayReq alloc] init];
    req1.openID              = APP_ID;
    req1.partnerId           = MCH_ID;
    req1.prepayId            = repayId;
    req1.nonceStr            = nonce_str;
    req1.timeStamp           = time_stamp.intValue;
    req1.package             = package;
    req1.sign                = sign;
    
    bool startWXSuccess = [WXApi sendReq:req1];
    if (!startWXSuccess) {
        [SVProgressHUD showErrorWithStatus:@"未安装微信"];
        return;
    }
    
}

#pragma mark - RechargeAmountPopDelegate
- (void)setRechargeValue:(int)value
{
    _checkInMoney = value;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        RechargeAmountPop *view = [RechargeAmountPop defaultPopupView];
        if ([WDSystemUtils isEqualsInt:1 andJsonData:_sc]) {
            view.isSC = YES;
        }
        else {
            view.isSC = NO;
        }
        view.prevSelectMoney = _checkInMoney;
        view.parentVC = self;
        view.delegate = self;
        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            
        }];
    }
    
    if (indexPath.row == 3) {
        _payType = 1;
        [self.tableView reloadData];
    }
    
    if (indexPath.row == 4) {
        _payType = 2;
        [self.tableView reloadData];
    }
//    else if (indexPath.row == 3) {
//        _payType = 2;
//        [self.tableView reloadData];
//    }
    
    if (indexPath.row == 5) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ScratchcardViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (indexPath.row == 6) {
        
        [self czzxtj];
        return;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row < 3) {
        switch (indexPath.row) {
            case 0:
                height = 50;
                break;
            case 1:
                height = 50;
                break;
            case 2:
                height = 50;
                break;
            default:
                break;
        }
    }
    else if (indexPath.row == 6) {
        height = 50;
    }
    else {
        height = 60;
    }
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4 + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = nil;
    if (indexPath.row < 3) {
        switch (indexPath.row) {
            case 0:
                reuseIdentifier = @"RemainerCell";
                break;
            case 1:
                reuseIdentifier = @"PayNumberCell";
                break;
            case 2:
                reuseIdentifier = @"PayTypeTitleCell";
                break;

        }
    }
    else if (indexPath.row == 6) {
         reuseIdentifier = @"CommitCell";
    }
    else {
        reuseIdentifier = @"PayTypeCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.backgroundColor = GeneralBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        NIAttributedLabel *remainerLabel = (NIAttributedLabel *)[cell viewWithTag:1];
        NSString *text = [NSString stringWithFormat:@"%@元", _accountLeft];
        NSRange range = [text rangeOfString:_accountLeft];
        remainerLabel.text = text;
        [remainerLabel setTextColor:menoyTextColor range:range];
    }
    
    if (indexPath.row == 1) {
        UIView *view = (UIView *)[cell viewWithTag:1];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = GeneralLineCGColor;
        
        UILabel *checkInLabel = (UILabel *)[cell viewWithTag:2];
        checkInLabel.text = [NSString stringWithFormat:@"%.2f元", _checkInMoney];
    }
    
    if (indexPath.row == 3) {
        UIImageView *imageViewIcon = [(UIImageView *)cell viewWithTag:1];
        imageViewIcon.image = [UIImage imageNamed:@"img_zhifubao"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = @"支付宝支付";
        
        UILabel *descLabel = (UILabel *)[cell viewWithTag:3];
        descLabel.text = @"支付宝安全支付";
        
        UIImageView *imageViewCheck = [(UIImageView *)cell viewWithTag:4];
        
        if (_payType == 1) {
            imageViewCheck.image = [UIImage imageNamed:@"img_checked"];
        }
        else {
            imageViewCheck.image = [UIImage imageNamed:@"img_unchecked"];
        }
        
    }
    

    if (indexPath.row == 4) {
        UIImageView *imageViewIcon = [(UIImageView *)cell viewWithTag:1];
        imageViewIcon.image = [UIImage imageNamed:@"img_weixin"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = @"微信支付";
        
        UILabel *descLabel = (UILabel *)[cell viewWithTag:3];
        descLabel.text = @"微信宝安全支付";
        
        UIImageView *imageViewCheck = [(UIImageView *)cell viewWithTag:4];
        
        if (_payType == 2) {
            imageViewCheck.image = [UIImage imageNamed:@"img_checked"];
        }
        else {
            imageViewCheck.image = [UIImage imageNamed:@"img_unchecked"];
        }
        
    }
    
    if (indexPath.row == 5) {
        UIImageView *imageViewIcon = [(UIImageView *)cell viewWithTag:1];
        imageViewIcon.image = [UIImage imageNamed:@"img_guagua"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = @"刮刮卡充值";
        
        UILabel *descLabel = (UILabel *)[cell viewWithTag:3];
        descLabel.text = @"刮刮卡安全充值";
        
        UIImageView *imageViewCheck = [(UIImageView *)cell viewWithTag:4];
        
        imageViewCheck.image = [UIImage imageNamed:@"img_arrow"];
        
        
    }
    
    return cell;
}

@end
