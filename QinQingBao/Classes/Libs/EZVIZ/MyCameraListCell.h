//
//  MyCameraListCell.h
//  VideoGo
//
//  Created by zhengwen zhu on 10/14/13.
//
//

#import <UIKit/UIKit.h>


@protocol MyCameraListCellDelegate;

@class YSCameraInfo;

@interface MyCameraListCell : UITableViewCell
{
    YSCameraInfo                     *_cameraInfo;                  // 关联的摄像机对象
    
//    IBOutlet UIView                  *_containerView;               // 包含所有子控件的父视图
//    IBOutlet UIImageView             *_bgImageView;                 // 背景效果
//    IBOutlet UILabel                 *_cameraNameLbl;               // 摄像机名称
//    
//    IBOutlet UIView                  *_coverView;                   // 摄像机封面视图容器(封面图像, 预览按钮, 离线状态)
//    IBOutlet UIImageView            *_coverImgView;                // 摄像机封面图像
//    IBOutlet UILabel                 *_offLineLbl;                  // 显示离线状态蒙版
//    IBOutlet UIImageView             *_offLineImageView;            // 显示离线状态图片
//    IBOutlet UIButton                *_realPlayButton;              // 预览按钮
//    IBOutlet UIButton                *_playBackButton;              // 回放按钮
//    IBOutlet UIButton                *_localPlayButton;             // 本地播放按钮
//    IBOutlet UIButton                *_voiceMessageButton;          // 语音留言
//    IBOutlet UIView                  *_firstSeporatorView;          // 按钮之间的分割线
//    IBOutlet UIView                  *_secondSeporatorView;         // 按钮之间的分割线
}


@property (nonatomic, weak) IBOutlet UIButton *btnCapturePic;
@property (nonatomic, weak) IBOutlet UIButton *btnRealPlay;
@property (nonatomic, weak) IBOutlet UIButton *btnPlayback;
@property (nonatomic, weak) IBOutlet UIButton *btnSetting;
@property (nonatomic, weak) IBOutlet UIButton *btnAlarmList;
@property (nonatomic, weak) IBOutlet UILabel *lblDeviceName;
@property (nonatomic, weak) IBOutlet UIImageView *deviceScreenshot;
@property (nonatomic, weak) IBOutlet UIImageView *offlineIcon;
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id<MyCameraListCellDelegate> delegate;

- (void)setDeviceInfo:(YSCameraInfo *)info;

@end

//#pragma mark -

@protocol MyCameraListCellDelegate <NSObject>

@optional
- (void)didClickOnRealPlayButtonInCell:(YSCameraInfo *)info;
- (void)didClickOnPlayBackButtonInCell:(MyCameraListCell *)cell;
- (void)didClickOnLocalPlayButtonInCell:(MyCameraListCell *)cell;
- (void)didClickOnVoiceMessageButtonInCell:(MyCameraListCell *)cell;

- (void)didClickOnCaptureInCell:(MyCameraListCell *)cell;

@end