//
//  CPlaybackController.h
//  VideoGo
//
//  Created by System Administrator on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_RECORDERVIEW                        0x0010

#define RECORDERVIEW_START                      15                              // 绘制录像视图起始位置，以便滑块显示全

#define kTableViewCellViewTag                   10001
#define kTableViewBgImageTag                    10002
#define kTableViewPlayBtnTag                    10003

// 竖屏
#define FRAME_PLAYBACKVIEW_NAVIGATION           CGRectMake(0, 20, SCREEN_W, 44)   // 导航条

#define FRAME_RECORDERVIEW                      CGRectMake(0, 352, SCREEN_W, 77)
#define FRAME_RECSUPVIEW                        CGRectMake(RECORDERVIEW_START, 53, SCREEN_W - 2*RECORDERVIEW_START, 16)
#define FRAME_TIMEPICKER                        CGRectMake(0, 224, 320, 256)
#define FRAME_TIMEPICKER_HID                    CGRectMake(0, 480, 320, 256)
#define FRAEM_SLIDE                             CGRectMake(RECORDERVIEW_START, 20, SCREEN_W - 2*RECORDERVIEW_START, 57)//24,53

#define W_TIMESCREEN                            297.93f                         // 297.93 =  (24 *3600)/(320-15*2)

#define FRAME_PLAYBACKVIEW_TOOLBAR              CGRectMake(0, 429, SCREEN_W, 51)// 工具条
#define FRAME_PLAYBACKVIEW_STOPBTN              CGRectMake(22, 8, 51, 34)       // 停止按钮
#define FRAME_PLAYBACKVIEW_CAPTUREBTN           CGRectMake(96, 8, 51, 34)       // 抓图
#define FRAEM_PLAYBACKVIEW_RECORDBTN            CGRectMake(170, 8, 51, 34)      // 录像
#define FRAME_PLAYBACKVIEW_SOUNDCTRLBTN         CGRectMake(244, 8, 51, 34)      // 声音控制按钮
#define FRAME_PLAYBACKVIEW_ALARMVEDIO           CGRectMake(500, 8, 51, 34)      // 报警视频列表,  意在隐藏此按钮  
#define FRAME_ALARMLIST_VIEW                    CGRectMake(0, SCREEN_H-112, SCREEN_W, 112)  // 报警信息list视图
#define FRAME_ALARMLIST_VIEW_BG                 CGRectMake(0, 0, SCREEN_W, 112) //报警视图背景
#define FRAME_ALARMLIST_TABLEVIEW               CGRectMake(0, 49, SCREEN_W, 63) // 报警tableview list

// 横屏
#define FRAME_FS_PLAYBACKVIEW_NAVIGATION        CGRectMake(0, 20, SCREEN_H, 34) // 导航条

#define FRAME_FS_RECORDERVIEW                   CGRectMake(0, 205, SCREEN_H, 77)
#define FRAME_FS_TIMELAB                        CGRectMake(0, 0, 80, 20)
#define FRAME_FS_RECSUPVIEW                     CGRectMake(RECORDERVIEW_START, 53, SCREEN_H - 2*RECORDERVIEW_START, 16)
#define FRAME_FS_PLAYBACKVIEW                   CGRectMake(0, 0, SCREEN_H, SCREEN_W)
#define FRAME_FS_TIMEPICKER                     CGRectMake(0, 64, 480, 256)
#define FRAME_FS_TIMEPICKER_HID                 CGRectMake(0, 320, 480, 256)
#define FRAEM_FS_SLIDE                          CGRectMake(RECORDERVIEW_START, 20, SCREEN_H - 2*RECORDERVIEW_START, 57)//24,53
#define W_FS_TIMESCREEN                         192.00f                         // 192.0 = (24 *3600)/(480-15*2)

#define FRAME_FS_PLAYBACKVIE_TOOLBAR            CGRectMake(0, 282, SCREEN_H, 38)// 工具条
#define FRAME_FS_PLAYBACKVIEW_STOPBTN           CGRectMake(107, 0, 34, 38)      // 停止按钮
#define FRAME_FS_PLAYBACKVIEW_CAPTUREBTN        CGRectMake(181, 0, 34, 38)      // 抓图
#define FRAEM_FS_PLAYBACKVIEW_RECORDBTN         CGRectMake(255, 0, 34, 38)      // 录像
#define FRAME_FS_PLAYBACKVIEW_SOUNDCTRLBTN      CGRectMake(329, 0, 34, 38)      // 声音控制按钮
#define RRAME_FS_PLAYBACKVIEW_ALARMVEDIO        CGRectMake(800, 0, 34, 38)      // 报警视频列表，意在隐藏此按钮  
#define FRAME_FS_ALARMLIST_VIEW                 CGRectMake(0, SCREEN_W-102, SCREEN_H, 102)  // 报警信息list视图
#define FRAME_FS_ALARMLIST_VIEW_BG              CGRectMake(0, 0, SCREEN_H, 102) //报警视图背景图  
#define FRAME_FS_ALARMLIST_TABLEVIEW            CGRectMake(0, 39, 480, 63) // 报警tableview list

//tableView
#define FRAME_TABLEVIEW_CELLVIEW                CGRectMake(0, 0, 86, 63)        // table cell背景view
#define FRAME_TABLEVIEW_IMAGE                   CGRectMake(1, 0, 84, 63)        // table cell背景图
#define FRAME_TABLEVIEW_BUTTON                  CGRectMake(26, 15.5, 32, 32)    // table cell播放按钮


@class YSCameraInfo;

@interface CPlaybackController : UIViewController
{
    IBOutlet UIImageView            *m_naviBgImgView;
    IBOutlet UIButton               *m_backBtn;
    IBOutlet UIButton               *m_datePickerBtn;
    IBOutlet UIButton               *m_localPlayBtn;
    
    NSArray                         *m_arrAlarmInfo;                            // 报警信息数组
    BOOL                            m_bAlarmListShow;                           // 报警信息列表显示标志位
    
    NSString                        *m_sCurDay;                                 // 当前所选日期（天)
    
    
    BOOL                            m_bFullScreen;
    
    BOOL                            m_bStopedByEnterBG;                         // 因为进入后台而关闭 yes 手动关闭 no
    NSString                        *m_strAlarmPlayTime;                      // 当前播放时间
    
    NSTimeInterval         _fSearchStartTime;                                   // 搜索开始时间
    NSTimeInterval         _fSearchStopTime;                                    // 搜索结束时间
    NSTimeInterval         _fPlayStartTime;                                     // 播放开始时间
    NSTimeInterval         _fPlayStopTime;                                      // 播放结束时间
}

@property (strong, nonatomic) UILabel           *m_curTimeLab;
@property                     BOOL              m_bFullScreen;
@property (strong, nonatomic) NSString        *m_sCurDay;
@property (nonatomic) BOOL              m_bStopedByEnterBG;
//@property (retain, nonatomic) IBOutlet UIView   *m_navigationView;              //使用导航栏来判断全屏状态下当前控件是否显示
@property (nonatomic)         BOOL              m_bAlarmListShow;
@property (nonatomic, copy)   NSString          *m_strAlarmPlayTime;
@property (nonatomic, strong) UIDatePicker      *m_datePicker;
@property (nonatomic) NSTimeInterval    fSearchStartTime;
@property (nonatomic) NSTimeInterval    fSearchStopTime;
@property (nonatomic) NSTimeInterval    fPlayStartTime;
@property (nonatomic) NSTimeInterval    fPlayStopTime;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               camera:(YSCameraInfo *)ci;


@end
