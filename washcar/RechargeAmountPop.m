//
//  RechargeAmountPop.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "RechargeAmountPop.h"
#import "StringUtil.h"
@implementation RechargeAmountPop

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return self;
}
+ (instancetype)defaultPopupView{
    return [[RechargeAmountPop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 240)];
}
- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}


//-(void)setPrevSelectMoney:(int)prevSelectMoney
//{
//    switch (prevSelectMoney) {
//        case 50:
//            [self setIconImg:0];
//            break;
//        case 100:
//             [self setIconImg:1];
//            break;
//        case 200:
//             [self setIconImg:2];
//            break;
//        case 300:
//             [self setIconImg:3];
//            break;
//        case 600:
//             [self setIconImg:4];
//            break;
//            
//        default:
//            break;
//    }
//}

//- (IBAction)btn_50:(id)sender {
//    if (!_isSC) {
//        return;
//    }
//    [self setIconImg:0];
//     [self onBack:50];
//}
//- (IBAction)btn_100:(id)sender {
//    [self setIconImg:1];
//    [self onBack:100];
//}
//- (IBAction)btn_200:(id)sender {
//    [self setIconImg:2];
//    [self onBack:200];
//}
//- (IBAction)btn_300:(id)sender {
//    [self setIconImg:3];
//    [self onBack:300];
//}
//- (IBAction)btn_600:(id)sender {
//    [self setIconImg:4];
//    [self onBack:600];
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _rechargeArray[indexPath.row];
    NSString *cellIdentifier = @"CarNumChooseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"CarNumChooseCell" owner:nil options:nil] firstObject];
    }
    UILabel *title = [cell viewWithTag:1];
    NSString *recharge = [dic objectForKey:@"recharge"];
    NSString *free = [dic objectForKey:@"free"];
    NSString *str =  [@"充" stringByAppendingFormat:@"%@%@%@%@",  recharge,@"元送",free, @"元"];
    title.text = str;
    UIImageView *image = [cell viewWithTag:2];
    if (indexPath.row == _current_seleted_row) {
        [image setImage:[UIImage imageNamed:@"img_checked"]];
    }else{
        [image setImage:[UIImage imageNamed:@"img_unchecked"]];
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_rechargeArray==nil) {
        return 0;
    }
    return _rechargeArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _current_seleted_row = indexPath.row;
    [ _tableView reloadData];
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(RechargeAmountPopDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法
        NSDictionary *dic = _rechargeArray[indexPath.row];
        NSString *aString = [dic objectForKey:@"recharge"];
        int value = [aString intValue];
        [_delegate setRechargeValue:value:indexPath.row];
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
    }
//    VoucherInfo *voucherInfo = _voucherInfoArray[indexPath.row];
//    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(VoucherChoosePopDelegate)]) { // 如果协议响应了sendValue:方法
//        // 通知执行协议方法
//        
//        [_delegate setVoucherInfo:voucherInfo:_current_seleted_row];
//        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
//    }
}

//-(void)onBack:(int)value{
//    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(RechargeAmountPopDelegate)]) { // 如果协议响应了sendValue:方法
//        // 通知执行协议方法
//        
//        [_delegate setRechargeValue:value];
//        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
//    }
//}
@end
