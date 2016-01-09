//
//  Share.m
//  washcar
//
//  Created by jingyaxie on 16/1/9.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import "Share.h"

@implementation Share

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
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
    }
    
    return self;
}
+ (instancetype)defaultPopupView{
    return [[Share alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
}
-(void)showView{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 240);
     } completion:^(BOOL finished)
     {
     }];
    
    
}
-(void)hideView{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
     } completion:^(BOOL finished)
     {
     }];
}
@end
