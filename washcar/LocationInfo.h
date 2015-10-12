//
//  LocationInfo.h
//  washcar
//
//  Created by xiejingya on 10/5/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject{

}
@property   (nonatomic)NSString *area_id_province;
@property    (nonatomic)NSString *area_id_city;
@property    (nonatomic)NSString *area_id_area;
@property    (nonatomic) NSString *area_id_smallArea;

@property    (nonatomic) NSString *area_name_province;
@property    (nonatomic) NSString *area_name_city;
@property    (nonatomic) NSString *area_name_area;
@property    (nonatomic) NSString *area_name_smallArea;
+ (LocationInfo *)getInstance;

-(void)clear;
@end
