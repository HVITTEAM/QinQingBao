//
//  RefundContentCell.h
//  QinQingBao
//
//  Created by shi on 16/2/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundContentCell : UITableViewCell

@property(copy,nonatomic)NSString *titleStr;

@property(copy,nonatomic)NSString *contentStr;

@property(assign,nonatomic,readonly)CGFloat cellHeight;

-(void)setupCell;

@end
