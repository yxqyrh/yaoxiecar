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
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (self) {
      
        
        
        UILabel *code = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH-16, 30)];
        code.text = @"我的邀请码：123456";
        code.textAlignment = NSTextAlignmentCenter;
        [self addSubview:code];
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(8, 46, (SCREEN_WIDTH-40)/4, 130)];
         [self addSubview:btn1];
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(btn1.frame.origin.x+8+(SCREEN_WIDTH-40)/4, 46, (SCREEN_WIDTH-40)/4, 130)];
        [self addSubview:btn2];
        UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(btn2.frame.origin.x+8+(SCREEN_WIDTH-40)/4, 46, (SCREEN_WIDTH-40)/4, 130)];
         [self addSubview:btn3];
        UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(btn3.frame.origin.x+8+(SCREEN_WIDTH-40)/4, 46, (SCREEN_WIDTH-40)/4, 130)];
        [self addSubview:btn4];
        UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(8, self.frame.size.height-80, SCREEN_WIDTH-16, 50)];
        [self addSubview:cancel];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.backgroundColor = [UIColor grayColor];
        [self initBtn:btn1 :@"share_icon_1" :@"微信"];
        [self initBtn:btn2 :@"share_icon_2" :@"朋友圈"];
        [self initBtn:btn3 :@"share_icon_3" :@"QQ"];
        [self initBtn:btn4 :@"share_icon_4" :@"短信"];
      
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
-(void)cancel:(id)sender{
    //这个sender其实就是UIButton，因此通过sender.tag就可以拿到刚才的参数
    [self hideView];
}

-(void) initBtn:(UIButton*)btn:(NSString*)iconName :(NSString*)btnTitle{
    //UIImage *image =[self reSizeImage:[UIImage imageNamed:iconName] toSize:CGSizeMake(40, 40)];
    UIImage *image =[UIImage imageNamed:iconName] ;
    [btn setTitle:btnTitle forState:UIControlStateNormal];
     btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + 5);
    
    // raise the image and push it right to center it
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    
    [[btn layer]setCornerRadius:8.0];
}
+ (instancetype)defaultPopupView{
    return [[Share alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
}
-(void)showView{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_HEIGHT-360 ,SCREEN_WIDTH, 300);
     } completion:^(BOOL finished)
     {
     }];
    
    
}
-(void)hideView{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
     } completion:^(BOOL finished)
     {
     }];
}
@end
