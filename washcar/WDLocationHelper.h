//
//  MDLocationHelper.h
//  PriMDV2R
//
//  Created by xuchengxiong on 14-7-9.
//  Copyright (c) 2014年 Mingdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

//定位的委托类
@protocol WDLocationHelperDelegate <NSObject>

- (void)didGetLocation:(CLLocationCoordinate2D)coordinate;
- (void)didGetLocationFail;

@end

@interface WDLocationHelper : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    id<WDLocationHelperDelegate> _delegate;
    NSString *_latitude;
    NSString *_longitude;
}

@property(retain, nonatomic) id<WDLocationHelperDelegate> delegate;
@property(copy, nonatomic) NSString *latitude;
@property(copy, nonatomic) NSString *longitude;

+ (WDLocationHelper *)getInstance;
- (void)startUpdate;
- (void)stopUpdate;

@end
