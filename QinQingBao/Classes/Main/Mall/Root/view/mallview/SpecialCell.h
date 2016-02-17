//
//  SpecialCell.h
//  QinQingBao
//
//  Created by shi on 16/2/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecialModel;

@protocol SpecialCellDelegate;

@interface SpecialCell : UITableViewCell

@property(strong,nonatomic)NSMutableArray *specialArray;              //专题列表数组

@property(copy,nonatomic)NSString *intermediateImageUrl;              //图片URL 路径的中间部分

@property(weak,nonatomic)id<SpecialCellDelegate>delegate;

-(SpecialCell *)initSpecialCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx;

@end


@protocol SpecialCellDelegate <NSObject>

/**
 *  专题图片被点击时回调
 */
-(void)specialCell:(SpecialCell *)cell specialTappedOfModel:(SpecialModel *)specialmodel;

@end