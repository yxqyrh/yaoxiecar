//
//  MDLocationHelper.m
//  PriMDV2R
//
//  Created by xuchengxiong on 14-7-9.
//  Copyright (c) 2014年 Mingdao. All rights reserved.
//

#import "WDLocationHelper.h"

@implementation WDLocationHelper

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize delegate = _delegate;

static WDLocationHelper *_instance = nil;

+ (WDLocationHelper *)getInstance {
    if(_instance == nil) {
        _instance = [[WDLocationHelper alloc] init];
    }
    return _instance;
}

- (id)init {
    if(self = [super init]) {
        if(locationManager != nil) {
            return self;
        }
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 0.5;
        locationManager.delegate = self;
        if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
    
    return self;
}

- (void)stopUpdate {
    if(locationManager != nil) {
        [locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(locations != nil && [locations count] > 0) {
        CLLocation *location = [locations lastObject];
        CLLocationCoordinate2D coordinate = location.coordinate;
        [self setLatitude:[NSString stringWithFormat:@"%f", coordinate.latitude]];
        [self setLongitude:[NSString stringWithFormat:@"%f", coordinate.longitude]];
        NSLog(@"当前经度: %@, 纬度: %@", _longitude, _latitude);
        if([_delegate respondsToSelector:@selector(didGetLocation:)]) {
            [_delegate didGetLocation:coordinate];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    DLog(@"error:%@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败!" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    if([_delegate respondsToSelector:@selector(didGetLocationFail)]) {
        [_delegate didGetLocationFail];
    }
}

- (void)startUpdate {
    if(locationManager != nil) {
        [locationManager startUpdatingLocation];
    }
}

- (void)dealloc {
    locationManager = nil;
    _latitude = nil;
    _longitude = nil;
}
@end
