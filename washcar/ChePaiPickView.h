//
//  ChePaiPickView.h
//  washcar
//
//  Created by xiejingya on 10/11/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChePaiPickViewDelegate<NSObject> // 代理传值方法
@required
- (void)valueChange:(NSString *)provinceShort A_Z:(NSString *)A_Z;
@end
@interface ChePaiPickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
// 委托代理人，代理一般需使用弱引用(weak)
@property (nonatomic) id<ChePaiPickViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIButton *ok;

@property (weak, nonatomic) IBOutlet UIPickerView *provinceShort;
-(void)showView;
-(void)hideView;
+ (instancetype)defaultView;
@end
