//
//  ScratchcardViewController.m
//  washcar
//
//  Created by CSB on 15/10/11.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "ScratchcardViewController.h"
#import <SVProgressHUD.h>
#import "MayiHttpRequestManager.h"

@interface ScratchcardViewController () {
    UITextField *_cardNumberTextField;
    UITextField *_cardCodeTextField;
}

@end

@implementation ScratchcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"刮刮卡充值";
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 55;
    }
    else if (indexPath.row == 1) {
        height = 55;
    }
    else {
        height = 40;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self commit];
    }
}

-(void)commit
{
    if ([WDSystemUtils isEmptyOrNullString:_cardNumberTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值卡卡号"];
        return;
    }
    if ([WDSystemUtils isEmptyOrNullString:_cardCodeTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值卡密码"];
        return;
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_cardNumberTextField.text forKey:@"oerderNumber"];
    [parameters setObject:_cardCodeTextField.text forKey:@"oerderPassword"];
    
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiGGKCZ parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showSuccessWithStatus:@"充值成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiUserCenterRefreshNotifiction object:nil userInfo:@{@"refreshIndex":@"1"}];
            return;
        }
        else if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"充值失败"];
            return ;
        }
        else if ([WDSystemUtils isEqualsInt:3 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"此卡已作废"];
            return ;
        }
        
    } failture:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"充值失败"];
    }];

}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = nil;
    switch (indexPath.row) {
        case 0:
            reuseIdentifier = @"CardNumberCell";
            break;
        case 1:
            reuseIdentifier = @"CardCodeCell";
            break;
        case 2:
            reuseIdentifier = @"CommitCell";
            break;
            
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.backgroundColor = GeneralBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1 || indexPath.row == 2) {
        UIView *view = (UIView *)[cell viewWithTag:1];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = GeneralLineCGColor;
        view.layer.cornerRadius = 5;
    }
    
    if (indexPath.row == 0) {
        _cardNumberTextField = (UITextField *)[cell viewWithTag:2];
    }
    
    if (indexPath.row == 1) {
        _cardCodeTextField = (UITextField *)[cell viewWithTag:2];
    }
    
    
    return cell;
    
}

@end
