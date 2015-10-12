//
//  WashStyleChoose.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "WashStyleChoose.h"
#import "CommonMacro.h"

@implementation WashStyleChoose
- (IBAction)chooseOut:(id)sender {
    self.carOut.backgroundColor = [UIColor whiteColor];
    [ self.carOut setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    self.carIn.backgroundColor = COMMON_BACKGROUNDCOLOR;
    self.carIn.titleLabel.textColor = [UIColor whiteColor];
    [ self.carIn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.delegate setWashStyle:0];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
    
}
- (IBAction)chooseIn:(id)sender {
    self.carOut.backgroundColor = [UIColor whiteColor];
    self.carOut.titleLabel.textColor = [UIColor blackColor];
    self.carIn.backgroundColor = COMMON_BACKGROUNDCOLOR;
    self.carIn.titleLabel.textColor = [UIColor whiteColor];
    [self.delegate setWashStyle:1];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

-(void)refresh:(NSString *)washStyle{
    if ([washStyle isEqualToString:@"1"]) {
        self.carOut.backgroundColor = COMMON_BACKGROUNDCOLOR;
        [ self.carOut setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        self.carIn.backgroundColor = [UIColor whiteColor];
        [ self.carIn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
    }else {
        self.carOut.backgroundColor = [UIColor whiteColor];
        [ self.carOut setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        self.carIn.backgroundColor = COMMON_BACKGROUNDCOLOR;
        self.carIn.titleLabel.textColor = [UIColor whiteColor];
        [ self.carIn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    }
}

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
    return [[WashStyleChoose alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 180)];
}
- (IBAction)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}
@end
