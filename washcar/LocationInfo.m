//
//  LocationInfo.m
//  washcar
//
//  Created by xiejingya on 10/5/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo


+ (LocationInfo *)getInstance
{
    static LocationInfo *instance;
    
    @synchronized(self)
    {
        if (!instance)
            instance = [[LocationInfo alloc] init];
        
        return instance;
    }
}
-(void)clear{
    self.area_id_province = nil;
     self.area_id_city = nil;
     self.area_id_area = nil;
     self.area_id_smallArea = nil;
     self.area_name_province = nil;
     self.area_name_city = nil;
     self.area_name_area = nil;
     self.area_name_smallArea = nil;
}
@end
