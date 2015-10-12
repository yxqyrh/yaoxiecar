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
    return self;
}
+ (instancetype)defaultPopupView{
    return [[RechargeAmountPop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 240)];
}
- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}


-(void)setPrevSelectMoney:(int)prevSelectMoney
{
    switch (prevSelectMoney) {
        case 50:
            [self setIconImg:0];
            break;
        case 100:
             [self setIconImg:1];
            break;
        case 200:
             [self setIconImg:2];
            break;
        case 300:
             [self setIconImg:3];
            break;
        case 600:
             [self setIconImg:4];
            break;
            
        default:
            break;
    }
}

- (IBAction)btn_50:(id)sender {
    if (!_isSC) {
        return;
    }
    [self setIconImg:0];
     [self onBack:50];
}
- (IBAction)btn_100:(id)sender {
    [self setIconImg:1];
    [self onBack:100];
}
- (IBAction)btn_200:(id)sender {
    [self setIconImg:2];
    [self onBack:200];
}
- (IBAction)btn_300:(id)sender {
    [self setIconImg:3];
    [self onBack:300];
}
- (IBAction)btn_600:(id)sender {
    [self setIconImg:4];
    [self onBack:600];
}

-(void)onBack:(int)value{
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(RechargeAmountPopDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法
        
        [_delegate setRechargeValue:value];
        [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
    }
}

-(void)setIconImg:(int) value{
    switch (value) {
        case 0:
            self._50Check.image = [UIImage imageNamed:@"selected"];
            self._100Check.image = [UIImage imageNamed:@"unselected"];
            self._200Check.image = [UIImage imageNamed:@"unselected"];
            self._300Check.image = [UIImage imageNamed:@"unselected"];
            self._600Check.image = [UIImage imageNamed:@"unselected"];

            break;
            
        case 1:
            self._50Check.image = [UIImage imageNamed:@"unselected"];
            self._100Check.image = [UIImage imageNamed:@"selected"];
            self._200Check.image = [UIImage imageNamed:@"unselected"];
            self._300Check.image = [UIImage imageNamed:@"unselected"];
            self._600Check.image = [UIImage imageNamed:@"unselected"];
            break;
            
        case 2:
            self._50Check.image = [UIImage imageNamed:@"unselected"];
            self._100Check.image = [UIImage imageNamed:@"unselected"];
            self._200Check.image = [UIImage imageNamed:@"selected"];
            self._300Check.image = [UIImage imageNamed:@"unselected"];
            self._600Check.image = [UIImage imageNamed:@"unselected"];
            break;
            
        case 3:
            self._50Check.image = [UIImage imageNamed:@"unselected"];
            self._100Check.image = [UIImage imageNamed:@"unselected"];
            self._200Check.image = [UIImage imageNamed:@"unselected"];
            self._300Check.image = [UIImage imageNamed:@"selected"];
            self._600Check.image = [UIImage imageNamed:@"unselected"];
            break;
        case 4:
            self._50Check.image = [UIImage imageNamed:@"unselected"];
            self._100Check.image = [UIImage imageNamed:@"unselected"];
            self._200Check.image = [UIImage imageNamed:@"unselected"];
            self._300Check.image = [UIImage imageNamed:@"unselected"];
            self._600Check.image = [UIImage imageNamed:@"selected"];
            break;
        default:
            break;
    }
    
}
@end
