//
//  PopVoucherTableViewCell.m
//  washcar
//
//  Created by xiejingya on 9/28/15.
//  Copyright © 2015 CSB. All rights reserved.
//

#import "PopVoucherTableViewCell.h"
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
@implementation PopVoucherTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *item = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _title = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, SCREEN_WIDTH-8, 40)];
        [_title setTextColor:[UIColor blackColor]];
        _title.font=[UIFont boldSystemFontOfSize:15];
        _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btn.frame =CGRectMake(0, 0, SCREEN_WIDTH, 70);
        [item addSubview:_title];
        [item addSubview:_btn];
        [self addSubview:item];
    }
    return self;
}



@end
