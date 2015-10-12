//
//  WDTabBarItem.m
//  WDLinkUp
//
//  Created by William REN on 11/6/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "WDTabBarItem.h"

@implementation WDTabBarItem

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 12, self.frame.size.width, 9)];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
//        _titleLabel.textColor = [UIColor colorWithRed:0.49 green:0.48 blue:0.48 alpha:1];
//        [self addSubview:_titleLabel];
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        _button.backgroundColor = [UIColor clearColor];
//        _button.frame = self.bounds;
//        [_button addTarget:self
//                    action:@selector(buttonClicked:)
//          forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
//    }
//    return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 12, self.frame.size.width, 9)];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
//        _titleLabel.textColor = [UIColor colorWithRed:0.49 green:0.48 blue:0.48 alpha:1];
//        [self addSubview:_titleLabel];
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        _button.backgroundColor = [UIColor clearColor];
//        _button.frame = self.bounds;
//        [_button addTarget:self
//                    action:@selector(buttonClicked:)
//          forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
//    }
//    return self;
//}

//- (id)initWithFrame:(CGRect)frame
//              title:(NSString *)title
//              index:(int)index
//          imageName:(NSString *)imageName
// highlightImageName:(NSString *)highlightImageName
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _index = index;
//        _imageName = imageName;
//        _highlightImageName = highlightImageName;
//        
////        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, (self.frame.size.height - 12) / 2, self.frame.size.width, 12)];
////        _titleLabel.backgroundColor = [UIColor clearColor];
////        _titleLabel.textAlignment = NSTextAlignmentCenter;
////        _titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
////        _titleLabel.textColor = [UIColor colorWithRed:0.49 green:0.48 blue:0.48 alpha:1];
////        [self addSubview:_titleLabel];
//        
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        _button.frame = CGRectMake(0, 0.5, self.bounds.size.width, self.bounds.size.height);
//        _button.backgroundColor = [UIColor clearColor];
//        [_button addTarget:self
//                    action:@selector(buttonClicked:)
//          forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
//        [self setTitle:title];
//        [_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        [_button setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
//        [_button setTitleColor:[UIColor colorWithRed:0.49 green:0.48 blue:0.48 alpha:1] forState:UIControlStateNormal];
//        
//        [_button setTitle:title forState:UIControlStateNormal];
////        _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
////        _button.layer.borderWidth = 0.3;
//        
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = GeneralLineCGColor;
//        
////        CALayer *layer = [[CALayer alloc] init];
////        layer.frame = CGRectMake(self.bounds.size.width - 0.5, 0, 0.3, self.bounds.size.height);
////        layer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3].CGColor;
////        [self.layer addSublayer:layer];
//        
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              index:(int)index
          imageName:(NSString *)imageName
 highlightImageName:(NSString *)highlightImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = index;
        _imageName = imageName;
        _highlightImageName = highlightImageName;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 12, self.frame.size.width, 9)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
        _titleLabel.textColor = [UIColor colorWithRed:0.49 green:0.48 blue:0.48 alpha:1];
        [self addSubview:_titleLabel];
        
        
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self
                    action:@selector(buttonClicked:)
       
         
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [self setTitle:title];
        [_button setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
        
        _noticeLayer = [[CALayer alloc] init];
        _noticeLayer.frame = CGRectMake(self.frame.size.width - 22, 4, 6, 6);
        _noticeLayer.backgroundColor = [UIColor redColor].CGColor;
        _noticeLayer.cornerRadius = 3;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        [_button setImage:[UIImage imageNamed:_highlightImageName] forState:UIControlStateNormal];
//        _titleLabel.textColor = [UIColor colorWithRed:0.09 green:0.54 blue:0.86 alpha:1];
        
        [_button setTitleColor:[UIColor colorWithRed:0.09 green:0.54 blue:0.86 alpha:1] forState:UIControlStateNormal];
    } else {
        
        [_button setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
       
        
        [_button setTitleColor:[UIColor colorWithRed:0.49 green:0.48 blue:0.48 alpha:1] forState:UIControlStateNormal];
    }
}

-(void)setHasNoticed:(BOOL)hasNoticed
{
    if (_hasNoticed == hasNoticed) {
        return;
    }
    _hasNoticed = hasNoticed;
    if (hasNoticed) {
        [self.layer addSublayer:_noticeLayer];
    }
    else {
        [_noticeLayer removeFromSuperlayer];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)buttonClicked:(id)sender
{
    DLog(@"buttonClicked: %d", _index);
    if (_selected) {
        return;
    }
//    self.selected = !_selected;
    
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(tabBarItemBeSelected:)]) {
            [_delegate tabBarItemBeSelected:_index];
        }
    }
}

- (void)setButtonEnable:(BOOL)buttonEnable
{
    _button.enabled = buttonEnable;
}

@end
