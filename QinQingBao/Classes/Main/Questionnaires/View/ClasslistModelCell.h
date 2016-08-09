//
//  ClasslistModelCell.h
//  QinQingBao
//
//  Created by shi on 16/8/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClasslistModel;

@interface ClasslistModelCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setModelWith:(ClasslistModel *)model;

@end
