//
//  RealView.h
//  VideoGo
//
//  Created by yudan on 14-5-20.
//
//

#import <UIKit/UIKit.h>

#import "TipsView.h"


// realView的行为事件名称
typedef enum _REALVIEW_EVENT
{
    REALVIEW_EVENT_PLAYBTNTOUCHUPINSIDE = 0,
    REALVIEW_EVENT_STOPBTNTOUCHUPINSIDE,
    REALVIEW_EVENT_ONETAPVIEW,                           // 画面单击事件
    REALVIEW_EVENT_THUMBNAILTOUCH,                       // 缩略图点击事件  
    REALVIEW_EVENT_ZOOMUP,                               // 视频画面放大
    REALVIEW_EVENT_ZOOMOFF,                              // 视频画面还原
}REALVIEW_EVENT;


@interface RealView : UIView
{
    UIView                *_playView;          // 播放视图
    UIScrollView          *_playBgView;        // 播放背景视图，用于放大
    TipsView              *_tipsView;          // 文字提示窗口
    UIButton              *_playBtn;           // 播放按钮/重试按钮
    UIView                *_stopBarView;       // 工具栏
    UILabel               *_fluxLab;           // 流量统计提示
    UIView                *_recordView;        // 录像视图
    UILabel               *_timeLab;           // 时间信息
    UIImageView           *_recordTipsView;    // 录像提示标示
    
    float                  _fVideoRate;        // 预览视图比例
    
    NSMutableArray        *_arrRealViewEvent;  // 预览视图行为事件表
    NSMutableDictionary   *_realViewEventDict; // 预览视图行为-事件表
    
}

@property (nonatomic, retain) UIView * stopBarView;
@property (nonatomic, retain) UILabel * fluxLab;
@property (nonatomic, assign) float fVideoRate;

@property (nonatomic, copy) void (^changeVideoQualityClick)(NSInteger type);


@property (nonatomic, copy) void (^changeVoiceClick)(BOOL ison);

@property (nonatomic, copy) void (^changeFullClick)(BOOL ison);

@property (nonatomic, retain) UIButton *fullScreenBtn;





/**
 *  重置预览视图
 */
- (void)layoutView;

/**
 *  获取播放窗口
 *
 *  @return 窗口
 */
- (UIView *)playHandle;

/**
 *  开始播放
 */
- (void)startPlay;

/**
 *  播放成功
 */
- (void)playSuccess;

/**
 *  停止播放
 */
- (void)stopPlay;

/**
 *  播放失败
 *
 *  @param errorCode 错误码
 */
- (void)playFailed:(int)errorCode;

/**
 *  显示重连提示
 */
- (void)ShowReConnectTips;


/**
 *  显示设备不在线提示
 */
- (void)ShowOfflineTips;

/**
 *  显示没有权限的提示
 */
- (void)showNoPermissionTips;

/**
 *  显示缩略图
 *
 *  @param path 路径
 *  @param type 缩略图类型  
 */
- (void)showThumbnail:(NSString *)path andThumbType:(int)type;

/**
 *  预览视图放大使能
 *
 *  @param bEnable YES允许 NO禁止
 */
- (void)enableZoomView:(BOOL)bEnable;

/**
 *  开始录像
 */
- (void)startRecording;

/**
 *  结束录像
 */
- (void)stopRecording;

/**
 *  添加realView的行为时间响应
 *
 *  @param target 载体
 *  @param action 动作
 *  @param event  名称
 */
- (void)addTarget:(id)target action:(SEL)action forEventEX:(REALVIEW_EVENT)event;

@end


@interface actionEvent:NSObject


@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) REALVIEW_EVENT realEvent;

@end
