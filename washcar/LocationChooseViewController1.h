//
//  LocationChooseViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LocationChooseViewController.h"

@protocol LocationChooseDelegate <NSObject>

-(void)chooseLocation:(NSString *)address;

@end


@interface LocationChooseViewController1 : BaseViewController<UITableViewDelegate,UITableViewDataSource,LocationChooseViewControllerDelegate,UITextViewDelegate>
{
    NSArray *_allPlots;
    NSMutableArray *_filtedPlots;
}

@property (weak,nonatomic)NSObject<LocationChooseDelegate> *delegate;

-(void)initWithDic:(NSDictionary *)result;

@end
