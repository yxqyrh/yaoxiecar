//
//  WashStyleChoose.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "WashStyleChoose.h"
//#import "CommonMacro.h"
#import "WashType.h"

@implementation WashStyleChoose


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
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return self;
}

+ (instancetype)defaultPopupView{
    return [[WashStyleChoose alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 180)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"CarNumChooseCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"CarNumChooseCell" owner:nil options:nil] firstObject];
    }
    UILabel *title = [cell viewWithTag:1];
    WashType *_WashType = _washTypeArray[indexPath.row];
  title.text = _WashType.fs;
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
    if(_washTypeArray==nil)
    {
        return 0;
    }
    return  _washTypeArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     _current_seleted_row = indexPath.row;
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(WashStyleChooseDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法
        
        [_delegate setWashStyle:indexPath.row];
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
    }
}
@end
