//
//  YSPlayerController.h
//  EzvizRealPlay
//
//  Created by zhengwen zhu on 7/10/14.
//  Copyright (c) 2014 yudan. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    YSPlayerMsgCheckFail,                     // 用户合法性校验
    YSPlayerMsgRealPlayStart,                 // 开始视频预览
    YSPlayerMsgRealPlaySuccess,               // 预览成功
    YSPlayerMsgRealPlayChangeVideoLevel,      // 设置视频清晰度
    YSPlayerMsgRealPlayStop,                  // 停止预览
    YSPlayerMsgRealPlayDeviceOffline,         // 设备不在线
    YSPlayerMsgRealPlayNoPermission,          // 无权限
    YSPlayerMsgRealPlayReconnecting,          // 预览重连服务器
    YSPlayerMsgRealPlayFail,                  // 预览失败
    
    YSPlayerMsgIntercomException,             // 对讲异常
    YSPlayerMsgIntercomPrivate,               // 对讲时开启隐私保护
    YSPlayerMsgIntercomStopBefore,            // 对讲停止前
    YSPlayerMsgIntercomStop,                  // 对讲已停止
    
    YSPlayerMsgSearchRecordSuccess,           // 录像查询结束
    YSPlayerMsgSearchRecordFail,              // 录像查询失败
    YSPlayerMsgPlaybackSuccess,               // 回放成功
    YSPlayerMsgPlaybackFail,                  // 回放失败
    YSPlayerMsgPlaybackStop,                  // 回放停止
    YSPlayerMsgPlaybackPause,                 // 回放暂停
    YSPlayerMsgPlaybackResume,                // 回放恢复
    
    YSPlayerMsgSoundUnvailable                // 视频不支持打开声音
};
typedef NSInteger YSPlayerMessageType;

// 视频质量定义
typedef enum VideoQuality
{
    LowQuality    = 0,
    MiddleQuality = 1,
    HighQuality   = 2,
} VideoQuality;

#define NOTIFICATION_PB_DATA_FINISHED_CALLBACK            @"casDataCallback"           // 流数据回调
#define NOTIFICATION_PB_STOP_PLAYING                      @"stopPlayback"              // 回放停止

extern NSString * const kVideoLevel;                // 视频清晰度key
extern NSString * const kCurrentVideoLevel;         // 设备当前设置的视频清晰度
extern NSString * const kSupportTalk;               // 支持对讲能力
extern NSString * const kSupportPtz;

extern NSString * const kApiServer;                 // 应用服务器
extern NSString * const kAuthServer;                // 认证中心服务器

@protocol YSPlayerControllerDelegate;

@interface YSPlayerController : NSObject

@property (nonatomic, weak) id<YSPlayerControllerDelegate> delegate;

/**
 *  初始化SDK库
 *
 *  @param dict 设置服务器地址
 *              kApiServer: 设置api服务器地址key
 *              kAuthServer:设置认证中心服务器地址key
 *
 *  @since V1.0.0.0
 */
+ (void)loadSDKWithPlatfromServers:(NSDictionary *)dict;

/**
 *  释放SDK播放资源和数据缓存
 *
 *  @since v1.0.0.0
 */
+ (void)clearSDK;

/**
 *  初始化一个播放器对象
 *
 *  @param delegate 播放器代理
 *
 *  @return 播放器对象
 *
 *  @since v1.0.0.0
 */
- (id)initWithDelegate:(id<YSPlayerControllerDelegate>)delegate;

#pragma mark - Real play

/**
 *  开始设备预览
 *
 *  @param cameraId 摄像头唯一标识id
 *  @param token    用户访问令牌
 *  @param safeKey  设备加密密钥
 *  @param playView 播放窗口
 *
 *  @since v1.0.0.0
 */
- (void)startRealPlayWithCamera:(NSString *)cameraId
                    accessToken:(NSString *)token
                         inView:(UIView *)playView;

/**
 *  视频广场预览
 *
 *  @param rtspUrl  广场视频RTSP地址
 *  @param playView 播放窗口
 */
- (void)startRealPlayWithURLString:(NSString *)rtspUrl
                            inView:(UIView *)playView;

/**
 *  局域网预览
 *
 *  @param keyValue 设备验证码
 *  @param userId   用户id,设备已经注册平台时填写
 *  @param ip       设备ip
 *  @param playView 视频view
 */
- (void)startLocalRealPayWithKey:(NSString *)keyValue
                          userId:(NSString *)userId
                              ip:(NSString *)ip
                          inView:(UIView *)playView;

/**
 *  停止设备预览
 *
 *  @since v1.0.0.0
 */
- (void)stopRealPlay;

/**
 *  设置设备预览的分辨率
 *
 *  @param cid   摄像头唯一标识id
 *  @param level 清晰度值, 0 流畅, 1 均衡, 2 高清
 *
 *  @since v1.0.0.0
 */
- (void)changeRealPlayVideoLevelWithCameraId:(NSString *)cid
                                  videoLevel:(NSInteger)level;

/**
 *  音频控制接口
 *
 *  @param opened yes 打开声音, no 关闭声音
 *
 *  @return 是否设置成功
 *
 *  @since v1.1.0.0
 */
- (BOOL)setAudioOpen:(BOOL)opened;

/**
 *  预览抓图
 *
 *  @param imagePath 图片保存的路径
 *
 *  @return 抓图是否成功
 *
 *  @since v1.1.0.0
 */
- (BOOL)captureWithPath:(NSString *)imagePath;

/**
 *  预览录像
 *
 *  @param recordPath 录像保存路径
 *  @param imagePath  图片保存路径
 *
 *  @return 录像是否成功
 *
 *  @since v1.1.0.0
 */
- (BOOL)startRecordWithRecordPath:(NSString *)recordPath capturePath:(NSString *)imagePath;

/**
 *  停止录像
 *
 *  @return 停止是否成功
 *
 *  @since v1.1.0.0
 */
- (BOOL)stopRecord;

/**
 *  开始对讲
 *
 *  @param bDenosing 是否使用消噪话筒
 *
 *  @return YES成功 NO失败
 */
- (BOOL)startIntercom:(BOOL)bDenosing;

/**
 *  停止对讲
 *
 *  @return YES成功 NO失败
 */
- (BOOL)stopIntercom;

/**
 *  当前是否正在进行对讲
 *
 *  @return YES 对讲开启 NO 对讲关闭
 */
- (BOOL)isIntercom;

/**
 *  对讲采集自己声音
 *
 *  @return YES成功 NO失败
 */
- (BOOL)intercomEnableSpeak;

/**
 *  对讲播放对方声音
 *
 *  @return YES成功 NO失败
 */
- (BOOL)intercomEnablePlay;


#pragma mark - Playback

/**
 *  搜素设备SD卡和云服务器上的录像
 *
 *  @param cameraId  摄像头唯一标识id
 *  @param token     用户访问令牌
 *  @param startTime 开始搜索时间
 *  @param endTime   结束搜索时间
 *
 *  @since v1.0.0.0
 */
- (void)searchRecordWithCamera:(NSString *)cameraId
                   accessToken:(NSString *)token
                      fromTime:(NSTimeInterval)startTime
                        toTime:(NSTimeInterval)endTime;

/**
 *  开始录像回放
 *
 *  @param cameraId  摄像头唯一标识id
 *  @param token     用户访问令牌
 *  @param safeKey   录像加密密钥
 *  @param startTime 开始播放时间
 *  @param endTime   结束播放时间
 *  @param playView  播放窗口
 *
 *  @since v1.0.0.0
 */
- (void)startPlaybackWithCamera:(NSString *)cameraId
                    accessToken:(NSString *)token
                       fromTime:(NSTimeInterval)startTime
                         toTime:(NSTimeInterval)endTime
                         inView:(UIView *)playView;

/**
 *  暂停录像回放
 *
 *  @since v1.0.0.0
 */
- (void)pausePlayback;

/**
 *  恢复录像回放
 *
 *  @since v1.0.0.0
 */
- (void)resumePlayback;

/**
 *  停止录像回放
 *
 *  @since v1.0.0.0
 */
- (void)stopPlayback;

/**
 *  录像回放的当前显示时间
 *
 *  @return osd 时间
 *
 *  @since v1.0.0.0
 */
- (NSTimeInterval)currentOSDTime;

#pragma mark - Get camera capture

/**
 *  抓取指定监控点的实时图片
 *
 *  @param idArray 监控点id集合
 */
+ (void)requestCapturesWithCameraId:(NSArray *)idArray;


#pragma mark - PTZ operation

/**
 *  ptz 控制：开始向上转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStartUpWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制：停止向上转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStopUpWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制：开始向下转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStartDownWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制： 停止向下转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStopDownWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制： 开始向左转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStartLeftWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制： 停止向左转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStopLeftWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制： 开始向右转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStartRightWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制： 停止向右转动
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzStopRightWithCamera:(NSString *)cameraId cameraNo:(NSInteger)cno;

/**
 *  ptz 控制： 翻转
 *
 *  @param cameraId 摄像头id
 *  @param cno      摄像头通道号
 */
+ (void)ptzFlipWithCamera:(NSString *)cameraId
                 cameraNo:(NSInteger)cno
                   result:(void (^)(NSInteger code))block;

@end

@protocol YSPlayerControllerDelegate <NSObject>

@required

- (void)playerOperationMessage:(YSPlayerMessageType)msgType withValue:(id)value;

@optional

- (void)realPlayDidStartedWithDict:(NSDictionary *)dict;

@end

#pragma mark - 

/**
 *  搜素录像成功后返回的录像类型
 *
 *  @since v1.0.0.0
 */
@interface YSRecordInfo : NSObject

@property (nonatomic, copy) NSString *startTime;    // 录像的开始时间
@property (nonatomic, copy) NSString *endTime;      // 录像的结束时间

@end
