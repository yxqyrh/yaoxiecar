//
//  ComplaintViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "ComplaintViewController.h"

#import "Constant.h"
#import "MayiHttpRequestManager.h"
@interface ComplaintViewController ()

@end

@implementation ComplaintViewController
- (IBAction)commit:(id)sender {
    
    [self commitContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    _complaintContent.delegate = self;
}
// 点击编辑框外面时，隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_complaintContent resignFirstResponder];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入你的宝贵意见和建议"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请输入你的宝贵意见和建议";
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)commitContent{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    // uid=18550031362  Isloginid=14435112502766
    //    [parameters setValue:[GlobalVar sharedSingleton].uid forKey:@"uid"];
    //    [parameters setValue:[GlobalVar sharedSingleton].isloginid forKey:@"isloginid"];
    if ([WDSystemUtils isEmptyOrNullString:_complaintContent.text]) {
        [self.view makeToast:@"内容不能为空"];
        return;
    }
    [parameters setValue:_complaintContent.text forKey:@"mes"];
    [[MayiHttpRequestManager sharedInstance] POST:Complaint parameters:parameters showLoadingView:self.view success:^(id responseObject) {
         NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
             [SVProgressHUD showSuccessWithStatus:@"谢谢你的建议！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failture:^(NSError *error) {
        
    }];
    
    
}

@end
