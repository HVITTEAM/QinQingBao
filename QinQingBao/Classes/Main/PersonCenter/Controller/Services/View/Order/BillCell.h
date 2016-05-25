//
//  BillCell.h
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//工单凭证cell

#import <UIKit/UIKit.h>
@class WorkPicModel;
@protocol BillCellDelegate;

@interface BillCell : UITableViewCell

@property(weak,nonatomic)id<BillCellDelegate>delegate;

+(instancetype)createBillCellWithTableView:(UITableView *)tableview;

-(void)setDataWithWorkPicModel:(WorkPicModel *)workPicModel;

-(CGFloat)getCellHeight;

@end


@protocol BillCellDelegate <NSObject>

-(void)BillCell:(BillCell *)cell clickedImageViewInIndex:(NSInteger)index;

@end