//
//  LocationChoosePop.m
//  MayiCar
//
//  Created by xiejingya on 9/27/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "LocationChoosePop.h"
#import "SVProgressHUD.h"
#import "LocationInfo.h"
@interface LocationChoosePop(){
    
  
}

@end

@implementation LocationChoosePop

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
    if ([LocationInfo getInstance].area_name_province!=nil) {
        [self.chooseProvince setTitle:[LocationInfo getInstance].area_name_province forState:UIControlStateNormal];
    }else{
         [self.chooseProvince setTitle:@"选省" forState:UIControlStateNormal];
    }
    
    if ([LocationInfo getInstance].area_name_city!=nil) {
        [self.chooseCity setTitle:[LocationInfo getInstance].area_name_city forState:UIControlStateNormal];
    }else {
        [self.chooseCity setTitle:@"选城市" forState:UIControlStateNormal];
    }
    
    
    if ([LocationInfo getInstance].area_name_area!=nil) {
        [self.chooseArea setTitle:[LocationInfo getInstance].area_name_area forState:UIControlStateNormal];
    }else{
         [self.chooseArea setTitle:@"选区" forState:UIControlStateNormal];
    }
    
    if ([LocationInfo getInstance].area_name_smallArea!=nil) {
        NSString *tmp =[LocationInfo getInstance].area_name_smallArea;
            if(tmp == nil ||[tmp isEqualToString:@""]||tmp.length == 0){
            [self.chooseStreet setTitle:@"该地区暂无服务网点" forState:UIControlStateNormal];
        }else{
            [self.chooseStreet setTitle:[LocationInfo getInstance].area_name_smallArea forState:UIControlStateNormal];
        }
    }else{
        [self.chooseStreet setTitle:@"选小区" forState:UIControlStateNormal];
    }
    return self;
}
+ (instancetype)defaultPopupView{
    return [[LocationChoosePop alloc]initWithFrame:CGRectMake(0, 0, POP_WIDTH, 230)];
}


- (IBAction)chooseProvince:(id)sender {
    [self.mydelegate showDetailChoose:0];
   [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

- (IBAction)chooseCity:(id)sender {
    if([LocationInfo getInstance].area_id_province==nil){
        [self makeToast:@"请先选择省份"];
        return;
    }
    [self.mydelegate showDetailChoose:1];
   
     [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
- (IBAction)chooseArea:(id)sender {
    if([LocationInfo getInstance].area_id_city==nil){
        [self makeToast:@"请先选择城市"];
        return;
    }
    [self.mydelegate showDetailChoose:2];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

- (IBAction)chooseStreet:(id)sender {
    if([LocationInfo getInstance].area_id_area==nil){
        [self makeToast:@"请先选择区"];
        return;
    }

     [self.mydelegate showDetailChoose:3];
     [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
- (IBAction)ok:(id)sender {
    if([LocationInfo getInstance].area_name_province==nil||[LocationInfo getInstance].area_name_area==nil||[LocationInfo getInstance].area_name_city==nil||[LocationInfo getInstance].area_name_smallArea==nil){
        
        [self makeToast:@"地址信息不全，请补全地址"];
        return;
    }
    [self.mydelegate ok];
     [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
@end
