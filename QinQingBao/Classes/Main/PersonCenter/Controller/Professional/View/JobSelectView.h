//
//  JobSelectView.h
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertModel.h"

@interface JobSelectView : UIControl

@property (copy) void(^selectCompleteCallBack)(ExpertModel *item);

/**
 *  创建一个View,并显示
 *
 *  @param datas 数组,成员为ExpertModel
 */
+ (instancetype)showJobSelectViewWithdatas:(NSArray *)datas;

/**
 *  隐藏View
 */
- (void)hideView;

@end
