//
//  MyTableViewCell.m
//  washcar
//
//  Created by CSB on 16/1/22.
//  Copyright © 2016年 CSB. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

@end
