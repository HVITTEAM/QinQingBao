//
//  ThumbBtnView.h
//  VideoGo
//
//  Created by yudan on 14-5-30.
//
//

#import <UIKit/UIKit.h>

@interface ThumbBtnView : UIView


/**
 *  按钮点击事件
 *
 *  @param target
 *  @param action 按钮点击事件响应函数
 */
- (void)addTarget:(id)target touchAction:(SEL)action;

/**
 *  显示图片
 *
 *  @param strPath 图片路径
 */
- (void)showImage:(NSString *)strPath andWaterImg:(NSString *)strWater;


@end

