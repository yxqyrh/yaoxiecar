//
//  CarNumChoose.m
//  washcar
//
//  Created by xiejingya on 1/15/16.
//  Copyright © 2016 CSB. All rights reserved.
//

#import "CarNumChoose.h"

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
    return self;
}
-(void)initTableView{
    
    _tableView.delegate = self;
    _tableView.dataSource = self;

}

+ (instancetype)defaultPopupView{
    return [[CarNumChoose alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 200)];
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
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_dataArray==nil) {
//        return 0;
//    }
//    return _dataArray.count;
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    VoucherInfo *voucherInfo = _voucherInfoArray[indexPath.row];
//    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(VoucherChoosePopDelegate)]) { // 如果协议响应了sendValue:方法
//        // 通知执行协议方法
//        
//        [_delegate setVoucherInfo:voucherInfo];
//        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
//    }
}

@end
