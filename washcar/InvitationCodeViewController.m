//
//  InvitationCodeViewController.m
//  washcar
//
//  Created by jingyaxie on 16/1/8.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import "InvitationCodeViewController.h"

@interface InvitationCodeViewController (){
    Share *share;
}



@end

@implementation InvitationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"邀请码";
    share = [Share defaultPopupView];
       [self.view addSubview:share];
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
    
   
    [share showView];
  
}

@end
