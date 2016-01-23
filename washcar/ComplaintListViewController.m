//
//  ComplaintListViewController.m
//  washcar
//
//  Created by jingyaxie on 16/1/21.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import "ComplaintListViewController.h"
#import "MayiHttpRequestManager.h"
#import "StringUtil.h"
#import "DateUtil.h"
@interface ComplaintListViewController (){
    NSMutableArray *array;
}

@end

@implementation ComplaintListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.navigationItem.title = @"我的投诉建议";
    
    CGRect rightframe = CGRectMake(0,0,70,30);
    UIButton* rightButton= [[UIButton alloc] initWithFrame:rightframe];
//    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [rightButton setTitle:@"投诉建议" forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(goComplaintView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self  loadData:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self  loadData:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array==nil?0:array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"ComplaintListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = array[indexPath.row];
    UILabel *titleLabel =  (UILabel*)[cell viewWithTag:1];
    UILabel *timeLabel =  (UILabel*)[cell viewWithTag:2];
    UILabel *contentLabel =  (UILabel*)[cell viewWithTag:6];
    UIView *view1 = [cell viewWithTag:3];

    
    //    content.scrollEnabled = NO;
    titleLabel.text = [dic objectForKey:@"mes"];
    timeLabel.text = [dic objectForKey:@"time"];
    
    [titleLabel sizeToFit];
    
    
    
    [contentLabel sizeToFit];
    
    CGFloat height = 0;
    
    height +=  titleLabel.frame.size.height + contentLabel.frame.size.height + 40;
    DLog(@"height:%f",height);
    return height;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = array[indexPath.row];
    UILabel *titleLabel =  (UILabel*)[cell viewWithTag:1];
    UILabel *timeLabel =  (UILabel*)[cell viewWithTag:2];
    UIView *view2 = [cell viewWithTag:3];
    UILabel *contentLabel =  (UILabel*)[cell viewWithTag:6];

   
//    content.scrollEnabled = NO;
    titleLabel.text = [dic objectForKey:@"mes"];
    [titleLabel sizeToFit];
    timeLabel.text = [dic objectForKey:@"time"];
    
    NSString *str = [dic objectForKey:@"content"];
    if (str== nil||str.length == 0) {
        str = @"暂无回复";
    }
    contentLabel.text = str;
    [contentLabel sizeToFit];
    

//    view2.frame = CGRectMake(0, view2.frame.origin.y, SCREEN_WIDTH, size_content.height);
    
    
    

    
    
    UIView *body2 = [[UIView alloc]initWithFrame:CGRectMake(0, body1.frame.size.height, SCREEN_WIDTH, size_content.height+16+15)];
    body2.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 15, 15)];
    icon.image = [UIImage imageNamed:@"complaint_table_item_icon.png"];
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(26, 8, 100, 15)];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.text = @"掌柜回复";
    lable1.textColor =[UIColor grayColor];
    
    UILabel *content_text = [[UILabel alloc]initWithFrame:CGRectMake(26, 25, SCREEN_WIDTH-16, size_content.height)];
    content_text.textColor =[UIColor grayColor];
    content_text.font =font_content;
    content_text.text =content_str;
    [body2 addSubview:icon];
    [body2 addSubview:lable1];
    [body2 addSubview:content_text];
    UIView *body_all = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, body1.frame.size.height+body2.frame.size.height)];
    [body_all addSubview:body1];
    [body_all addSubview:body2];
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = body_all;
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
-(void)goComplaintView:(id)sender{
       UIStoryboard  *board = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
       UIViewController *clvc = [board instantiateViewControllerWithIdentifier:@"ComplaintViewController"];
        [ self.navigationController pushViewController:clvc animated:YES];
}


-(void)loadData:(BOOL) isShowLoading{
    
    UIView *loadingView;
    if (isShowLoading) {
        loadingView =self.view;
    }
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:TSList parameters:parameters showLoadingView:loadingView success:^(id responseObject) {
        
        if (responseObject == nil) {
            return ;
        }
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
          
            array =  [responseObject objectForKey:@"list"];
            [_tableView reloadData];
            
        }
    } failture:^(NSError *error) {
        //                [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
    
    
}

@end
