//
//  WDTabBar.h
//  WDLinkUp
//
//  Created by William REN on 11/6/14.
//  Copyright (c) 2014 Wonders information Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTabBarItem.h"

typedef void (^WDTabBarSelectBlock)(int);

@interface WDTabBar : UITabBar {
//    NSMutableArray *_tabBarItems;
}

//@property (copy, nonatomic) WDTabBarSelectBlock selectBlock;
//@property (nonatomic) BOOL itemsEnable;


//- (void)selectItem:(int)index;
//
//- (void)selectItem:(int)index hasOperation:(bool)hasOperation;
//
//-(void)setHasNotice:(bool)hasNotice atIndex:(int)index;

@end
