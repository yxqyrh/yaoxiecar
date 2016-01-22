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
#import "MDPhotoAlbumViewController.h"
#import <Masonry.h>
#import "PSTAlertController.h"
#import "MyTableViewCell.h"

@interface OrderListViewController () {
    int _selectIndex;
    NSMutableArray *_orders;
    
    int _pageIndex;
    
    bool _mutexFlag;

    NSString *_startIndex;
    
    NSArray *_selectOrderPictures;
    NSMutableArray *_imageViews;
    
    bool _testFlag;
}


@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _testFlag = false;
    _selectIndex = -1;
    _pageIndex = 1;
    self.view.backgroundColor = GeneralBackgroundColor;
    
    
    _orders = [NSMutableArray array];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:MayiOrderNotifiction object:nil];
    
    [self loadOrderList:method andPageIndex:_pageIndex];
    
    self.tableView.backgroundColor = GeneralBackgroundColor;
    
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
       self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    if (_pageIndex != 1) {
        UILongPressGestureRecognizer *longPressGestrureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [longPressGestrureRecognizer addTarget:self action:@selector(longPressCell:)];
        [self.tableView addGestureRecognizer:longPressGestrureRecognizer];
    }
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

-(void)initTestData
{
    _orders = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        OrderInfo *order = [[OrderInfo alloc] init];
        order.num = @"msad123321321312";
//        order.remark = @"remarkasdsadwqewqewqewqewqewqeqwewqeqwewqewqewqewqewqasdasdasdasdasdasdasdasdasdsadasd";
        order.bz = @"备注bsadddwqewqeqweqweqweqweqweqweqweqweqweqwewqewqeqwe";
        order.unsubscribe = @"取消原因阿斯顿全文我去恶趣味全文了气温可领取为了钱为了钱为了；情未了；情未了；蔷薇科录取为了去问了sadwqewqewqewqewq";
        order.methods = @"车内清洗";
        order.xc_picture = @"1|2|3|4";
        order.methodsval = @"18.90";
        [_orders addObject:order];
    }
    [self.tableView reloadData];
    
}

-(void)refreshData:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    if ([[dic objectForKey:MayiOrderNotifictionPageType] intValue] == _pageType) {
        [self headerRereshing];
    }
}


-(void)viewWillAppear:(BOOL)animated{

    
//    self.parentViewController.title = @"个人中心";
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
//    [self initTestData];
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
                    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//                    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
                }
                
//                [_orders addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        [self.tableView.header endRefreshing];
         [self.tableView.footer endRefreshing];
        
    } failture:^(NSError *error) {
        [self.view makeToast:@"获取失败"];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == _selectIndex) {
//        if (_pageType == 1) {
//            return 330;
//        }
//        else if (_pageType == 3) {
//            return 320;
//        }
//        else if (_pageType == 2) {
//            OrderInfo *order = [_orders objectAtIndex:indexPath.row];
//            NSArray *array = order.xc_pictures;
//            if (array == nil || array.count == 0 ) {
//                return 265;
//            }
//            else if (array.count <= 3){
//                return 410;
//            }
//            else {
//                return 480;
//            }
//        }
//    }
//    
//    return 54;
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Retrieve our object to give to our size manager.
//    id object = [self.dataArray objectAtIndex:indexPath.row];
//    
//    // Since we are using a tableView we are using the cellHeightForObject:indexPath: method.
//    //  It uses the indexPath as the key for cacheing so it is important to pass in the correct one.
//    return [self.sizeManager cellHeightForObject:object indexPath:indexPath];
//}

// If you have very complex cells or a large number implementing this method speeds up initial load time.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectIndex) {
        NSString *cellResueIdentifies = nil;
        if (_pageType == 1) {
            cellResueIdentifies = @"OrderDetailCell";
        }
        else if (_pageType == 2) {
            cellResueIdentifies = @"OrderFinishedCell";
        }
        else if (_pageType == 3) {
            cellResueIdentifies = @"OrderCancelCell";
        }
        UITableViewCell *cell = [self.offScreenCells objectForKey:cellResueIdentifies];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellResueIdentifies];
            [self.offScreenCells setObject:cell forKey:cellResueIdentifies];
        }
        
        OrderInfo *order = [_orders objectAtIndex:indexPath.row];
        UILabel *descLabel = (UILabel *)[cell viewWithTag:9];
        descLabel.text = order.remark;
        [descLabel sizeToFit];
        
         CGSize descLabelSize = [descLabel sizeThatFits:CGSizeMake(descLabel.frame.size.width, MAXFLOAT)];
        
        //    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        //
        //    [cell setNeedsLayout];
        //    [cell layoutIfNeeded];
        CGSize cancelReasonLabelSize = CGSizeZero;
        CGFloat imageCollectionViewHeight = 0.f;
        if (_pageType == 3) {
            NIAttributedLabel *cancelReasonLabel = (NIAttributedLabel *)[cell viewWithTag:10];
            cancelReasonLabel.text = order.unsubscribe;
            cancelReasonLabel.textAlignment = NSTextAlignmentLeft;
            cancelReasonLabel.lineHeight = 15;
            [cancelReasonLabel sizeToFit];
            cancelReasonLabelSize = [cancelReasonLabel sizeThatFits:CGSizeMake(cancelReasonLabel.frame.size.width, MAXFLOAT)];
        }
        else if (_pageType == 2) {
            OrderInfo *order = [_orders objectAtIndex:indexPath.row];
                        NSArray *array = order.xc_pictures;
                        if (array == nil || array.count == 0 ) {
            
                        }
                        else if (array.count <= 3){
                            imageCollectionViewHeight = 90 + 10;
                        }
                        else {
                            imageCollectionViewHeight = 190 + 10;
                        }
        }
        
        
        
       
       
       
        
        UIView *bgView = [cell viewWithTag:1];
        
        [bgView setNeedsUpdateConstraints];
        [bgView updateConstraintsIfNeeded];
        
        CGSize size =  [bgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
       
        
        CGFloat height = size.height + 1 + (descLabelSize.height < 20 ? 35 : descLabelSize.height);
        if (_pageType == 3) {
            height += cancelReasonLabelSize.height < 20 ? 25 : cancelReasonLabelSize.height;
        }
        else if (_pageType == 2) {
            height += imageCollectionViewHeight;
        }
        
        if (_pageType == 1) {
            height += 35;
        }
        
         DLog(@"height:%f", height);
        height += 10;
        return height;
    }
    else {
        return 54;
    }
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
    
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = GeneralBackgroundColor;
    
   
    
    UIView *bgView = [cell viewWithTag:1];
    bgView.layer.borderColor = GeneralLineCGColor;
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderWidth = 0.5;
    
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
        
        UILabel *cwhLabel = (UILabel *)[cell viewWithTag:51];
        cwhLabel.text = order.cwh;
        
        UILabel *workerNumberLabel = (UILabel *)[cell viewWithTag:6];
        workerNumberLabel.text = order.guser;
        
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:7];
        timeLabel.text = [WDSystemUtils getDateString:order.numtime];
        
        UILabel *descLabel = (UILabel *)[cell viewWithTag:9];
        descLabel.text = order.remark;
        [descLabel sizeToFit];
        if (_pageType == 1) {
            UIButton *cancelButton = (UIButton *)[cell viewWithTag:21];
            cancelButton.hidden = NO;
            cancelButton.layer.cornerRadius = 3;
            if ([@"0" isEqualToString:order.judge_zt]) {
                [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                cancelButton.backgroundColor = RGBCOLOR(73, 180, 252);
                cancelButton.userInteractionEnabled = YES;
            }
            else if ([@"1" isEqualToString:order.judge_zt]) {
                [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                cancelButton.backgroundColor = RGBCOLOR(73, 180, 252);
                cancelButton.userInteractionEnabled = YES;
            }
            else if ([@"2" isEqualToString:order.judge_zt]) {
                [cancelButton setTitle:@"正在洗车中..." forState:UIControlStateNormal];
                cancelButton.userInteractionEnabled = NO;
                cancelButton.backgroundColor = [UIColor lightGrayColor];
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
            
            UILabel *xctimeLabel = (UILabel *)[cell viewWithTag:8];
            xctimeLabel.text = [WDSystemUtils getDateString:order.xctime];
            
            UILabel *descLabel = (UILabel *)[cell viewWithTag:9];
            descLabel.text = order.bz;
            [descLabel sizeToFit];
            
            if (_testFlag) {
                collectionView.delegate = self;
                collectionView.dataSource = self;
                [collectionView reloadData];
            }
            
            if (![WDSystemUtils isEqualsInt:0 andJsonData:order.pj]) {
                UIButton *button = [cell viewWithTag:35];
                button.userInteractionEnabled = NO;
                button.backgroundColor = [UIColor lightGrayColor];
                [button setTitle:@"已评价" forState:UIControlStateNormal];
            }
            else {
                UIButton *button = [cell viewWithTag:35];
                button.backgroundColor = RGBCOLOR(73, 180, 252);
                button.userInteractionEnabled = YES;
                [button setTitle:@"评价订单" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(evaluateWashWorkers:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        else if (_pageType == 3) {            
            if (![WDSystemUtils isEmptyOrNullString:order.unsubscribe]) {
                NIAttributedLabel *cancelReasonLabel = (NIAttributedLabel *)[cell viewWithTag:10];
                cancelReasonLabel.lineHeight = 15;
                cancelReasonLabel.textAlignment = NSTextAlignmentLeft;
                cancelReasonLabel.text = order.unsubscribe;
                [cancelReasonLabel sizeToFit];
            }
            
            if ([WDSystemUtils isEmptyOrNullString:order.remark]) {
                
                UILabel *remarkTitleLabel = (UILabel *)[cell viewWithTag:31];
                UILabel *cancelReasonTitleLabel = (UILabel *)[cell viewWithTag:32];
                
  
                if ([WDSystemUtils isEmptyOrNullString:order.unsubscribe]) {
                    [cancelReasonTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                        make.leading.equalTo(bgView.mas_leading).with.offset(10);
                        make.width.equalTo(@80);
                        make.top.equalTo(remarkTitleLabel.mas_bottom).with.offset(9);
                        make.bottom.equalTo(bgView.mas_bottom).with.offset(-10);
                    }];
                }
                else {
                    [cancelReasonTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                        make.leading.equalTo(bgView.mas_leading).with.offset(10);
                        make.width.equalTo(@80);
                        make.top.equalTo(remarkTitleLabel.mas_bottom).with.offset(9);
                    }];
                }
                
            }
            else {
                UILabel *remarkTitleLabel = (UILabel *)[cell viewWithTag:31];
                UILabel *cancelReasonTitleLabel = (UILabel *)[cell viewWithTag:32];
                
                if ([WDSystemUtils isEmptyOrNullString:order.unsubscribe]) {
                    [cancelReasonTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                        make.leading.equalTo(bgView.mas_leading).with.offset(10);
                        make.width.equalTo(@80);
                        make.top.equalTo(descLabel.mas_bottom).with.offset(9);
                        make.bottom.equalTo(bgView.mas_bottom).with.offset(-10);
                    }];
                }
                else {
                    [cancelReasonTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                        make.leading.equalTo(bgView.mas_leading).with.offset(10);
                        make.width.equalTo(@80);
                        make.top.equalTo(descLabel.mas_bottom).with.offset(9);
                    }];
                }
            }
        }
    }
    
    
    if (_pageType == 1) {
        UIButton *phoneButton = (UIButton *)[cell viewWithTag:31];
        phoneButton.backgroundColor = RGBCOLOR(73, 180, 252);
        phoneButton.userInteractionEnabled = YES;
        [phoneButton addTarget:self action:@selector(connectWashWorkers:) forControlEvents:UIControlEventTouchUpInside];
        
        if (order.xcgsjh != nil
            && ![@"" isEqualToString:order.xcgsjh] &&
            ![@"<null>" isEqualToString:order.xcgsjh]) {
            phoneButton.hidden = NO;
        }
        else {
            phoneButton.hidden = NO;
        }
        
        UILabel *label = [cell viewWithTag:33];
        label.text = order.yjxcsj;
    }
    
    [bgView setNeedsUpdateConstraints];
    [bgView updateConstraintsIfNeeded];
    return cell;

}

-(void)evaluateWashWorkers:(id)sender
{
    OrderInfo *orderInfo = [_orders objectAtIndex:_selectIndex];
    PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:nil message:@"您对我们的服务还满意吗？" preferredStyle:PSTAlertControllerStyleActionSheet];
    [alertController addAction:[PSTAlertAction actionWithTitle:@"满意" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        [self evaluateCommit:1];
    }]];
    [alertController addAction:[PSTAlertAction actionWithTitle:@"基本满意" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        [self evaluateCommit:2];
    }]];
    [alertController addAction:[PSTAlertAction actionWithTitle:@"不满意" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        [self evaluateCommit:3];
    }]];
    [alertController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        
    }]];
    [alertController showWithSender:self.view controller:self animated:YES completion:nil];
    
}

-(void)evaluateCommit:(int)type
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    OrderInfo *order = [_orders objectAtIndex:_selectIndex];
    [parameters setValue:order.id forKey:@"tjtj"];
    [parameters setValue:@(type) forKey:@"pj"];
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiPJOrder parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        
        DLog(@"responseObject:%@",responseObject);
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            order.pj = [NSString stringWithFormat:@"%i",type];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_selectIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"评价失败"];
        }
        
    } failture:^(NSError *error) {
        [self.view makeToast:@"删除失败"];
    }];
}

-(void)connectWashWorkers:(id)sender
{
    OrderInfo *order = [_orders objectAtIndex:_selectIndex];;
    if (order.xcgsjh != nil
        && ![@"" isEqualToString:order.xcgsjh] &&
        ![@"<null>" isEqualToString:order.xcgsjh]) {
        PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:@"联系洗车工" message:@"" preferredStyle:PSTAlertControllerStyleActionSheet];
        [alertController addAction:[PSTAlertAction actionWithTitle:order.xcgsjh handler:^(PSTAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:\/\/%@",order.xcgsjh]]];
        }]];
        [alertController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:nil]];
        [alertController showWithSender:self.view controller:self animated:YES completion:nil];
        
    }
    else {
        PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:@"无法获取洗车工的手机号" message:@"" preferredStyle:PSTAlertControllerStyleAlert];
        [alertController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:nil]];
        [alertController showWithSender:self.view controller:self animated:YES completion:nil];
    }
}

-(void)longPressCell:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        MyTableViewCell *cell = (MyTableViewCell *)recognizer.view;
        　　　　　//这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        
        PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:@"删除" message:@"确定要删除当前订单吗？" preferredStyle:PSTAlertControllerStyleAlert];
        [alertController addAction:[PSTAlertAction actionWithTitle:@"删除" style:PSTAlertActionStyleDestructive handler:^(PSTAlertAction *action) {
            [self deleteOrder:indexPath];
        }]];
        [alertController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
            
        }]];
        [alertController showWithSender:self.view controller:self animated:YES completion:nil];
        
    }
}

-(void)deleteOrder:(NSIndexPath *)indexpath
{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    OrderInfo *order = [_orders objectAtIndex:indexpath.row];
    [parameters setValue:order.id forKey:@"id"];
    
    [[MayiHttpRequestManager sharedInstance] POST:MayiDeleteOrder parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        
        DLog(@"responseObject:%@",responseObject);
        
        if ([WDSystemUtils isEqualsInt:1 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [_orders removeObjectAtIndex:indexpath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if ([WDSystemUtils isEqualsInt:2 andJsonData:[responseObject objectForKey:@"res"]]) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }
        
    } failture:^(NSError *error) {
        [self.view makeToast:@"删除失败"];
    }];
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
    if (_testFlag) {
        [imageView setImage:[UIImage imageNamed:@"img_guide_01.png"]];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MDPhotoAlbumViewController *vc = [[MDPhotoAlbumViewController alloc] initWith:nil andImages:_selectOrderPictures];
    
    vc.initialIndex = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
