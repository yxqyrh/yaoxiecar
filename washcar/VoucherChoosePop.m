//
//  VoucherChoosePop.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "VoucherChoosePop.h"
#import "StringUtil.h"
@implementation VoucherChoosePop

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
   
    return self;
}
+ (instancetype)defaultPopupView{
    return [[VoucherChoosePop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 400)];
}
-(void)initDelegate{
    _tableview.delegate = self;
    _tableview.dataSource = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *identifier = @"cell";
    PopVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PopVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    VoucherInfo *voucherInfo = _voucherInfoArray[indexPath.row];
//    cell.title.text = [@"优惠代金券金额:" stringByAppendingFormat:@"%@%@" ,voucherInfo.value,@"元"];
    
    cell.title.attributedText = [StringUtil getMenoyText:@"优惠代金券金额:" :voucherInfo.value :@"元"];
//    cell.btn.tag = indexPath.row;
//    [cell.btn addTarget:self action:@selector(onCellClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_voucherInfoArray==nil) {
        return 0;
    }
    return _voucherInfoArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherInfo *voucherInfo = _voucherInfoArray[indexPath.row];
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(VoucherChoosePopDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法

        [_delegate setVoucherInfo:voucherInfo];
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
