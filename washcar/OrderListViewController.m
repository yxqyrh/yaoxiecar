//
//  OrderListViewController.m
//  washcar
//
//  Created by CSB on 15/9/27.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "OrderListViewController.h"
#import "MayiHttpRequestManager.h"
#import "OrderInfo.h"
#import "LocationInfo.h"
#import "StringUtil.h"
#import "NIAttributedLabel.h"
 #import <UIImageView+WebCache.h>

@interface OrderListViewController () {
    int _selectIndex;
    NSMutableArray *_orders;
    
    int _pageIndex;
    
    bool _mutexFlag;

    NSString *_startIndex;
    
    NSArray *_selectOrderPictures;
}

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectIndex = -1;
    _pageIndex = 1;
    self.view.backgroundColor = GeneralBackgroundColor;
    
    
    _orders = [NSMutableArray array];
    
    NSString *method = nil;
    if (_pageType == 1) {
        method = MayiRunningOrder;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:MayiOrderNotifiction object:nil];
    }
    else if (_pageType == 2) {
        method = MayiFinishedOrder;
    }
    else if (_pageType == 3) {
        method = MayiCanceledOrder;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:MayiOrderCanceledNotifiction object:nil];
    }
    [self loadOrderList:method andPageIndex:_pageIndex];
    
    self.tableView.backgroundColor = GeneralBackgroundColor;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


-(void)viewWillAppear:(BOOL)animated{

    
    self.parentViewController.title = @"个人中心";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
    NSString *method = nil;
    if (_pageType == 1) {
        method = MayiRunningOrder;
    }
    else if (_pageType == 2) {
        method = MayiFinishedOrder;
    }
    else if (_pageType == 3) {
        method = MayiCanceledOrder;
    }
    _pageIndex = 1;

    [self loadOrderList:method andPageIndex:_pageIndex];
}

- (void)footerRereshing {
        
        
        NSString *method = nil;
        if (_pageType == 1) {
            method = MayiRunningOrder;
        }
        else if (_pageType == 2) {
            method = MayiFinishedOrder;
        }
        else if (_pageType == 3) {
            method = MayiCanceledOrder;
        }
        
        [self loadOrderList:method andPageIndex:_pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadOrderList:(NSString *)method andPageIndex:(int)pageIndex
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:[GlobalVar sharedSingleton].uid forKey:@"uid"];
    [parameters setValue:@(pageIndex) forKey:@"page"];
    
    [[MayiHttpRequestManager sharedInstance] POST:method parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        
        DLog(@"responseObject:%@",responseObject);
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            if ([[responseObject objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [OrderInfo objectArrayWithKeyValuesArray: [responseObject objectForKey:@"list"]];
                if (_pageIndex == 1) {
                    [_orders removeAllObjects];
                }
                else {
                    
                }
                
                for (OrderInfo *order in array) {
                    if (![_orders containsObject:order]) {
                        [_orders addObject:order];
                    }
                }
                
                if (array != nil && array.count == 10) {
                    _pageIndex++;
                }
                
                if (_orders.count >= 10) {
                    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
                }
                
//                [_orders addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        [self.tableView.header endRefreshing];
         [self.tableView.footer endRefreshing];
        
    } failture:^(NSError *error) {
        [self.view makeToast:@"注册失败"];
    }];
}

- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
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
    if (indexPath.row == _selectIndex) {
        if (_pageType == 1) {
            return 300;
        }
        else if (_pageType == 3) {
            return 270;
        }
        else if (_pageType == 2) {
            OrderInfo *order = [_orders objectAtIndex:indexPath.row];
            NSArray *array = order.xc_pictures;
            if (array == nil || array.count == 0 ) {
                return 265;
            }
            else if (array.count <= 3){
                return 350;
            }
            else {
                return 450;
            }
        }
    }
    
    return 54;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == indexPath.row) {
        _selectIndex = -1;
        [self.tableView reloadData];
    }
    else {
        _selectIndex = indexPath.row;
        
        OrderInfo *orderInfo = [_orders objectAtIndex:_selectIndex];
        _selectOrderPictures = [orderInfo xc_pictures];
        
        
        [self.tableView reloadData];
    }
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = nil;
//    switch (indexPath.row) {
//        case 0:
//            reuseIdentifier = @"OrderDetailCell";
//            break;
//        case 1:
//            reuseIdentifier = @"OrderInfoCell";
//            break;
//
//    }
    
    if (_selectIndex == indexPath.row) {
//        reuseIdentifier =  @"OrderDetailCell";
        if (_pageType == 1) {
            reuseIdentifier =  @"OrderDetailCell";
        }
        else if (_pageType == 2) {
            reuseIdentifier =  @"OrderFinishedCell";
        }
        else if (_pageType == 3) {
            reuseIdentifier =  @"OrderCancelCell";
        }
    }
    else {
        reuseIdentifier = @"OrderInfoCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.backgroundColor = GeneralBackgroundColor;
    
    UIView *view = [cell viewWithTag:1];
    view.layer.borderColor = GeneralLineCGColor;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 0.5;
    
    UIView *line = [cell  viewWithTag:12];
    CGRect frame = line.frame;
    frame.size.height = 0.3f;
    line.frame = frame;
    line.layer.backgroundColor = GeneralLineCGColor;
    
    OrderInfo *order = [_orders objectAtIndex:indexPath.row];
    if (_selectIndex != indexPath.row) {
        UILabel *labelName = (UILabel *)[cell viewWithTag:2];
        labelName.text = order.num;
    }
    else {
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:2];
        numberLabel.text = order.num;
        
        NIAttributedLabel *priceLabel = (NIAttributedLabel *)[cell viewWithTag:3];
        NSString *text = [NSString stringWithFormat:@"%@元",order.methodsval];
        NSRange range = [text rangeOfString:order.methodsval];
        priceLabel.text = text;
        [priceLabel setTextColor:menoyTextColor range:range];
        
        UILabel *washTypeLabel = (UILabel *)[cell viewWithTag:4];
        washTypeLabel.text = order.methods;
//        if ([@"1" isEqualToString:order.methods]) {
//            washTypeLabel.text = @"车身清洗";
//        }
//        else if ([@"2" isEqualToString:order.methods]){
//            washTypeLabel.text = @"内外全洗";
//        }
        
        UILabel *addressLabel = (UILabel *)[cell viewWithTag:5];
        addressLabel.text = order.szdqstr;
        
        UILabel *workerNumberLabel = (UILabel *)[cell viewWithTag:6];
        workerNumberLabel.text = order.guser;
        
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:7];
        timeLabel.text = [WDSystemUtils getDateString:order.numtime];
        
        
        if (_pageType == 1) {
            UILabel *descLabel = (UILabel *)[cell viewWithTag:8];
            descLabel.text = order.remark;
            
            UIButton *cancelButton = (UIButton *)[cell viewWithTag:9];
            cancelButton.hidden = NO;
            cancelButton.layer.cornerRadius = 3;
            if ([@"0" isEqualToString:order.judge_zt]) {
                [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                cancelButton.userInteractionEnabled = YES;
            }
            else if ([@"1" isEqualToString:order.judge_zt]) {
                
            }
            else if ([@"2" isEqualToString:order.judge_zt]) {
                [cancelButton setTitle:@"正在洗车中..." forState:UIControlStateNormal];
                cancelButton.userInteractionEnabled = NO;
            }
            
            [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if (_pageType == 2) {
            UICollectionView *collectionView = (UICollectionView *)[cell viewWithTag:11];
            NSArray *array = order.xc_pictures;
            if (array == nil || array.count == 0) {
                collectionView.hidden = YES;
            }
            else {
                collectionView.delegate = self;
                collectionView.dataSource = self;
                [collectionView reloadData];
            }
            
            
        }
        else if (_pageType == 3) {            
            UILabel *cancelReasonLabel = (UILabel *)[cell viewWithTag:10];
            cancelReasonLabel.hidden = NO;
            cancelReasonLabel.text = order.unsubscribe;
        }
    }
    
    
    return cell;

}



-(IBAction)cancelButtonClicked:(id)sender
{
    DLog(@"clicked");
    
    CancelChoosePop *view = [CancelChoosePop defaultPopupView];
    view.parentVC = self;
    view.delegate = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        
    }];
    
//    [self complete:@"下错单了" andSubscribe2:@""];
    
    return;
}

#pragma mark CancelChoosePopDelegate
- (void)complete:(NSString *)unsubscribe1 andSubscribe2:(NSString *)unsubscribe2
{
    OrderInfo *order = [_orders objectAtIndex:_selectIndex];

    DLog(@"unsubscribe1:%@,unsubscribe2:%@", unsubscribe1, unsubscribe2);
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:order.id forKey:@"id"];
    [parameters setValue:unsubscribe1 forKey:@"unsubscribe1"];
    [parameters setValue:unsubscribe2 forKey:@"unsubscribe2"];
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiQXDD parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        
        DLog(@"responseObject:%@",responseObject);
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            int temp = _selectIndex;
            [_orders removeObjectAtIndex:_selectIndex];
            _selectIndex = -1;
            
            [self.tableView reloadData];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:temp inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:temp inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MayiOrderCanceledNotifiction object:nil];
        }

        
    } failture:^(NSError *error) {
        [self.view makeToast:@"取消失败"];
    }];
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectOrderPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imagePath = [_selectOrderPictures objectAtIndex:indexPath.row];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",IMGURL, imagePath]]];
    return cell;
}

#pragma mark UICollectionViewDelegate

@end
