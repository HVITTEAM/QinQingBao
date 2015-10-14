//
//  TipsView.h
//  VideoGo
//
//  Created by yudan on 13-4-11.
//
//

#import <UIKit/UIKit.h>

@interface TipsView : UIView
{
    UILabel           *_tipsLab;
    
}


/** @fn     InitView
 *  @brief  视图初始化
 *  @param  NULL
 *  @return NULL
 *  @time   2013-04-07
 */
- (void)InitView;

/** @fn     ShowTips
 *  @brief  提示信息显示
 *  @param  strTips:文本提示信息
 *  @return NULL
 *  @time   2013-04-11
 */
- (void)ShowTips:(NSString *)strTips;

/** @fn     ShowTips
 *  @brief  提示信息显示,自动隐藏
 *  @param  strTips:文本提示信息
 *  @return NULL
 *  @time   2013-04-11
 */
- (void)ShowTipsAutoHide:(NSString *)strTips;

/** @fn     LayoutView
 *  @brief  子窗口布局
 *  @param  void
 *  @return NULL
 *  @time   2013-04-11
 */
- (void)LayoutView;


@end
