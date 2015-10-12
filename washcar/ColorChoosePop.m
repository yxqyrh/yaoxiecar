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
    }
    return self;
}
+ (instancetype)defaultPopupView{
    return [[ColorChoosePop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 210)];
}
- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}

- (IBAction)black:(id)sender {
    [self choose:0];
    
}
- (IBAction)white:(id)sender {
    [self choose:1];
}
- (IBAction)gray:(id)sender {
    [self choose:2];
}
- (IBAction)coffe:(id)sender {
    [self choose:3];
}
- (IBAction)blue:(id)sender {
    [self choose:4];
}

- (IBAction)red:(id)sender {
    [self choose:5];
}
- (IBAction)green:(id)sender {
    [self choose:6];
}

- (IBAction)yellow:(id)sender {
    [self choose:7];
    
}

+(NSString *)colorNameByValue:(int)value
{
    NSString *name = nil;
    switch (value) {
        case 0:
            name = @"黑色";
            break;
        case 1:
            name = @"白色";
            break;
        case 2:
            name = @"灰色";
            break;
        case 3:
            name = @"咖啡色";
            break;
        case 4:
            name = @"蓝色";
            break;
        case 5:
            name = @"红色";
            break;
        case 6:
            name = @"绿色";
            break;
        case 7:
            name = @"黄色";
            break;
            
        default:
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
