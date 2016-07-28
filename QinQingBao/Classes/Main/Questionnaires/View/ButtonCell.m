//
//  ButtonCell.m
//  Healthy
//
//  Created by shi on 16/7/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 7.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f].CGColor;
    self.titleLb.textColor = [UIColor darkTextColor];
}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderColor = [UIColor colorWithRed:247/255.0f green:147/255.0f blue:30/255.0f alpha:1.0f].CGColor;
        self.titleLb.textColor = [UIColor colorWithRed:247/255.0f green:147/255.0f blue:30/255.0f alpha:1.0f];
    }else{
        self.layer.borderColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f].CGColor;
        self.titleLb.textColor = [UIColor darkTextColor];
    }
}

@end
