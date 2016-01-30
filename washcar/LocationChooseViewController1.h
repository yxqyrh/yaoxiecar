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
#import "SmallArea.h"

@protocol LocationChooseDelegate <NSObject>

-(void)chooseLocation:(NSString *)address
           provinceId:(NSString *)provinceId
               cityId:(NSString *)cityId
               areaId:(NSString *)areaId
               plotId:(NSString *)plotId
             plotName:(NSString *)plotName;

@end


@interface LocationChooseViewController1 : BaseViewController<UITableViewDelegate,UITableViewDataSource,LocationChooseViewControllerDelegate,UITextViewDelegate>
{
    NSArray *_allPlots;
    NSMutableArray *_filtedPlots;
}

@property (weak,nonatomic)NSObject<LocationChooseDelegate> *delegate;

@property (nonatomic) NSArray *provinceList;

-(void)initWithDic:(NSDictionary *)result;

-(void)initDataProvinceId:(NSString *)provinceId
             provinceName:(NSString *)provinceName
                   cityId:(NSString *)cityId
                 cityName:(NSString *)cityName
                   areaId:(NSString *)areaId
                 areaName:(NSString *)areaName
                   plotId:(NSString *)plotId
                 plotName:(NSString *)plotName
                nearPlots:(NSArray *)nearPlots;

-(void)initDataDZ:(NSDictionary *)dz
        nearPlots:(NSArray *)nearPlots
  andLocationPlot:(SmallArea *)smallArea;

@end
