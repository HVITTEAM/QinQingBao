//
//  CPlaybackController.m
//  VideoGo
//
//  Created by System Administrator on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 * 历史纪录 
 * 将recordview 改成imageview
 * 2012-11-5
 * by cmy
 */

#import "CPlaybackController.h"
#import "CTimeBarPanel.h"
#import "YSLinearButtonListView.h"
#import "YSCameraInfo.h"
#import "YSPlayerController.h"
#import "YSDemoDataModel.h"
#import "CAttention.h"

#import <CoreMotion/CoreMotion.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>



#define         kFirstView  0x1004

// 竖屏
#define FRAME_PLAYWINDOWVIEW                    CGRectMake(0, 64, SCREEN_W, SCREEN_H-174)       // 174=20+2*44+66
#define FRAME_PLAYVIEW                          CGRectMake(1.0, (SCREEN_H-174-293)/2, SCREEN_W-2.0, 293.0) // 441=SCREEN_H-20-2*44-66-293
#define FRAME_TIMEBAR                           CGRectMake(0.0, SCREEN_H-110, SCREEN_W, 66.0)

#define FRAME_SHADOW                            CGRectMake(0, 64, SCREEN_W, SCREEN_H - 324) // 324=260+44+20
#define FRAME_SHADOW_HID                        CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H - 324)
#define FRAME_PICKER                            CGRectMake(0, SCREEN_H-260, SCREEN_W, 260)
#define FRAME_PICKER_HID                        CGRectMake(0, SCREEN_H, SCREEN_W, 260)

// 横屏
#define FRAME_FS_BG                             CGRectMake(0, 0, SCREEN_H, SCREEN_W)           // 横屏背景框
#define FRAME_FS_TIMEBAR                        CGRectMake(70.0, 0.0, 219.0, 52.0)
#define FRAME_FS_TOOLBAR                        CGRectMake((SCREEN_H-475.0)/2, 245.0, 475.0, 52.0)
#define FRAME_FS_TOOLBAR_HID                    CGRectMake((SCREEN_H-475.0)/2, SCREEN_W, 475.0, 52.0)
#define FRAME_TIME_BAR                          CGRectMake(0, SCREEN_H - 110, SCREEN_W, 60)
#define FRAME_TIME_BAR_FULLSCREEN               CGRectMake(0, 222, 480, 60)

#define ALERT_VIEW_TAG_SAFEMODE                     300
#define RETRY_CLOUD_RECORD_PASSWORD_ALERT_TAG       301



#define LOADING_VIEW_PORTRAIT_HEIGHT                240


BOOL   g_isScrollTimeBar = NO;                                                  // 是否需要获取更多录像 只有手动滑的时候需要

const CGFloat topForSubview = 0;
const CGFloat timeBarVerticalHeight = 80.0;
const CGFloat timeBarHorizontalHeight = 80.0; //115.0;
//const CGFloat playingViewDefaultHeight = 240.0;
const CGFloat buttonListViewHeight = 65.0;

// 私有方法
@interface CPlaybackController() <CTimeBarDelegate, YSLinearButtonListViewDelegate, YSPlayerControllerDelegate>
{
    BOOL recoverAudioFromLocal;   // 标识从本地图像返回是否需要打开声音
    BOOL m_bKeyboardOpen;   // 键盘是否打开标示
    BOOL _bKeepPlayByDisAppear;  // 转到其他页面时是否保持播放状态
    
    NSDate *_dateEnter;
    NSDate *_dateLeave;
    
    UIButton      *btnNext;                                                     // 第一引导页上的按钮
    
    BOOL                   _bNeedStartPlay;    
    BOOL                   _bPause;                                             // 是否暂停
    BOOL                   _bAudio;                                             // 是否开始播放声音
    BOOL                   _bMsgShow;                                           // 是否在展示消息列表
    BOOL                   _bFullScreen;                                        // 是否全屏
    BOOL                   _bRecord;                                            // 是否在录像

    NSTimeInterval         _fPlayCurrentTime;                                   // 如果正在播放，当前时间
    
    BOOL _isBack;                           // 用户是否操作返回
    NSTimer *_timer;
    
    CGFloat sizeWidth;
}

@property (nonatomic, strong) UIView *playingView;
@property (nonatomic, strong) CTimeBarPanel      *timeBar;
@property (nonatomic, strong) CTimeBarPanel      *fullScreenTimeBar;
@property (nonatomic, strong) YSLinearButtonListView *buttonListView;

@property (strong, nonatomic) NSDate            *dateEnter;
@property (strong, nonatomic) NSDate            *dateLeave;
@property (nonatomic) long               alarmTimeRange;
@property (nonatomic) BOOL appStatusBarHidden;
@property (nonatomic) BOOL       shouldRestoreVideoByViewVisible;       // 是否需要恢复视频播放
@property (nonatomic) BOOL       shouldRestoreVideo;                    // 是否需要恢复视频播放
@property (nonatomic, assign) NSUInteger  recordsCount;                         // 记录查询到的录像文件数

@property (nonatomic, strong) YSCameraInfo *cameraInfo;

@property (nonatomic, strong) YSPlayerController *playerController;
@property (nonatomic, copy) NSString *recordSafeKey;

@end

@implementation CPlaybackController

@synthesize m_curTimeLab;
@synthesize m_bFullScreen;
@synthesize m_sCurDay;
@synthesize m_bStopedByEnterBG;
@synthesize m_bAlarmListShow;
@synthesize dateEnter = _dateEnter;
@synthesize dateLeave = _dateLeave;
@synthesize m_strAlarmPlayTime;
@synthesize alarmTimeRange;
@synthesize m_datePicker;

@synthesize timeBar;
@synthesize fullScreenTimeBar;
@synthesize shouldRestoreVideo;
@synthesize recordsCount;
@synthesize fSearchStartTime, fSearchStopTime, fPlayStopTime;
@synthesize fPlayStartTime = _fPlayStartTime;


// Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil camera:(YSCameraInfo *)ci
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _cameraInfo = ci;
        m_bAlarmListShow = NO;
        _dateEnter = nil;
        _dateLeave = nil;
        _bNeedStartPlay = NO;
        _bKeepPlayByDisAppear = NO;
        _recordSafeKey = nil;

        [self addNotifications];
    }
    return self;
}

// dealloc
- (void)dealloc 
{
    [self finishPlaybackTask];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView * view = (UIView *)[window viewWithTag:kFirstView];
    if (view != nil)
    {
        [view removeFromSuperview];
    }
    
    [_timer invalidate];
    _timer = nil;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
// Didload
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sizeWidth = [UIScreen mainScreen].bounds.size.width;
    
    g_lRealTotleFlux      = 0;
    g_lStreamDataTipRate  = 0;
    m_bFullScreen   = NO;
    self.wantsFullScreenLayout = YES;
    _isBack = NO;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    recoverAudioFromLocal = NO;
    
    _bPause = YES;
    
    CGFloat y = topForSubview;
    
    if (IS_IOS7_OR_LATER)
    {
        y = 64;
    }
    else
    {
        y = 0;
    }
    
    // 添加播放窗口
    UIView *pbView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              y,
                                                              sizeWidth,
                                                              sizeWidth/320.0 * 180.0)];
    [pbView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:pbView];
    self.playingView = pbView;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    // 添加操作控制工具栏
    y += sizeWidth/320.0 * 180.0 + 20;
    
    YSLinearButtonListView *lv = [[YSLinearButtonListView alloc] initWithFrame:CGRectMake(0,
                                                                                          y,
                                                                                          sizeWidth,
                                                                                          buttonListViewHeight)
                                                                layoutVertical:YES];
    lv.myDelegate = self;
    [lv enableListButtons:NO];
    self.buttonListView = lv;
    [self.view addSubview:lv];
    
    // 添加播放时间轴
    CGRect frame = CGRectMake(0,
                              screenSize.height - timeBarVerticalHeight,
                              sizeWidth,
                              timeBarVerticalHeight);
    CTimeBarPanel *tbp = [[CTimeBarPanel alloc] initWithFrame:frame bFullScreen:NO];
    tbp.delegate = self;
    [self.view addSubview:tbp];
    self.timeBar = tbp;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString *strStartTime = [formatter stringFromDate:date];
    NSDate   *startTime    = [formatter dateFromString:strStartTime];
    m_sCurDay = [formatter stringFromDate:date];
    NSTimeInterval fStartTime = [startTime timeIntervalSince1970];
    NSTimeInterval fStopTime  = fStartTime + 23 * 3600.0 + 59 * 60 + 59;
    _fSearchStartTime = fStartTime;
    _fSearchStopTime  = fStopTime;
    _fPlayStopTime    = fStopTime;
    if (0 == _fPlayStartTime)
    {
        _fPlayStartTime   = fStartTime;
    }
	[m_datePickerBtn setTitle:[m_sCurDay substringToIndex:10] forState:UIControlStateNormal];
    
    // 创建滑动条上的时间标签
    [m_curTimeLab setBackgroundColor:UIColorFromRGB(0xF7F7F7, 1.0)];
    CALayer *layer = m_curTimeLab.layer;
    layer.borderWidth = 0.5f;
    layer.cornerRadius = 9;
    [layer setMasksToBounds:YES];
    [m_curTimeLab setText:@"00:00:00"];
    [m_curTimeLab setTextColor:[UIColor redColor]];

    
    //注册键盘监听事件
    m_bKeyboardOpen = NO;
    
 
    
    _bNeedStartPlay = YES;
    
    _playerController = [[YSPlayerController alloc] initWithDelegate:self];
    
    [self startSearchFile:fStartTime andStopTime:fStopTime];
        
    _appStatusBarHidden = NO;
}

- (CGFloat)navBarHeight
{
    return 44;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self willRotateToInterfaceOrientation:orientation duration:0.3f];
    
    [self restorePlayBackViewBecomVisible];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView * view = (UIView *)[window viewWithTag:kFirstView];
    if (view != nil)
    {
        view.hidden = NO;
    }
    
    [self.timeBar setTimeBarDate:m_sCurDay];
    [self.fullScreenTimeBar setTimeBarDate:m_sCurDay];

    
    _bKeepPlayByDisAppear = NO;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView * view = (UIView *)[window viewWithTag:kFirstView];
    if (view != nil)
    {
        view.hidden = YES;
    }
    
    if (!_bKeepPlayByDisAppear)
    {
        [self stopPlayBackViewBecomeInvisible];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return _appStatusBarHidden;
}


- (void)keyboardDidShow
{
    m_bKeyboardOpen = YES;
}

- (void)keyboardWillHidden
{
    m_bKeyboardOpen = NO;
}


#pragma mark - Btn envent handle

// 按钮事件响应
- (IBAction)onCliceBackBtn:(id)sender
{
    _isBack = YES;
    
    // 释放其他的资源对象
    [self releaseResource];
    
    [self finishPlaybackTask];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickDatePickerBtn:(id)sender
{

}

#pragma mark - YSLinearButtonListViewDelegate

- (void)buttonListView:(YSLinearButtonListView *)view didSelectButton:(UIView *)button
{
    if (view.layoutVertical)
    {
        if (0 == button.tag)
        {
            [self onClickPauseBtn:nil];
        }
        else if (1 == button.tag)
        {
        }
    }
    
}

- (void)setFullScreenTimeBarHidden:(BOOL)hidden
{
    if (hidden)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        CGRect frame = CGRectMake(0,
                                  sizeWidth - timeBarHorizontalHeight,
                                  gfScreenHeight,
                                  timeBarHorizontalHeight);
        [self.fullScreenTimeBar setFrame:frame];
        frame = CGRectMake(0,
                           sizeWidth - timeBarHorizontalHeight - buttonListViewHeight,
                           gfScreenHeight,
                           buttonListViewHeight);
        [_buttonListView setFrame:frame];
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        CGRect frame = CGRectMake(0,
                                  sizeWidth,
                                  gfScreenHeight,
                                  timeBarHorizontalHeight);
        [self.fullScreenTimeBar setFrame:frame];
        frame = CGRectMake(0,
                           sizeWidth - buttonListViewHeight,
                           gfScreenHeight,
                           buttonListViewHeight);
        [_buttonListView setFrame:frame];
        [UIView commitAnimations];
        
        [_buttonListView resetAccessoryButtonImage];
    }
    
    fullScreenTimeBar.hidden = !hidden;
}

// 按钮点击事件响应 button on tool bar
- (IBAction)onClickPauseBtn:(id)sender
{
    if (!_bPause)
    {
        [_playerController pausePlayback];
    }
    else
    {
        [_playerController resumePlayback];
    }

}


#pragma mark - Business logical

/*
 * 注册通知
 */
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardDidShow)
                                                 name: UIKeyboardDidShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillHidden)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackNeedRestore)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackNeedStop)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealPlayBackStreamDataCallBackNotify:)
                                                 name:NOTIFICATION_PB_DATA_FINISHED_CALLBACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopPlaybackNotify:)
                                                 name:NOTIFICATION_PB_STOP_PLAYING
                                               object:nil];

}

/*
 * 程序进入后台停止回放
 */
- (void)playbackNeedStop
{    
    [self finishPlaybackTask];
}

/*
 * 程序回到前台继续回放
 */
- (void)playbackNeedRestore
{
    
    if (self.shouldRestoreVideo)
    {
        self.shouldRestoreVideo = NO;
        _fPlayStartTime = _fPlayCurrentTime;
        _bNeedStartPlay = YES;
        [self startPlayBack];
    }
}

/*
 * 退出当前页停止回放
 */
- (void)stopPlayBackViewBecomeInvisible
{
    if (!_bPause)
    {
        self.shouldRestoreVideoByViewVisible = YES;
    }
    
    [self finishPlaybackTask];
}

/*
 * 恢复当前页继续回放
 */
- (void)restorePlayBackViewBecomVisible
{
    
    if (self.shouldRestoreVideoByViewVisible)
    {
        self.shouldRestoreVideoByViewVisible = NO;
        _fPlayStartTime = _fPlayCurrentTime;
        _bNeedStartPlay = YES;
        [self startPlayBack];
    }
}


- (void)dealPlayBackStreamDataCallBackNotify:(NSNotification *)notify
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self finishPlaybackTask];
    });
}

- (void)stopPlaybackNotify:(NSNotification *)notification
{
    [self finishPlaybackTask];
}

- (void)finishPlaybackTask
{
    [_playerController stopPlayback];
}

/**
 *	@brief	更新搜索和播放时间
 *
 *	@param 	date 	需要更新的时间
 */
- (void)updatePlaybackTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strStartTime = [formatter stringFromDate:date];
    NSDate *startTime = [formatter dateFromString:strStartTime];
    NSTimeInterval fStartTime = [startTime timeIntervalSince1970];
    NSTimeInterval fStopTime = fStartTime + 23 * 3600.0 + 59 * 60 + 59;

    _fSearchStartTime = fStartTime;
    _fSearchStopTime  = fStopTime;
    _fPlayStartTime   = fStartTime;
    _fPlayStopTime    = fStopTime;
    
    _bNeedStartPlay = YES;
    
    [self startSearchFile:fStartTime andStopTime:fStopTime];
}

#pragma mark - Playback process

/**
 *	@brief	开始搜索录像
 *
 *	@param 	fStartTime 	开始时间
 *	@param 	fStopTime 	结束时间
 */
- (void)startSearchFile:(NSTimeInterval)fStartTime andStopTime:(NSTimeInterval)fStopTime
{
    
    [_playerController searchRecordWithCamera:_cameraInfo.cameraId
                                  accessToken:[[YSDemoDataModel sharedInstance] userAccessToken]
                                     fromTime:fStartTime
                                       toTime:fStopTime];
}

/*
 * 开始历史回放
 */
- (void)startPlayBack
{
    [_playerController startPlaybackWithCamera:_cameraInfo.cameraId
                                   accessToken:[[YSDemoDataModel sharedInstance] userAccessToken]
                                      fromTime:_fPlayStartTime
                                        toTime:_fPlayStopTime
                                        inView:_playingView];
}

/** @fn     clearRecordBar  
 *  @brief  清除录像条
 *  @param  无
 *  @return 无
 */
- (void)clearRecordBar
{
    [m_curTimeLab setText:@"00:00:00"];
    [self setPlayTimeLabFrameWithX:0.0f];
}


// Update time bar
- (void)updateProgressTimeBar:(ABSTIME *)time
{    
    // 如果当前日期和OSD日期不同，不更新进度
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startTime = [formatter dateFromString:m_sCurDay];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                   fromDate:startTime];
    
    int day = (int)[components day];
    if (day != time->day)
    {
        return;
    }
    
    [self.fullScreenTimeBar updateTimeBarTime:time];
    [self.fullScreenTimeBar updateSlider:time];
    
    [self.timeBar updateTimeBarTime:time];
    [self.timeBar updateSlider:time];
}


// 释放资源对象
- (void)releaseResource
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}


#pragma mark timeBar - delegate

- (void)timeBarStartDraggingDelegate
{
}

- (void)timeBarScrollDraggingDelegate:(ABSTIME *)sTime timeBarObj:(id)tb
{
    // 更新时间标签内容
    [self.timeBar updateTimeBarTime:sTime];
    [self.fullScreenTimeBar updateTimeBarTime:sTime];
    
    // 竖屏时，只更新横屏时间滑动条
    if (m_bFullScreen)
    {
        [self.fullScreenTimeBar updateSlider:sTime];
    }
    else
    {
        [self.timeBar updateSlider:sTime];
    }
}

- (void)timeBarStopScrollDelegate:(ABSTIME *)sTime
{
//    [self finishPlaybackTask];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startTime = [formatter dateFromString:m_sCurDay];
    NSTimeInterval fStartTime = [startTime timeIntervalSince1970] + sTime->hour * 3600.0
    + sTime->minute * 60.0 + sTime->second;
    NSTimeInterval fStopTime = [startTime timeIntervalSince1970] + 23 * 3600.0 + 59 * 60 + 59;
    _fSearchStartTime = fStartTime;
    _fSearchStopTime  = fStopTime;
    _fPlayStartTime   = fStartTime;
    _fPlayStopTime    = fStopTime;
    
    [self startPlayBack];
}

// string转ABSTIME
- (void)stringToABSTIME:(NSString *)string andABSTIME:(ABSTIME *)abstime
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateformatter dateFromString:string];
    
    dateformatter.dateFormat = @"yyyy";
    NSString *strYear = [dateformatter stringFromDate:date];
    dateformatter.dateFormat = @"MM";
    NSString *strMonth = [dateformatter stringFromDate:date];
    dateformatter.dateFormat = @"dd";
    NSString *strday = [dateformatter stringFromDate:date];
    dateformatter.dateFormat = @"HH";
    NSString *strHour = [dateformatter stringFromDate:date];
    dateformatter.dateFormat = @"mm";
    NSString *strMinute = [dateformatter stringFromDate:date];
    dateformatter.dateFormat = @"ss";
    NSString *strSecond = [dateformatter stringFromDate:date];
    
    abstime->year    = strYear.intValue;
    abstime->month   = strMonth.intValue;
    abstime->day     = strday.intValue;
    abstime->hour    = strHour.intValue;
    abstime->minute  = strMinute.intValue;
    abstime->second  = strSecond.intValue;
}

// parse RecFileInfo to RecordSegment, not all property set value
- (NSMutableArray *)parseRecordFileInfoToRecordSegment:(NSArray *)recFileInfos {
    if (0 == [recFileInfos count]) {
        return nil;
    }
    
    NSMutableArray *recordSegments = [NSMutableArray arrayWithCapacity:10];

    for (int i = 0; i < [recFileInfos count]; i++) {
        
        YSRecordInfo *ri = [recFileInfos objectAtIndex:i];
        
        RecordSegment recordSegment;
        memset(&recordSegment, 0, sizeof(recordSegment));
        
        memset(&recordSegment.beginTime, 0, sizeof(ABSTIME));
        memset(&recordSegment.endTime, 0, sizeof(ABSTIME));
        [self stringToABSTIME:ri.startTime andABSTIME:&recordSegment.beginTime];
        [self stringToABSTIME:ri.endTime andABSTIME:&recordSegment.endTime];
        recordSegment.recordType = 0;
        NSValue *valRecordSegment = [NSValue valueWithBytes:&recordSegment objCType:@encode(RecordSegment)];
        [recordSegments addObject:valRecordSegment];
    }
    
    return recordSegments;
}

#pragma mark -

/** @fn	playbackViewDelegate
 *  @brief  根据x位置设置播放时间标签frame
 *  @param  x - 时间标签位置
 *  @return 无
 */
- (void)setPlayTimeLabFrameWithX:(float)x
{
    CGRect frame = m_curTimeLab.frame;
    
    x = x + RECORDERVIEW_START;
    if (m_bFullScreen)
    {
        if (x - frame.size.width/2 < 0.0f)
        {
            x = frame.size.width/2;
        }
        
        if (x + frame.size.width/2 > gfScreenHeight)
        {
            x = gfScreenHeight - frame.size.width/2;
        }
    }
    else
    {
        if (x - frame.size.width/2 < 0.0f)
        {
            x = frame.size.width/2;
        }
        
        if (x + frame.size.width/2 > sizeWidth)
        {
            x = sizeWidth - frame.size.width/2;
        }
    }
    CGPoint center = m_curTimeLab.center;
    center.x = x;
    m_curTimeLab.center = center;
}


- (void)playerOperationMessage:(YSPlayerMessageType)msgType withValue:(id)value
{
    switch (msgType) {
        case YSPlayerMsgSearchRecordSuccess:
        {
            NSArray *records = (NSArray *)value;
            if (records) {
                self.recordsCount = [records count];
                NSMutableArray *tempArray = [self parseRecordFileInfoToRecordSegment:records];
                
                [self.timeBar cleanContentBar];
                [self.fullScreenTimeBar cleanContentBar];
                
                [self.timeBar drawContentBar:tempArray];
                [self.fullScreenTimeBar drawContentBar:tempArray];
                
                // 开始播放录像
                [self startPlayBack];

            }
            else
            {
                [CAttention showAutoHiddenAttention:NSLocalizedString(@"没有查询到录像", nil) toView:self.view];
            }
        }
            break;
        case YSPlayerMsgSearchRecordFail:
        {
            [CAttention showAutoHiddenAttention:[NSString stringWithFormat:@"查询录像失败(%d)", [value intValue]]
                                         toView:self.view];
        }
            break;
        case YSPlayerMsgPlaybackSuccess:
        {

            [_buttonListView enableListButtons:YES];
            [self startTimerToGetFrameTime];
            _bPause = NO;
        }
            break;
            case YSPlayerMsgPlaybackFail:
        {
            [CAttention showAutoHiddenAttention:[NSString stringWithFormat:@"播放录像失败(%d)", [value intValue]]
                                         toView:self.view];
        }
            break;
        case YSPlayerMsgPlaybackStop:
        {

            [_timer invalidate];
            _timer = nil;
            
            [CAttention showAutoHiddenAttention:NSLocalizedString(@"播放结束", nil) toView:self.view];

        }
            break;
        case YSPlayerMsgPlaybackPause:
        {
            _bPause = YES;
 
            [_buttonListView setPauseButtonImage:[UIImage imageNamed:@"full_play.png"]
                                    hightedImage:[UIImage imageNamed:@"full_play_sel.png"]];
        }
            break;
        case YSPlayerMsgPlaybackResume:
        {
            _bPause = NO;
            [_buttonListView setPauseButtonImage:[UIImage imageNamed:@"full_pause.png"]
                                    hightedImage:[UIImage imageNamed:@"full_pause_sel.png"]];
        }
            break;
        default:
            break;
    }
}


- (void)startTimerToGetFrameTime
{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(doTimerTask) userInfo:nil repeats:YES];
}

- (void)doTimerTask
{
    NSTimeInterval playingTime = [_playerController currentOSDTime];
    if (0 < playingTime)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:playingTime];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateformatter stringFromDate:date];
        
        ABSTIME aTime;
        [self stringToABSTIME:strDate andABSTIME:&aTime];
        [self updateProgressTimeBar:&aTime];
    }
}

@end
