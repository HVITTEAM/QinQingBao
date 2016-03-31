//
//  EvaluateCell.h
//  QinQingBao
//
//  Created by shi on 16/3/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaluateCellDelegate;

@interface EvaluateCell : UITableViewCell

@property(weak,nonatomic)id<EvaluateCellDelegate>delegate;

/**
 *  获取EvaluateCell
 */
+(instancetype)createEvaluateCellWithTableView:(UITableView *)tableview;

@end

@protocol EvaluateCellDelegate <NSObject>

/**
 *  评分后回调
 */
-(void)evaluateCell:(EvaluateCell *)cell evaluateScore:(NSInteger)score;

/**
 *  评价内容发生变化后回调
 */
-(void)evaluateCell:(EvaluateCell *)cell didEvaluateContentChange:(NSString *)newContent;

@end