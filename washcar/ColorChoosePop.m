//
//  ColorChoosePop.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "ColorChoosePop.h"

@implementation ColorChoosePop

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
        
        _whiteView.backgroundColor = RgbHex2UIColorWithAlpha(255, 255, 255, 1);
        _blackView.backgroundColor = RgbHex2UIColorWithAlpha(0, 0, 0, 1);
        _yellowView.backgroundColor = RgbHex2UIColorWithAlpha(253, 198, 47, 1);
        _darkBlueView.backgroundColor = RgbHex2UIColorWithAlpha(21, 106, 144, 1);
        _redView.backgroundColor = RgbHex2UIColorWithAlpha(215, 13, 44, 1);
        _greenView.backgroundColor = RgbHex2UIColorWithAlpha(27, 174, 84, 1);
        _brownView.backgroundColor = RgbHex2UIColorWithAlpha(142, 79, 22, 1);
        _silveryGrayView.backgroundColor = RgbHex2UIColorWithAlpha(157, 158, 159, 1);
        _purpleView.backgroundColor = RgbHex2UIColorWithAlpha(163, 43, 118, 1);
        _lightBlueView.backgroundColor = RgbHex2UIColorWithAlpha(56, 185, 226, 1);
        _goldenYellowView.backgroundColor = RgbHex2UIColorWithAlpha(247, 153, 39, 1);
        _creamColorView.backgroundColor = RgbHex2UIColorWithAlpha(253, 225, 131, 1);
    }
    return self;
}
+ (instancetype)defaultPopupView{
    return [[ColorChoosePop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 300)];
}
- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}



- (IBAction)black:(id)sender {
    [self choose:0];
    
}
- (IBAction)colorItemClick:(id)sender
{
    UIControl *control = (UIControl *)sender;
    NSInteger tag = control.tag;
    
    [self choose:tag];
}


+(NSString *)colorNameByValue:(int)value
{
    NSString *name = nil;
    switch (value) {
        case 1:
            name = @"白色";
            break;
        case 2:
            name = @"黑色";
            break;
        case 3:
            name = @"黄色";
            break;
        case 4:
            name = @"深蓝";
            break;
        case 5:
            name = @"红色";
            break;
        case 6:
            name = @"绿色";
            break;
        case 7:
            name = @"棕色";
            break;
        case 8:
            name = @"银灰";
            break;
        case 9:
            name = @"紫色";
            break;
        case 10:
            name = @"浅蓝";
            break;
        case 11:
            name = @"金黄";
            break;
        case 12:
            name = @"米色";
            break;
        default:
            name = @"其它";
            break;
    }
    return name;
}


-(void) choose:(NSInteger) value{
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(ColorChoosePopDelegate)]) { // 如果协议响应了sendValue:方法
       // 通知执行协议方法
         [_delegate sendColorValue:value];
    }
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
@end
