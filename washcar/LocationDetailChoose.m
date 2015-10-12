//
//  LocationDetailChoose.m
//  washcar
//
//  Created by xiejingya on 9/30/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import "LocationDetailChoose.h"
#import "PopVoucherTableViewCell.h"
#import "MayiHttpRequestManager.h"

@interface LocationDetailChoose (){
    NSArray *_arrayList;
}
@end
@implementation LocationDetailChoose

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    
    return self;
}
+ (instancetype)defaultPopupView{
    return [[LocationDetailChoose alloc]initWithFrame:CGRectMake(0, 0, 340, 500)];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    PopVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PopVoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
    }
    NSDictionary *_dic = _arrayList[indexPath.row];
    cell.title.text = [_dic objectForKey:@"area_name"];
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrayList==nil) {
        return 0;
    }
    return _arrayList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)loadProvinceList{
    [self loadData:ProvinceApi];
}
-(void)loadCityList{
    [self loadData:CityApi];
    
}
-(void)loadAreaList{
    [self loadData:AreaApi];
}
-(void)loadSmallAreaList{
    [self loadData:SmallAreaApi];
}


-(void) loadData:(NSString *) api{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    if (_area_id!=nil) {
        [parameters setValue:_area_id forKey:@"area_id"];
    }
    [[MayiHttpRequestManager sharedInstance] POST:api parameters:parameters showLoadingView:self success:^(id responseObject) {
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            _arrayList = [responseObject objectForKey:@"list"];
            
            DLog(@"_arrayList=%@",_arrayList)
            [self.tableview reloadData];
        }else{
            
        }
    } failture:^(NSError *error) {
        
    }];
    
}


@end
