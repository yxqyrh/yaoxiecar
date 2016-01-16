//
//  LocationChooseViewController.h
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@protocol LocationChooseViewControllerDelegate<NSObject> // 代理传值方法
@required
- (void) showAreaChannel:(int)chanel
                id:(NSString *)id
                name:(NSString *)name;
@end

@interface LocationChooseViewController : BaseTableViewController<UITableViewDelegate,UITableViewDataSource>
-(void)loadProvinceList;
-(void)loadCityList;
-(void)loadAreaList;
-(void)loadSmallAreaList;
-(void)chooseLoaction:(NSString*)area_id:(NSString*)name;
@property NSString *parentId;//地区id
@property int channel;//代表是0 代表省份  1：city  2：area   3：smallArea
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) id<LocationChooseViewControllerDelegate> mydelegate;

@property (nonatomic) NSArray* arrayList;;


@end
