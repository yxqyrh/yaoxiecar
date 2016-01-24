//
//  CarNumChoose.m
//  washcar
//
//  Created by xiejingya on 1/15/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import "CarNumChoose.h"
#import "CarInfo.h"
@implementation CarNumChoose

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
    [self initTableView];
    return self;
}
-(void)initTableView{
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

+ (instancetype)defaultPopupView{
    return [[CarNumChoose alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH-16, 240)];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"CarNumChooseCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
         if (cell==nil) {
               // cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                 cell= [[[NSBundle mainBundle]loadNibNamed:@"CarNumChooseCell" owner:nil options:nil] firstObject];
            }
    UILabel *title = [cell viewWithTag:1];
   
    CarInfo *info =  [GlobalVar sharedSingleton].carInfoList[indexPath.row];
    NSString *str = [info.cp1 stringByAppendingFormat:@"%@%@",info.cp2,info.cp3];
    title.text = str;
    UIImageView *image = [cell viewWithTag:2];
    if (indexPath.row == _current_seleted_row) {
        [image setImage:[UIImage imageNamed:@"selected"]];
    }else{
        [image setImage:[UIImage imageNamed:@"unselected"]];
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

    return  [GlobalVar sharedSingleton].carInfoList.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _current_seleted_row = indexPath.row;
    [_tableView reloadData];

    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(CarNumChooseDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法
        
        [_delegate setCarNum:indexPath.row];
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
    }
}
//-(void) onCellClick:(UIButton *)btn{
//    int row = btn.tag;
//    VoucherInfo *voucherInfo = _voucherInfoArray[row];
//    [_delegate setVoucherInfo:voucherInfo];
//    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
//}

@end
