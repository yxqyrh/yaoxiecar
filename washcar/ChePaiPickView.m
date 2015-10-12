//
//  ChePaiPickView.m
//  washcar
//
//  Created by xiejingya on 10/11/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import "ChePaiPickView.h"
@interface ChePaiPickView (){
    NSArray *provinceList;
    NSArray *AZList;
    NSString *pro;
    NSString *a_z;
   }
@end
@implementation ChePaiPickView
- (IBAction)commit:(id)sender {
     [self onValueChange];
    [self hideView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
*/
- (IBAction)cancel:(id)sender {
     [self hideView];
    pro =@"";
    a_z =@"";
     [self onValueChange];
}
- (id)initWithFrame:(CGRect)frame
{
    provinceList = [[NSArray alloc]initWithObjects:@"粤",@"浙", @"京", @"沪", @"川", @"津", @"渝", @"鄂", @"赣", @"冀", @"蒙", @"鲁", @"苏", @"辽", @"吉", @"皖", @"湘", @"黑", @"琼", @"贵", @"桂", @"云", @"藏", @"陕", @"甘", @"宁", @"青", @"豫", @"闽", @"新",  @"晋",  nil];
        AZList = [[NSArray alloc]initWithObjects:@"A",@"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",  nil];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];

        _provinceShort.delegate = self;
        _provinceShort.dataSource = self;
        pro =@"粤";
         a_z =@"A";
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
    }
    return self;
}
+ (instancetype)defaultView{
    return [[ChePaiPickView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
}
-(void)showView{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 240);
     } completion:^(BOOL finished)
     {
     }];

   
}
-(void)hideView{
    [UIView animateWithDuration:0.6 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
     } completion:^(BOOL finished)
     {
     }];
}


//以下3个方法实现PickerView的数据初始化
//确定picker的轮子个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {//省份个数
        return [provinceList count];
    } else if (component == 1){//市的个数
        return [AZList count];
    }
    return 0;
}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (component == 0) {//选择省份名
        pro = [provinceList objectAtIndex:row];
        return  pro;
    } else  if (component == 1){//选择市名
        a_z = [AZList objectAtIndex:row];
        return  a_z;
    }
    
    return  @"";
}


// 选中component中某一行数据时触发的回调方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {//选择省份名
        pro = [provinceList objectAtIndex:row];
    } else  if (component == 1){//选择市名
        a_z = [AZList objectAtIndex:row];
    }
}
-(void)onValueChange{
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(ChePaiPickViewDelegate)]) { // 如果协议响应了sendValue:方法
        // 通知执行协议方法，自己定义要返回的值
        [_delegate valueChange:pro A_Z:a_z];
    }
    

}


@end
