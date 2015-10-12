//
//  WDTabBar.m
//  WDLinkUp
//
//  Created by William REN on 11/6/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import "WDTabBar.h"
#import "Masonry.h"

@implementation WDTabBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_tab_bar_background"]];
        
        
        UITabBarItem *tabbarItem1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"img_01_car_pre"] tag:1];
        
        
        UITabBarItem *tabbarItem2 = [[UITabBarItem alloc] initWithTitle:@"订单" image:[UIImage imageNamed:@"img_02_order_pre"] tag:2];
        
        UITabBarItem *tabbarItem3 = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"img_03_me_pre"] tag:3];
        
        self.items = @[tabbarItem1,tabbarItem2,tabbarItem3];
        
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = RgbHex2UIColor(162, 208, 243);
                [self addSubview:view];
        
        UIView *superView = self;
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(superView.mas_leading);
                    make.trailing.equalTo(superView.mas_trailing);
                    make.top.equalTo(superView.mas_top);
                    make.height.equalTo(@0.5);
                    
                }];
        
    }
    
    
    return self;
}

//- (id)inw1itWithCoder:(NSCoder *)aDecoder
//{
//    
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//
//        
//        CGFloat width = self.bounds.size.width / 3;
//        CGFloat xOffset = 0;
//        
//        
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_tab_bar_background"]];
//        WDTabBarItem *tabBarItem00 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(xOffset, 0, width, 49)
//                                                                   title:@" 首页"
//                                                                   index:0
//                                                               imageName:@"img_01_car"
//                                                      highlightImageName:@"img_01_car_pre"];
//        //    tabBarItem00.selected = YES;
//        tabBarItem00.delegate = self;
//        
//        xOffset += width;
//        WDTabBarItem *tabBarItem01 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(xOffset, 0, width, 49)
//                                                                   title:@" 我的订单"
//                                                                   index:1
//                                                               imageName:@"img_02_order"
//                                                      highlightImageName:@"img_02_order_pre"];
//        tabBarItem01.delegate = self;
//        
//        xOffset += width;
//        WDTabBarItem *tabBarItem02 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(xOffset, 0, width, 49)
//                                                                   title:@" 个人中心"
//                                                                   index:2
//                                                               imageName:@"img_03_me"
//                                                      highlightImageName:@"img_03_me_pre"];
//        tabBarItem02.delegate = self;
//        
//        [self addSubview:tabBarItem00];
//        [self addSubview:tabBarItem01];
//        [self addSubview:tabBarItem02];
//        
//        UIView *superView = self;
//        [tabBarItem00 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(superView.mas_leading).with.offset(0);
//            make.top.equalTo(superView.mas_top).with.offset(0);
//            make.bottom.equalTo(superView.mas_bottom).with.offset(0);
//        }];
//        
//        
//        
//        [tabBarItem02 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(superView.mas_trailing).with.offset(0);
//            make.top.equalTo(superView.mas_top).with.offset(0);
//            make.bottom.equalTo(superView.mas_bottom).with.offset(0);
//            make.width.equalTo(tabBarItem00.mas_width);
//        }];
//        
//        [tabBarItem01 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(tabBarItem00.mas_trailing).with.offset(0);
//            make.trailing.equalTo(tabBarItem02.mas_leading).with.offset(0);
//            make.bottom.equalTo(superView.mas_bottom).with.offset(0);
//            make.top.equalTo(superView.mas_top).with.offset(0);
//            make.width.equalTo(tabBarItem00.mas_width);
//        }];
////
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = RgbHex2UIColor(162, 208, 243);
//        [self addSubview:view];
//        
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(superView.mas_leading);
//            make.trailing.equalTo(superView.mas_trailing);
//            make.top.equalTo(superView.mas_top);
//            make.height.equalTo(@0.5);
//            
//        }];
//
//        
//        _tabBarItems = [NSMutableArray arrayWithObjects:tabBarItem00, tabBarItem01, tabBarItem02, nil];
////        [self selectItem:0];
//    }
//    return self;
//}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_tab_bar_background"]];
//    WDTabBarItem *tabBarItem00 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(0, 0, 64, 49)
//                                                               title:@"动态"
//                                                               index:0
//                                                           imageName:@"tab_bar_icon00"
//                                                  highlightImageName:@"tab_bar_icon_highlight00"];
////    tabBarItem00.selected = YES;
//    tabBarItem00.delegate = self;
//    WDTabBarItem *tabBarItem01 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(64, 0, 64, 49)
//                                                               title:@"消息"
//                                                               index:1
//                                                           imageName:@"tab_bar_icon01"
//                                                  highlightImageName:@"tab_bar_icon_highlight01"];
//    tabBarItem01.delegate = self;
//    WDTabBarItem *tabBarItem02 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(192, 0, 64, 49)
//                                                               title:@"任务"
//                                                               index:2
//                                                           imageName:@"tab_bar_icon02"
//                                                  highlightImageName:@"tab_bar_icon_highlight02"];
//    tabBarItem02.delegate = self;
//    WDTabBarItem *tabBarItem03 = [[WDTabBarItem alloc] initWithFrame:CGRectMake(256, 0, 64, 49)
//                                                               title:@"日程"
//                                                               index:3
//                                                           imageName:@"tab_bar_icon03"
//                                                  highlightImageName:@"tab_bar_icon_highlight03"];
//    tabBarItem03.delegate = self;
//    
//    [self addSubview:tabBarItem00];
//    [self addSubview:tabBarItem01];
//    [self addSubview:tabBarItem02];
//    [self addSubview:tabBarItem03];
//    _tabBarItems = [NSMutableArray arrayWithObjects:tabBarItem00, tabBarItem01, tabBarItem02, tabBarItem03, nil];
//    [self selectItem:0];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//#pragma mark - TabBarItem Delegate
//- (void)tabBarItemBeSelected:(int)index
//{
//    for (WDTabBarItem *item in _tabBarItems) {
//        item.selected = NO;
//    }
//    ((WDTabBarItem *)[_tabBarItems objectAtIndex:index]).selected = YES;
//    if (_selectBlock) {
//        self.selectBlock(index);
//    }
//}
//
//
//- (void)selectItem:(int)index
//{
//    UITabBarItem *item = [self.items objectAtIndex:index]
//}
//
//- (void)selectItem:(int)index hasOperation:(bool)hasOperation
//{
//    
//    for (WDTabBarItem *item in _tabBarItems) {
//        item.selected = NO;
//    }
//    ((WDTabBarItem *)[_tabBarItems objectAtIndex:index]).selected = YES;
//    
//    if (hasOperation) {
//        if (_selectBlock) {
//            self.selectBlock(index);
//        }
//    }
//}

- (void)setItemsEnable:(BOOL)itemsEnable
{
    
//    for (WDTabBarItem *item in _tabBarItems) {
//        item.buttonEnable = itemsEnable;
//    }
}

-(void)setHasNotice:(bool)hasNotice atIndex:(int)index
{
//    WDTabBarItem *item = [_tabBarItems objectAtIndex:index];
//    item.hasNoticed = hasNotice;
}

@end
