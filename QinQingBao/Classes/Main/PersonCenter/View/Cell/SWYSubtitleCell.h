//
//  SWYSubtitleCell.h
//  QinQingBao
//
//  Created by shi on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWYSubtitleCell : UITableViewCell

@property(assign,nonatomic)BOOL showCorner;            //是否显示圆型图片

+(instancetype)createSWYSubtitleCellWithTableView:(UITableView *)tableView;

@end
