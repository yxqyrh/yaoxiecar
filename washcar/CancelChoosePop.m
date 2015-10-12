//
//  CancelChoosePop.m
//  washcar
//
//  Created by CSB on 15/9/29.
//  Copyright © 2015年 CSB. All rights reserved.
//

#import "CancelChoosePop.h"
@interface CancelChoosePop (){
    NSString *unsubscribe1;
    NSString *unsubscribe2;
    NSString *defultText;
    UIScrollView *scroll;
    int x;
    int y;
    int width;
    int height;
}

@end
@implementation CancelChoosePop
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);

        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [scroll addSubview:_innerView];
        [self addSubview:scroll];
         _text.hidden = YES;
        _text.delegate = self;
        defultText = _text.text;
         x =  _text.frame.origin.x;
         y = _text.frame.origin.y;
         width = _text.frame.size.width;
         height = _text.frame.size.height;
    }
    return self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    [UIView animateWithDuration:0.6 animations:^
     {
         _text.frame = CGRectMake(x, 40, width, height);
     } completion:^(BOOL finished)
     {
     }];
    

    return YES;
}
- (IBAction)hideKeyboad:(id)sender {
    [_text resignFirstResponder];
}

//这是失去焦点
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  
    
    return YES;
}
+ (instancetype)defaultPopupView{
    return [[CancelChoosePop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 270)];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:defultText]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = defultText;
    }
    [_text resignFirstResponder];
    [UIView animateWithDuration:0.6 animations:^
     {
         _text.frame = CGRectMake(x, y, width, height);
     } completion:^(BOOL finished)
     {
     }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)submit:(id)sender {
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(CancelChoosePopDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法，自己定义要返回的值
        if (_text.hidden == NO) {
            if ([_text.text isEqualToString:defultText]) {
              unsubscribe2 = @"";
            }else{
                unsubscribe2 = _text.text;
            }
          
        }
        [_delegate complete:unsubscribe1 andSubscribe2:unsubscribe2];
    }
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
- (IBAction)action1:(id)sender {
    [self setIconImg:0];
    [self showContentText:NO];
    unsubscribe1 = @"临时有事不洗了";
}
- (IBAction)action2:(id)sender {
    [self setIconImg:1];
    [self showContentText:NO];
    unsubscribe1 = @"等待时间过长";
}
- (IBAction)action3:(id)sender {
    [self setIconImg:2];
    [self showContentText:NO];
     unsubscribe1 = @"下错单了";
}
- (IBAction)action4:(id)sender {
    [self setIconImg:3];
    [self showContentText:YES];
     unsubscribe1 = @"";
    
}

-(void)showContentText:(BOOL)isShow{
    [UIView animateWithDuration:1.0 animations:^
     {
         if (isShow) {
             _text.hidden = NO;

         }else{
             _text.hidden = YES;

         }
     } completion:^(BOOL finished)
     {
     }];
}
//UIImageView *icon_1;
//@property (weak, nonatomic) IBOutlet UIImageView *icon_2;
//@property (weak, nonatomic) IBOutlet UIImageView *icon_3;
//@property (weak, nonatomic) IBOutlet UIImageView *icon_4;
-(void)setIconImg:(int) value{
    switch (value) {
        case 0:
            _icon_1.image = [UIImage imageNamed:@"check_01"];
             _icon_2.image = [UIImage imageNamed:@"check_2"];
             _icon_3.image = [UIImage imageNamed:@"check_2"];
             _icon_4.image = [UIImage imageNamed:@"check_2"];
            break;
            
        case 1:
            _icon_1.image = [UIImage imageNamed:@"check_2"];
            _icon_2.image = [UIImage imageNamed:@"check_01"];
            _icon_3.image = [UIImage imageNamed:@"check_2"];
            _icon_4.image = [UIImage imageNamed:@"check_2"];
            break;
            
        case 2:
            _icon_1.image = [UIImage imageNamed:@"check_2"];
            _icon_2.image = [UIImage imageNamed:@"check_2"];
            _icon_3.image = [UIImage imageNamed:@"check_01"];
            _icon_4.image = [UIImage imageNamed:@"check_2"];
            break;
            
        case 3:
            _icon_1.image = [UIImage imageNamed:@"check_2"];
            _icon_2.image = [UIImage imageNamed:@"check_2"];
            _icon_3.image = [UIImage imageNamed:@"check_2"];
            _icon_4.image = [UIImage imageNamed:@"check_01"];
            break;
            
        default:
            break;
    }
    
}

@end
