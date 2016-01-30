//
//  DiscountCell.h
//  QinQingBao
//
//  Created by shi on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupbuyMode;

@protocol DiscountCellDelegate;

@interface DiscountCell : UITableViewCell

@property(copy,nonatomic)NSString *intermediateImageUrl;   

@property(strong,nonatomic)NSMutableArray *goodsDatas;             //商品数据数组

@property (copy, nonatomic)NSString *hours;                //小时

@property (copy, nonatomic)NSString *minutes;             //分钟

@property (copy, nonatomic)NSString *seconds;             //秒

@property(weak,nonatomic)id<DiscountCellDelegate>delegate;

/**
 *  创建一个 DiscountCell(优惠专区)
 */
-(DiscountCell *)initDiscountCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx;

@end

////////////////////////////////////////////////////////////////////

@protocol DiscountCellDelegate <NSObject>

/**
 *  选中商品时回调
 */
-(void)discountCell:(DiscountCell *)cell goodsModel:(GroupbuyMode *)groupbuyMode;

/**
 *  更多按钮被点击时回调
 */
-(void)discountCell:(DiscountCell *)cell moreBtnClicked:(UIButton *)moreBtn;

@end