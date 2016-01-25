//
//  InfoViewCell.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewCell : UITableViewCell

/**
 *  创建一个 InfoViewCell(症状简介 cell)    /content为症状内容
 */
-(InfoViewCell *)initInfoViewCellWithContent:(NSString *)content
                                   tableView:(UITableView *)tableView
                                   indexpath:(NSIndexPath *)idx;

/**
 *  获取行高    /content为症状内容
 */
-(CGFloat)getCellHeightWithContent:(NSString *)contentStr tableView:(UITableView *)tableView;

@end
