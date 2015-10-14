//
//  RecordingBtnView.h
//  VideoGo
//
//  Created by yudan on 14-5-23.
//
//

#import <UIKit/UIKit.h>

@interface RecordingBtnView : UIView


/**
 *  添加按钮点击事件响应
 *
 *  @param target
 */
- (void)addBtnClickEvent:(id)target sel:(SEL)action;

/**
 *  开始录像
 */
- (void)startRecording;

/**
 *  停止录像
 */
- (void)stopRecording;

/**
 *  视图按钮有效使能
 *
 *  @param bEnable
 */
- (void)enableBtn:(BOOL)bEnable;

/**
 *  设置停止录像按钮图片
 *
 *  @param
 */
- (void)setButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage;

/**
 *  设置开始录像按钮图片
 *
 *  @param
 */
- (void)setRecordingButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage;
@end
