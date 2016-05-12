//
//  ReasonCell.h
//  QinQingBao
//
//  Created by shi on 16/4/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReasonCell : UITableViewCell

@property(copy,nonatomic)NSString *content;        //cell 内容

@property(assign,nonatomic,readonly)CGFloat cellHeight;

-(instancetype)createReasonCellWithTableView:(UITableView *)tableview;

@end
