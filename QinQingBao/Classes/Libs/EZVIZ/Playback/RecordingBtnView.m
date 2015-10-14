//
//  RecordingBtnView.m
//  VideoGo
//
//  Created by yudan on 14-5-23.
//
//

#import "RecordingBtnView.h"
#import "YSCommonMethods.h"


@interface RecordingBtnView ()
{
    UIButton          *_btn;
    UIButton          *_recordingBtn;
    UILabel           *_timeLab;
    
    UIButton          *_showBtn;  // 当前正在显示的按钮
    
    NSTimer           *_timer;
    unsigned int       _nTime;

}

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL sel;

@end


@implementation RecordingBtnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
    }
    return self;
}

- (void)dealloc
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initView
{
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_btn setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"video_disable.png"] forState:UIControlStateDisabled];
    _btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_btn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    _showBtn = _btn;
    
    _recordingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_recordingBtn setImage:[UIImage imageNamed:@"video_start.png"] forState:UIControlStateNormal];
    [_recordingBtn setImage:[UIImage imageNamed:@"video_disable.png"] forState:UIControlStateDisabled];
    _recordingBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_recordingBtn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 35, self.frame.size.width - 24, 20)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = [UIColor whiteColor];
    _timeLab.font = [UIFont systemFontOfSize:14.0f];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.text = [NSString stringWithFormat:@"00:00"];
    _timeLab.hidden = YES;
    [self addSubview:_timeLab];

}

- (void)setButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage
{
    [_btn setImage:image forState:UIControlStateNormal];
    [_btn setImage:highlightImage forState:UIControlStateDisabled];
}

- (void)setRecordingButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage
{
    [_recordingBtn setImage:image forState:UIControlStateNormal];
    [_recordingBtn setImage:highlightImage forState:UIControlStateDisabled];
}
/**
 *  添加按钮点击事件响应
 *
 *  @param target
 */
- (void)addBtnClickEvent:(id)target sel:(SEL)action
{
    self.target = target;
    self.sel = action;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)onClickBtn
{
    [self.target performSelector:self.sel withObject:self];
}
#pragma clang diagnostic pop

/**
 *  开始录像
 */
- (void)startRecording
{
//    if (_timeLab.hidden == NO)
//    {
//        return;
//    }
    
    if (_showBtn != _recordingBtn)
    {
        [UIView transitionFromView:_btn
                            toView:_recordingBtn
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            
                        }];
        
        _showBtn = _recordingBtn;
    }
    
    
//    _timeLab.hidden = NO;
//    [self bringSubviewToFront:_timeLab];
//    
//    _nTime = 0;
//    if ([self.timer isValid])
//    {
//        [self.timer invalidate];
//    }
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeInfo) userInfo:nil repeats:YES];
}

/**
 *  停止录像
 */
- (void)stopRecording
{
//    if (_timeLab.hidden)
//    {
//        return;
//    }
    
    if (_showBtn != _btn)
    {
        [UIView transitionFromView:_recordingBtn
                        toView:_btn
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        
                    }];
        
        _showBtn = _btn;
    }
    
    
//    _timeLab.hidden = YES;
//    
//    if ([self.timer isValid])
//    {
//        [self.timer invalidate];
//    }
//    _nTime = 0;
//    _timeLab.text = @"00:00";
}

/**
 *  视图按钮有效使能
 *
 *  @param bEnable
 */
- (void)enableBtn:(BOOL)bEnable
{
    _recordingBtn.enabled = bEnable;
    _btn.enabled = bEnable;  
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
                   });
    
}

@end
