//
//  PayTableViewController.m
//  washcar
//
//  Created by CSB on 15/9/26.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "PayTableViewController.h"
#import "MayiHttpRequestManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "StringUtil.h"
#import "NIAttributedLabel.h"

@interface PayTableViewController () {
    int _payType;
    bool _isPaying;
}

@end

@implementation PayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _payType = 2;
    self.title = @"选择支付方式";
    _isPaying = false;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:MayiPaySuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        _payType = 1;
        [self.tableView reloadData];
    }
//    else if (indexPath.row == 2) {
//        _payType = 3;
//        [self.tableView reloadData];
//    }
    else if (indexPath.row == 2) {
        _payType = 2;
        [self.tableView reloadData];
    }
    
    if (indexPath.row == 3) {
        DLog(@"支付");
        [self payOrder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 40;
    }
    else if (indexPath.row == 3) {
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
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = nil;
    if (indexPath.row == 0) {
        reuseIdentifier = @"RemainerCell";
    }
    else if (indexPath.row == 3) {
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
//        remainerLabel.text = [NSString stringWithFormat:@"%@元", _payValue];
        NSString *text = [NSString stringWithFormat:@"%@元", _payValue];
        NSRange range = [text rangeOfString:_payValue];
        remainerLabel.text = text;
        [remainerLabel setTextColor:menoyTextColor range:range];
        
    }
    
    
    if (indexPath.row == 1) {
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
//    if (indexPath.row == 2) {
//        UIImageView *imageViewIcon = [(UIImageView *)cell viewWithTag:1];
//        imageViewIcon.image = [UIImage imageNamed:@"img_weixin"];
//        
//        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
//        titleLabel.text = @"微信支付";
//        
//        UILabel *descLabel = (UILabel *)[cell viewWithTag:3];
//        descLabel.text = @"微信宝安全支付";
//        
//        UIImageView *imageViewCheck = [(UIImageView *)cell viewWithTag:4];
//        
//        if (_payType == 3) {
//            imageViewCheck.image = [UIImage imageNamed:@"img_checked"];
//        }
//        else {
//            imageViewCheck.image = [UIImage imageNamed:@"img_unchecked"];
//        }
//        
//    }
    
    if (indexPath.row == 2) {
        UIImageView *imageViewIcon = [(UIImageView *)cell viewWithTag:1];
        imageViewIcon.image = [UIImage imageNamed:@"img_yue"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = @"余额支付";
        
        UILabel *descLabel = (UILabel *)[cell viewWithTag:3];
//        descLabel.text = [NSString stringWithFormat:@"当前余额 %@元", _accountBalance];
        descLabel.attributedText = [StringUtil getMenoyText:@"当前余额  ":_accountBalance :@"元"];
        UIImageView *imageViewCheck = [(UIImageView *)cell viewWithTag:4];
        if (_payType == 2) {
            imageViewCheck.image = [UIImage imageNamed:@"img_checked"];
        }
        else {
            imageViewCheck.image = [UIImage imageNamed:@"img_unchecked"];
        }
        
    }
    

    
    return cell;
}

-(void)paySuccess
{
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MayiOrderNotifiction object:nil userInfo:[NSDictionary dictionaryWithObject:@1 forKey:MayiOrderNotifictionPageType]];
    _isPaying = false;
}

-(void)payOrder
{
    if (_isPaying == true) {
        return;
    }
    _isPaying = true;
    [_washParameters setObject:@(_payType) forKey:@"type"];
    [[MayiHttpRequestManager sharedInstance] POST:MayiWYXCing parameters:_washParameters showLoadingView:self.view success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            _isPaying = false;
            return ;
        }
        else if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
//[responseObject objectForKey:@"zfje"]
            if (_payType == 1) {
                [self runAliPayWithTitle:[responseObject objectForKey:@"name"] andDesc:[responseObject objectForKey:@"description"] andOrderNumber:[responseObject objectForKey:@"num"] andPrice:@0.01 andNotifyURL:[responseObject objectForKey:@"notifyURL"] completionBlock:^(NSDictionary *resultDic) {
                }];
            }
            else if (_payType == 2) {
                [self payWithBalance:[responseObject objectForKey:@"num"] andValue:[responseObject objectForKey:@"zfje"]];
            }
            return ;
        }
        else if ([WDSystemUtils isEqualsInt:4 andJsonData:[responseObject objectForKey:@"res"]]) {
            [self.view makeToast:[responseObject objectForKey:@"ts"]];
            return ;
        }
        
    } failture:^(NSError *error) {
        _isPaying = false;
        [self.view makeToast:@"操作失败"];
    }];
    

}



//余额支付
-(void)payWithBalance:(NSString *)orderNumber andValue:(NSString *)money
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:orderNumber forKey:@"id"];
    [parameters setValue:money forKey:@"money"];
//json:{
//    res = 4;
//    ts = "\U54ce\U5466\Uff01\U5c0f\U8682\U8681\U56de\U7a9d\U5566\Uff0c\U660e\U59299\Uff1a00-18\Uff1a00\U4e0d\U89c1\U4e0d\U6563\U54df\Uff01";
//}
    [[MayiHttpRequestManager sharedInstance] POST:MayiYEZF parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        DLog(@"ts=%@res=%@",[responseObject objectForKey:@"ts"],[responseObject objectForKey:@"res"]);
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"余额不足"];
            _isPaying = false;
            return ;
        }
        else if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            _isPaying = false;
            return ;
        }
   
        else if ([WDSystemUtils isEqualsInt:3 andJsonData:[responseObject objectForKey:@"res"]]) {
            [self paySuccess];
            return ;
            
        }
     
        
        
    } failture:^(NSError *error) {
        _isPaying = false;
        [self.view makeToast:@"支付失败"];
    }];
}

//支付宝支付
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


@end
