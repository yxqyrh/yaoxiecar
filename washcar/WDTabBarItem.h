//
//  WDTabBarItem.h
//  WDLinkUp
//
//  Created by William REN on 11/6/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WDTabBarItemDelegate <NSObject>
@required
- (void)tabBarItemBeSelected:(int)index;

@end

@interface WDTabBarItem : UIView {
    @private
    UIButton *_button;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    CALayer *_noticeLayer;
}

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *highlightImageName;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL buttonEnable;
@property (nonatomic) BOOL hasNoticed;
@property (nonatomic) int index;
@property (nonatomic) id<WDTabBarItemDelegate> delegate;


- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              index:(int)index
          imageName:(NSString *)imageName
 highlightImageName:(NSString *)highlightImageName;

@end
