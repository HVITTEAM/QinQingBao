//
//  RealView.m
//  VideoGo
//
//  Created by yudan on 14-5-20.
//
//

#import "RealView.h"
#import "ThumbBtnView.h"
#import "YSCommonMethods.h"
#import "DefinitionTypeView.h"


#define  THUMBNAIL_IMAGE_WIDTH               65
#define  THUMBNAIL_IMAGE_HEIGHT              45



// 标示当前播放按钮功能
typedef enum _PLAYBTN_STATE
{
    PLAYBTN_PLAY = 2001,    // 当前播放功能
    PLAYBTN_REFRESH,        // 当前重试功能
}PLAYBTN_STATE;

@interface RealView() <UIScrollViewDelegate, UIGestureRecognizerDelegate,definitiontypeSelectedDelegate>
{
    UILabel               *_zoomSizeLab;
    ThumbBtnView          *_thumbnailBtn;
    
    NSTimer               *_timer;
    unsigned int           _nTime;
}

@property (nonatomic, retain) ThumbBtnView * thumbnailBtn;


@property (nonatomic, retain) DefinitionTypeView *definitionTypeview;
@property (nonatomic, retain) TSPopoverController *popoverController;
@end


@implementation RealView

@synthesize stopBarView = _stopBarView;
@synthesize fluxLab = _fluxLab;
@synthesize thumbnailBtn = _thumbnailBtn;


@dynamic fVideoRate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _fVideoRate = 352.0/288.0;
        
        _realViewEventDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        _arrRealViewEvent = [[NSMutableArray alloc] initWithCapacity:1];
        
        [self initView];
    }
    return self;
}

-(DefinitionTypeView *)definitionTypeview
{
    if (_definitionTypeview == nil) {
        self.definitionTypeview = [[DefinitionTypeView alloc] init];
        self.definitionTypeview.delegate = self;
    }
    return _definitionTypeview;
}

-(TSPopoverController *)popoverController
{
    if (_popoverController == nil) {
        self.popoverController = [[TSPopoverController alloc] initWithContentViewController:self.definitionTypeview];
    }
    return _popoverController;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark -
#pragma mark ui
- (void)initView
{
    CGRect rcView = self.frame;
    
    self.backgroundColor = [UIColor blackColor];
    
    // 播放视图
    _playBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rcView.size.width, rcView.size.width)];
    _playBgView.maximumZoomScale = 1.0f;
    _playBgView.minimumZoomScale = 1.0f;
    _playBgView.backgroundColor = [UIColor clearColor];
    _playBgView.delegate = self;
    _playBgView.showsHorizontalScrollIndicator = NO;
    _playBgView.showsVerticalScrollIndicator = NO;
    _playBgView.userInteractionEnabled = YES;
    _playBgView.multipleTouchEnabled = YES;
    _playBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_playBgView];
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _playBgView.frame.size.width, _playBgView.frame.size.height)];
    _playView.backgroundColor = [UIColor blackColor];
    _playView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_playBgView addSubview:_playView];
    
    // 提示视图
    _tipsView = [[TipsView alloc] initWithFrame:CGRectMake(0, 0, rcView.size.width, rcView.size.height)];
    _tipsView.backgroundColor = [UIColor clearColor];
    _tipsView.userInteractionEnabled = NO;
    _tipsView.hidden = YES;
    _tipsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_tipsView];
    
    // 播放按钮
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake((rcView.size.width - 100) / 2,
                                                          (rcView.size.height - 100) / 2,
                                                          100,
                                                          100)];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"public_play.png"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"public_play_sel.png"] forState:UIControlStateHighlighted];
    _playBtn.tag = PLAYBTN_PLAY;
    _playBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_playBtn addTarget:self action:@selector(onClickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    
    // 放大标示
    _zoomSizeLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 80, 40)];
    _zoomSizeLab.backgroundColor = [UIColor clearColor];
    _zoomSizeLab.textColor = [UIColor whiteColor];
    _zoomSizeLab.font = [UIFont systemFontOfSize:24.0f];
    _zoomSizeLab.hidden = YES;
    [self addSubview:_zoomSizeLab];
        
    // 停止、流量栏
    _stopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, rcView.size.height - 40, rcView.size.width, 40)];
    _stopBarView.backgroundColor = [UIColor clearColor];
    _stopBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_stopBarView];
    _stopBarView.hidden = YES;  
    
    UIView * barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _stopBarView.frame.size.width, _stopBarView.frame.size.height)];
    barBgView.backgroundColor = [UIColor blackColor];
    barBgView.alpha = 0.7f;
    barBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_stopBarView addSubview:barBgView];
    
    //停止
    UIButton * stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [stopBtn setBackgroundImage:[UIImage imageNamed:@"play_play.png"] forState:UIControlStateSelected];
    [stopBtn setBackgroundImage:[UIImage imageNamed:@"play_stop.png"] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(onClickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_stopBarView addSubview:stopBtn];
    
    //视频质量
    UIButton * definitionBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,8, 50, 25)];
    definitionBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    definitionBtn.layer.borderWidth = 1;
    definitionBtn.layer.cornerRadius = 4;
    definitionBtn.tag = 1001;
    [definitionBtn setTitle:@"标清" forState:UIControlStateNormal];
    [definitionBtn setTitle:@"标清" forState:UIControlStateHighlighted];
    definitionBtn.titleLabel.textColor = [UIColor whiteColor];
    definitionBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [definitionBtn addTarget:self action:@selector(definitionClickHandler:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_stopBarView addSubview:definitionBtn];
    
    //声音
    UIButton * voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 40)];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"play_play.png"] forState:UIControlStateSelected];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"play_stop.png"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(voiceStopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_stopBarView addSubview:voiceBtn];


//    _fluxLab = [[UILabel alloc] initWithFrame:CGRectMake(_stopBarView.frame.size.width - 90, 0, 90, _stopBarView.frame.size.height)];
//    _fluxLab.text = @"0K/s  0MB";
//    _fluxLab.textColor = [UIColor whiteColor];
//    _fluxLab.backgroundColor = [UIColor clearColor];
//    _fluxLab.font = [UIFont systemFontOfSize:12.0f];
//    [_stopBarView addSubview:_fluxLab];
    
    // 录像视图
    _recordView = [[UIView alloc] initWithFrame:CGRectMake(rcView.size.width - 15 - 70, 15, 70, 25)];
    _recordView.backgroundColor = [UIColor clearColor];
    [self addSubview:_recordView];
    _recordView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    _recordView.hidden = YES;
    
    UIImageView * recordBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _recordView.frame.size.width, _recordView.frame.size.height)];
    recordBgView.image = [UIImage imageNamed:@"video_time_bg.png"];
    [_recordView addSubview:recordBgView];
    
    _recordTipsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 25)];
    _recordTipsView.image = [UIImage imageNamed:@"video_record.png"];
    _recordTipsView.alpha = 1.0f;
    [_recordView addSubview:_recordTipsView];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 48, 25)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = [UIColor whiteColor];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.font = [UIFont systemFontOfSize:12.0f];
    _timeLab.text = @"00:00";
    [_recordView addSubview:_timeLab];
    
    // 手势
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapView:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
}

- (void)layoutSubviews
{
    int fLeft = 0;
    int fTop = 0;
    if (self.frame.size.width > self.frame.size.height * _fVideoRate)
    {
        fLeft = (int)((self.frame.size.width - self.frame.size.height*_fVideoRate) / 2);
    }
    else if (self.frame.size.width < self.frame.size.height*_fVideoRate)
    {
        fTop = (int)((self.frame.size.height - self.frame.size.width/_fVideoRate) / 2);
    }
    
    _playBgView.frame = CGRectMake((CGFloat)fLeft, (CGFloat)fTop, self.frame.size.width - fLeft*2, self.frame.size.height - fTop*2);
    _playBgView.contentSize = CGSizeMake(_playBgView.frame.size.width, _playBgView.frame.size.height);
    _playView.frame = CGRectMake(0, 0, _playBgView.frame.size.width, _playBgView.frame.size.height);
    
    if (_playBtn.tag == PLAYBTN_PLAY)
    {
        _playBtn.frame = CGRectMake((self.frame.size.width-100)/2, (self.frame.size.height-100)/2, 100, 100);
    }
    else
    {
        _playBtn.frame = CGRectMake((self.frame.size.width-100)/2, self.frame.size.height/2-90, 100, 100);
    }
}

#pragma mark -
#pragma mark interface methods

/**
 *  重置预览视图
 */
- (void)layoutView
{
    _playBgView.zoomScale = 1.0f;
    
    _stopBarView.hidden = YES;
}

/**
 *  获取播放窗口
 *
 *  @return 窗口
 */
- (UIView *)playHandle
{
    [_playView removeFromSuperview];
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _playBgView.frame.size.width, _playBgView.frame.size.height)];
    _playView.backgroundColor = [UIColor blackColor];
    _playView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_playBgView addSubview:_playView];
    
    return _playView;
}

/**
 *  传入视频宽高比
 *
 *  @param fVideoRate 视频比例
 */
- (void)setFVideoRate:(float)fVideoRate
{
    _fVideoRate = fVideoRate;
    
    [self layoutView];
}

/**
 *  开始播放
 */
- (void)startPlay
{
//    [_admWaitView show];
    _stopBarView.hidden = YES;
    [self showPlayBtn:0];
    _tipsView.hidden = YES;
}

/**
 *  播放成功
 */
- (void)playSuccess
{
//    [_admWaitView hide];
    _stopBarView.hidden = YES;
    [self showPlayBtn:0];
    _tipsView.hidden = YES;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    {
        [self enableZoomView:NO];
    }
    else
    {
        [self enableZoomView:YES];
    }
}

/**
 *  停止播放
 */
- (void)stopPlay
{
//    [_admWaitView hide];
//    _stopBarView.hidden = YES;
    [self showPlayBtn:1];
    _tipsView.hidden = YES;
    _zoomSizeLab.hidden = YES;
    _playBgView.zoomScale = 1.0f;
    
    [self enableZoomView:NO];
}

/**
 *  播放失败
 *
 *  @param errorCode 错误码
 */
- (void)playFailed:(int)errorCode
{
//    [_admWaitView hide];
    _stopBarView.hidden = YES;
    [self showPlayBtn:2];
    _tipsView.hidden = NO;
    
    [self enableZoomView:NO];
    
    NSString * strError = [NSString stringWithFormat:@"%@(%d)", NSLocalizedString(@"播放失败", nil), errorCode];
    
    // 提示错误
    [self ShowTips:strError];

}

/**
 *  显示重连提示
 */
- (void)ShowReConnectTips
{
//    [_admWaitView hide];
    _stopBarView.hidden = YES;
    
    // 隐藏播放按钮
    [self showPlayBtn:0];

    [self ShowTips:NSLocalizedString(@"网络不稳定, 重新连接", nil)];
}


/**
 *  显示设备不在线提示
 */
- (void)ShowOfflineTips
{
//    [_admWaitView hide];
    _stopBarView.hidden = YES;
    
    // 隐藏播放按钮
    [self showPlayBtn:0];
    
    [self ShowTips:NSLocalizedString(@"设备不在线", nil)];
}

/**
 *  显示没有权限的提示
 */
- (void)showNoPermissionTips
{
//    [_admWaitView hide];
    _stopBarView.hidden = YES;
    
    // 隐藏播放按钮
    [self showPlayBtn:0];
    
    [self ShowTips:NSLocalizedString(@"您没有权限进行预览", nil)];
    
}

/**
 *  显示缩略图
 *
 *  @param path 路径
 *  @param type 缩略图类型
 */
- (void)showThumbnail:(NSString *)path andThumbType:(int)type
{
    if (self.thumbnailBtn == nil)
    {
        self.thumbnailBtn = [[ThumbBtnView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - THUMBNAIL_IMAGE_HEIGHT, THUMBNAIL_IMAGE_WIDTH, THUMBNAIL_IMAGE_HEIGHT)];
        self.thumbnailBtn.exclusiveTouch = YES;
        [self.thumbnailBtn addTarget:self
                         touchAction:@selector(onClickedThumnailBtn)];
        self.thumbnailBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.thumbnailBtn];
        
        [self bringSubviewToFront:_stopBarView];
    }
    
    self.thumbnailBtn.frame = _playBgView.frame;
    
    if (0 == [path length])
    {
        self.thumbnailBtn.hidden = YES;
        [self.thumbnailBtn showImage:nil andWaterImg:nil];
    }
    else
    {
        if (0 == type)
        {
            [self.thumbnailBtn showImage:path andWaterImg:@"Vedio_Frame.png"];
        }
        else if (1 == type)
        {
            [self.thumbnailBtn showImage:path andWaterImg:@"Picture_Frame.png"];
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    self.thumbnailBtn.frame = CGRectMake(0, self.frame.size.height - THUMBNAIL_IMAGE_HEIGHT, THUMBNAIL_IMAGE_WIDTH, THUMBNAIL_IMAGE_HEIGHT);
    
    [UIView commitAnimations];

}

/**
 *  预览视图放大使能
 *
 *  @param bEnable YES允许 NO禁止
 */
- (void)enableZoomView:(BOOL)bEnable
{
    _playBgView.maximumZoomScale = bEnable? 4.0f:1.0f;
}

/**
 *  开始录像
 */
- (void)startRecording
{
    _nTime = 0;
    _recordView.hidden = NO;
    [self bringSubviewToFront:_recordView];
    
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeInfo) userInfo:nil repeats:YES];
    
    // 红点呼吸动画
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.01f];
    animation.toValue = [NSNumber numberWithFloat:1.5f];
    animation.duration = 1.2f;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion=NO;
    animation.autoreverses=YES;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.fillMode=kCAFillModeForwards;
    
    [_recordTipsView.layer addAnimation:animation forKey:nil];
}

/**
 *  结束录像
 */
- (void)stopRecording
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        
        _nTime = 0;
        _timeLab.text = @"00:00";
        _recordView.hidden = YES;
        
        [_recordTipsView.layer removeAllAnimations];
        _recordTipsView.alpha = 0.0f;
    }
    
    _timer = nil;

}

/**
 *  添加realView的行为时间响应
 *
 *  @param target 载体
 *  @param action 动作
 *  @param event  名称
 */
- (void)addTarget:(id)target action:(SEL)action forEventEX:(REALVIEW_EVENT)event
{
    for (actionEvent * actionEve in _arrRealViewEvent)
    {
        if (actionEve.realEvent == event)
        {
            actionEve.target = target;
            actionEve.action = action;
            
            return;
        }
    }
    
    
    actionEvent * actionEve = [[actionEvent alloc] init];
    actionEve.realEvent = event;
    actionEve.target = target;
    actionEve.action = action;
    
    [_arrRealViewEvent addObject:actionEve];
}


#pragma mark - 
#pragma mark inner methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)doAction:(REALVIEW_EVENT)event withObject:object
{
    for (actionEvent * actionEve in _arrRealViewEvent)
    {
        if (actionEve.realEvent == event)
        {
            id target = actionEve.target;
            SEL action = actionEve.action;
            
            if ([target respondsToSelector:action])
            {
                [target performSelector:action withObject:object];
            }
        }
    }
}


- (void)definitiontypeSelectedHandler:(NSInteger)type
{
    NSLog(@"%ld",(long)type);
    
    UIButton *btn = (UIButton *)[_stopBarView viewWithTag:1001];
    NSString *str;
    switch (type)
    {
        case 1:
            str = @"高清";
            break;
        case 2:
            str = @"均衡";
            break;
        case 3:
            str = @"标清";
            break;
        default:
            break;
    }
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitle:str forState:UIControlStateHighlighted];
    self.changeVideoQualityClick(type);
    [self.popoverController dismissPopoverAnimatd:YES];
}

#pragma clang diagnostic pop

-(void)voiceStopBtn:(UIButton*)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.changeVoiceClick(!btn.selected);
}

-(void)definitionClickHandler:(UIButton *)sender forEvent:(UIEvent*)event
{
    self.popoverController.cornerRadius = 3;
    self.popoverController.popoverBaseColor = [UIColor whiteColor];
    self.popoverController.popoverGradient= NO;
    [self.popoverController showPopoverWithTouch:event];
}

- (void)onClickPlayBtn:(id)sender
{
    [self doAction:REALVIEW_EVENT_PLAYBTNTOUCHUPINSIDE withObject:_playBtn];
}

- (void)onClickStopBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [self doAction:REALVIEW_EVENT_STOPBTNTOUCHUPINSIDE withObject:nil];
}

- (void)onClickedThumnailBtn
{
    [self doAction:REALVIEW_EVENT_THUMBNAILTOUCH withObject:nil];
}

/**
 *  播放按钮处理
 *
 *  @param nType  0隐藏 1播放 2重试
 */
- (void)showPlayBtn:(int)nType
{
    switch (nType)
    {
        case 0:  // 隐藏
        {
            _playBtn.hidden = YES;
        }
            break;
        case 1:  // 播放按钮
        {
            _playBtn.hidden = NO;
            
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"public_play.png"] forState:UIControlStateNormal];
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"public_play_sel.png"] forState:UIControlStateHighlighted];
            
            _playBtn.tag = PLAYBTN_PLAY;
            _playBtn.frame = CGRectMake((self.frame.size.width-100)/2, (self.frame.size.height-100)/2, 100, 100);
        }
            break;
        case 2:
        {
            _playBtn.hidden = NO;
            
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"PlayRefresh.png"] forState:UIControlStateNormal];
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"PlayRefresh_Sel.png"] forState:UIControlStateHighlighted];
            
            _playBtn.tag = PLAYBTN_REFRESH;
            _playBtn.frame = CGRectMake((self.frame.size.width-100)/2, self.frame.size.height/2-90, 100, 100);
        }
            break;
        default:
            break;
    }
}

/**
 *  提示语
 *
 *  @param strTips error string
 */
- (void)ShowTips:(NSString *)strTips
{
    [_tipsView ShowTips:strTips];
    _tipsView.hidden = NO;
}

/**
 *  单击手势响应事件
 *
 *  @param gesture
 */
- (void)oneTapView:(UIGestureRecognizer *)gesture
{
    [self doAction:REALVIEW_EVENT_ONETAPVIEW withObject:nil];
}

/**
 *  刷新时间信息
 */
- (void)updateTimeInfo
{
    _nTime++;
    
    long int iMin;
    long int iSec;
    
    iMin = _nTime / 60;
    iSec = _nTime % 60;
    
    NSString *stringTimer = [NSString stringWithFormat:@"%@:%@",
                             [YSCommonMethods figureLongHandle:iMin],
                             [YSCommonMethods figureLongHandle:iSec]];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       _timeLab.text = stringTimer;
                       
                       _recordTipsView.hidden = !_recordTipsView.hidden;
                   });
    
}

#pragma mark -
#pragma mark scrollView delegate  

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _playView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale > 1.0f)
    {
        _zoomSizeLab.text = [NSString stringWithFormat:@"%0.1fX", scrollView.zoomScale];
        if (_zoomSizeLab.hidden)
        {
            _zoomSizeLab.hidden = NO;
        }
    }
    else
    {
        _zoomSizeLab.hidden = YES;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [self doAction:REALVIEW_EVENT_ZOOMUP withObject:nil];
}

#pragma mark -
#pragma mark gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];

    if (CGRectContainsPoint(_playBtn.frame, point) && _playBtn.hidden == NO)
    {
        return NO;
    }
    
    if (CGRectContainsPoint(_stopBarView.frame, point) && _stopBarView.hidden == NO)
    {
        return NO;
    }
    
    return YES;  
}


@end


@implementation actionEvent


@end
