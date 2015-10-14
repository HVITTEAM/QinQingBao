//
//  CTimeBarPanel.m
//  iVMSTest
//
//  Created by hikvision on 12-12-27.
//  Copyright (c) 2012年 hikvision. All rights reserved.
//

#import "CTimeBarPanel.h"

#define dateLabelViewTag  1000
#define hourPointViewTag  2000
#define recordFileViewTag 3000

static int counter = 0;

const CGFloat BaseLineTop = 20;
const CGFloat TimeLabelHeight = 20;
const CGFloat TimeLableWidth = 60;
const CGFloat HourPointHeight = 10;
const CGFloat QuarterPointHeight = 6;
const CGFloat TimeHeight = 37;
const CGFloat RecordListHeight = 58;

#define FRAME_FS_DRAWVIEW                   CGRectMake(self.frame.size.width/2, 37, self.frame.size.width*24 / HOURS_PERPAGE, 36)
#define FRAME_DRAWVIEW                      CGRectMake(self.frame.size.width/2, 37, self.frame.size.width*24 / HOURS_PERPAGE, 36)


@interface CTimeBarPanel()
{
    
}


- (void)createScrollBarView;
- (void)scrollDraggingHandle:(UIScrollView *)scrollView;
- (NSString *)genString:(int)i;
@end

@implementation CTimeBarPanel
@synthesize delegate = _delegate;
@synthesize bFullScreen = _bFullScreen;
@synthesize bgImgView = _bgImgView;

- (id)initWithFrame:(CGRect)frame bFullScreen:(BOOL)bFullScreen
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _bFullScreen = bFullScreen;
        self.backgroundColor = [UIColor clearColor];
        
        // Background
//        UIImage *bgimg = nil;
//        [self setBackgroundColor:[UIColor grayColor]];
//        if (_bFullScreen)
//        {
//            bgimg = [UIImage imageNamed:@"playback_fullscreen_playbar.png"];
//        }
//        else
//        {
//            bgimg = [UIImage imageNamed:@"playback_playbar_bg.jpg"];
//        }
        
        
        //        if (_bgImgView == nil)
        //        {
        //            _bgImgView = [[UIImageView alloc] initWithImage:bgimg];
        //            _bgImgView.userInteractionEnabled = YES;
        //            [_bgImgView setFrame:CGRectMake(0,
        //                                            0,
        //                                            self.frame.size.width,
        //                                            self.frame.size.height)];
        //        }
        //        [self addSubview:_bgImgView];
        
        UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(0, BaseLineTop, self.frame.size.width, 1)];
        baseLine.backgroundColor = UIColorFromRGB(0x39a3ed, 1.0);
        baseLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:baseLine];
        
        // 创建滑动播放视图组
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.frame.size.width,
                                                                     self.frame.size.height)];
        if (_bFullScreen)
        {
            CALayer *layer = _scrollView.layer;
            layer.cornerRadius = 30;
            [layer setMasksToBounds:YES];
        }
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        _scrollView.contentSize = SIZE_SCROLLCONTENT;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        
        [self createScrollBarView];
        
        // 黄线
        UIImage *img = nil;
        if (_bFullScreen)
        {
            img = [UIImage imageNamed:@"playback_fullscreen_playbarline.png"];
            _sliderImgView = [[UIImageView alloc] initWithImage:img];
            [_sliderImgView setFrame:CGRectMake(self.frame.size.width/2,
                                                10,
                                                _sliderImgView.frame.size.width/2,
                                                _sliderImgView.frame.size.height/2)];
        }
        else
        {
            img = [UIImage imageNamed:@"palyback_time_bg.png"];
            _sliderImgView = [[UIImageView alloc] initWithImage:img];
            [_sliderImgView setFrame:CGRectMake((self.frame.size.width - 70) / 2,
                                                20,
                                                70,
                                                self.frame.size.height - 20)];
        }
        
        _sliderImgView.userInteractionEnabled = YES;
        [self addSubview:_sliderImgView];
        
        // 日期
        _dateLab = [[UILabel alloc] initWithFrame:FRAME_DATELAB];
        [_dateLab setBackgroundColor:[UIColor clearColor]];
        [_dateLab setTextColor:[UIColor whiteColor]];
        [_dateLab setFont:[UIFont boldSystemFontOfSize:14]];
        _dateLab.textAlignment = NSTextAlignmentRight;
        _dateLab.numberOfLines = 1;
        _dateLab.hidden = YES;
        [self addSubview:_dateLab];
        
        // 时间
        _timeLab = [[UILabel alloc] initWithFrame:FRAME_TIMELAB];
        [_timeLab setBackgroundColor:[UIColor clearColor]];
        [_timeLab setAlpha:0.6];
        [_timeLab.layer setCornerRadius:7.5];
        [_timeLab setTextColor:UIColorFromRGB(0xffffff, 1.0f)];
        [_timeLab setFont:[UIFont boldSystemFontOfSize:12]];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.numberOfLines = 1;
        _timeLab.hidden = NO;
        [self addSubview:_timeLab];
        
        // Init
        _recViewArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        /*
        UITapGestureRecognizer * touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        touchGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:touchGesture];
        [touchGesture release];
        */
        
        _currentPageSize = HOURS_PERPAGE;
        _isEnlarge = NO;
    }
    return self;
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer
{
    if ([_recViewArray count]){
        if (_isEnlarge == NO){
            _isEnlarge = YES;
            [self autoresizeSubView:HOURS_PERPAGE endPageSize:1];
        }
        else {
            _isEnlarge = NO;
            [self autoresizeSubView:1 endPageSize:HOURS_PERPAGE];
        }
    }
}

- (void)autoresizeSubView:(float)prePageSize endPageSize:(float)endPageSize
{
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = self.frame.size.width * (24 / endPageSize + 1);
    
    CGRect drawViewRect = _drawView.frame;
    drawViewRect.size.width = self.frame.size.width * 24 / endPageSize;
    
    [UIView animateWithDuration:1
                     animations:^{
                         
                         _scrollView.contentSize = contentSize;
                         _drawView.frame = drawViewRect;
                         
                         for (int i = 0; i < 25; i++)
                         {
                             UIView *dateLab = [_scrollView viewWithTag:(dateLabelViewTag + i)];
                             CGPoint dateCenter = dateLab.center;
                             dateCenter.x = i * self.frame.size.width / endPageSize + self.frame.size.width/2;
                             dateLab.center = dateCenter;
                             
                             UIView *hourPointView = [_scrollView viewWithTag:(hourPointViewTag + i)];
                             CGPoint pointCenter = hourPointView.center;
                             pointCenter.x = dateCenter.x;
                             hourPointView.center = pointCenter;
                         }
                         
                         for (int i = 0; i < [_recViewArray count]; i++)
                         {
                             UIView *recordView = [_drawView viewWithTag:(recordFileViewTag + i)];
                             CGRect rect = recordView.frame;
                             
                             rect.origin.x = rect.origin.x * prePageSize / endPageSize;
                             rect.size.width = rect.size.width * prePageSize / endPageSize;
                             recordView.frame = rect;
                         }

                         _currentPageSize = endPageSize;
                         
                         long secs_x = _curTime.hour * 3600 + _curTime.minute * 60 + _curTime.second;
                         CGPoint curPoint = CGPointMake(secs_x * prePageSize / endPageSize / 3600, 0);
                         //[_scrollView setContentOffset:curPoint animated:YES];
                         _scrollView.contentOffset = curPoint;
                     }
                     completion:^(BOOL finished) {}];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

#pragma mark - create view

/** @fn	createScrollBarView
 *  @brief  创建滑动条视图
 *  @param  
 *  @return 无
 */
- (void)createScrollBarView
{
//    float dateY = 0;
//    if (_bFullScreen)
//    {
//        dateY = 28;
//    }
//    else
//    {
//        dateY = 32;
//    }
    
    [self drawTimePointView];
    
    // 添加录像片段绘制的父View
    if (_bFullScreen)
    {
        _drawView = [[UIView alloc] initWithFrame:FRAME_FS_DRAWVIEW];
    }
    else
    {
        _drawView = [[UIView alloc] initWithFrame:FRAME_DRAWVIEW];
    }
    [_scrollView addSubview:_drawView];
}

#pragma mark - delegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_recViewArray count] <= 0)
    {
        return;
    }
    
    if (_delegate)
    {
        [_delegate timeBarStartDraggingDelegate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    counter++;
    if (scrollView.dragging && counter % 4 == 0)
    {
        [self performSelectorOnMainThread:@selector(scrollDraggingHandle:) 
                               withObject:scrollView 
                            waitUntilDone:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_recViewArray count] <= 0)
    {
        return;
    }
    if (!scrollView.dragging && _delegate)
    {
        [_delegate timeBarStopScrollDelegate:&_curTime];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_recViewArray count] <= 0)
    {
        return;
    }
    if (!scrollView.dragging && _delegate)
    {
        [_delegate timeBarStopScrollDelegate:&_curTime];
    }
}

/** @fn	scrollDraggingHandle
 *  @brief  scroll停止滚动处理
 *  @param  scrollView - 滑动View对象
 *  @return 无
 */
- (void)scrollDraggingHandle:(UIScrollView *)scrollView
{
    int year  = _curTime.year;
    int month = _curTime.month;
    int day   = _curTime.day;
    
    memset(&_curTime, 0, sizeof(ABSTIME));
    
    _curTime.year  = year;
    _curTime.month = month;
    _curTime.day   = day;
    
    CGPoint curPoint = [scrollView contentOffset];
    if ((int)curPoint.x < 0)
    {
        [_timeLab setText:[NSString stringWithFormat:@"00:00:00"]];
    }
    else if ((int)curPoint.x > self.frame.size.width * 24 / _currentPageSize)
    {
        _curTime.hour = 24;
        [_timeLab setText:[NSString stringWithFormat:@"24:00:00"]];
    }
    else
    {
        float secPerPix = (float)_currentPageSize*3600/self.frame.size.width;
        int secs = curPoint.x * secPerPix;  // 67.5 = HOURS_PERPAGE*3600/WIDTH_SCREEN
        _curTime.hour = secs/3600;
        _curTime.minute = secs%3600/60;
        _curTime.second = secs%60;
    }
    
    if (_curTime.hour < 0 || _curTime.hour > 24)
    {
        _curTime.hour = 0;
    }
    if (_curTime.minute < 0 || _curTime.minute > 60)
    {
        _curTime.minute = 0;
    }
    if (_curTime.second < 0 || _curTime.hour > 60)
    {
        _curTime.second = 0;
    }
    
    if (_delegate)
    {
        [_delegate timeBarScrollDraggingDelegate:&_curTime timeBarObj:self];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [_drawView setCenter:CGPointMake(scrollView.contentSize.width / 2, _drawView.center.y)];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _drawView;
}
#pragma mark - public method
/** @fn	setDate
 *  @brief  设置当前日期
 *  @param  sDate - 当前日期字符串
 *  @return 无
 */
- (void)setTimeBarDate:(NSString *)sDate
{
    // 设置时间条日期
    if (sDate)
    {
        _dateLab.text = sDate;
    }
    else
    {
        _dateLab.text = @"";
    }
    _timeLab.text = @"00:00:00";
    
    // 设置滚动条位置
    if (_scrollView)
    {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    // 保存当前日期
    NSString *sYear = [sDate substringToIndex:4];
    NSRange range = {5, 2};
    NSString *sMonth = [sDate substringWithRange:range];
    NSString *sDay = [sDate substringFromIndex:8];
    _curTime.year = [sYear intValue];
    _curTime.month = [sMonth intValue];
    _curTime.day = [sDay intValue];
}

- (void)resetStartTime
{
    _timeLab.text = @"00:00:00";
}


- (void)drawTimePointView
{
    
 // 填写24小时时间点
    for (int i = 0; i < 25; i++)
    {
        if (0 == (i % 2))
        {
            UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TimeLableWidth, TimeLabelHeight)];
            [dateLab setBackgroundColor:[UIColor clearColor]];
            [dateLab setTextColor:UIColorFromRGB(0x39a3ed, 1.0)];
            [dateLab setFont:[UIFont systemFontOfSize:12.]];
            dateLab.textAlignment = NSTextAlignmentCenter;
            dateLab.numberOfLines = 1;
            dateLab.tag = dateLabelViewTag + i;
            NSString *date = [NSString stringWithFormat:@"%@:00", [self genString:i]];
            dateLab.text = date;
            CGPoint dateCentPoint = CGPointMake(i * self.frame.size.width / HOURS_PERPAGE + self.frame.size.width/2, 10);
            dateLab.center = dateCentPoint;
            [_scrollView addSubview:dateLab];
        }
        
        UIImageView *hourPoint = [[UIImageView alloc] initWithFrame:CGRectMake(0, BaseLineTop, 1, HourPointHeight)];
        hourPoint.backgroundColor = UIColorFromRGB(0x39a3ed, 1.0);
        //        [hourPoint setImage:[UIImage imageNamed:@"pb_timebar_hour.jpg"]];
        hourPoint.center = CGPointMake(i * self.frame.size.width / HOURS_PERPAGE + self.frame.size.width/2, BaseLineTop + HourPointHeight / 2);
        hourPoint.tag = hourPointViewTag + i;
        hourPoint.userInteractionEnabled = YES;
        [_scrollView addSubview:hourPoint];
        
        CGRect hourPointFrame = hourPoint.frame;
        CGFloat x = hourPointFrame.origin.x;;
        CGFloat y = hourPointFrame.origin.y;
        CGFloat seperator = self.frame.size.width / HOURS_PERPAGE / 4.0f;
        CGFloat height = QuarterPointHeight;
        
        if (i < 24)
        {
            for (int j = 1; j < 4; ++j)
            {
                UIView *quarterPoint = [[UIView alloc] initWithFrame:CGRectMake(x + seperator * j, y, 1, height)];
                quarterPoint.backgroundColor = UIColorFromRGB(0x39a3ed, 1.0);
                [_scrollView addSubview:quarterPoint];
            }
        }
    }
}

- (void)drawViewWithRecords:(NSMutableArray *)recorderArray
{
    if (0 == [recorderArray count])
    {
        return;
    }
    
    NSInteger i = 0;
    // 取出每段录像起始时间及结束时间并生成相应录像条视图
    for (NSValue *value in recorderArray)
    {
        RecordSegment recordSegment;
        memset(&recordSegment, 0, sizeof(RecordSegment));
        
        [value getValue:&recordSegment];
        
        // 取出日期，然后得出秒数，算出长度，绘制视图
        UIView *recordView = nil;
        
        // 处理如果录像文件开始时间早于00：00则将结束时间设为00：00
        if (recordSegment.beginTime.year < _curTime.year ||
            recordSegment.beginTime.month < _curTime.month ||
            recordSegment.beginTime.day < _curTime.day)
        {
            recordSegment.beginTime.year    = _curTime.year;
            recordSegment.beginTime.month   = _curTime.month;
            recordSegment.beginTime.day     = _curTime.day;
            recordSegment.beginTime.hour    = 0;
            recordSegment.beginTime.minute  = 0;
            recordSegment.beginTime.second  = 0;
        }
        
        // 处理如果录像文件结束时间超过24：00则将结束时间设为24：00
        if (recordSegment.endTime.year > _curTime.year ||
            recordSegment.endTime.month > _curTime.month ||
            recordSegment.endTime.day > _curTime.day)
        {
            recordSegment.endTime.year    = _curTime.year;
            recordSegment.endTime.month   = _curTime.month;
            recordSegment.endTime.day     = _curTime.day;
            recordSegment.endTime.hour    = 23;
            recordSegment.endTime.minute  = 59;
            recordSegment.endTime.second  = 59;
        }
        
        long secs_x = recordSegment.beginTime.hour * 3600 + recordSegment.beginTime.minute * 60 + recordSegment.beginTime.second;
        long secs_len = recordSegment.endTime.hour * 3600 + recordSegment.endTime.minute * 60 + recordSegment.endTime.second - secs_x;
        
        // 竖屏FRAME
        CGRect frame = CGRectMake(secs_x * PIXELS_PERHOUR / 3600,
                                  0,
                                  secs_len * PIXELS_PERHOUR / 3600,
                                  _drawView.frame.size.height);
        recordView = [[UIView alloc] initWithFrame:frame];
        //recordView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (recordSegment.recordType == 0)
        {
            [recordView setBackgroundColor:UIColorFromRGB(0x39a3ed, 1.0)];   // 定时录像灰色
        }
        //        else if (recordSegment.recordType == RECORD_TYPE_MOVE)
        //        {
        //            [recordView setBackgroundColor:UIColorFromRGB(0x997F00, 1.0)];//yellow
        //        }
        //        else if (recordSegment.recordType == RECORD_TYPE_MANU)
        //        {
        //            [recordView setBackgroundColor:UIColorFromRGB(0x00802A, 1.0)];//green
        //        }
        else
        {
            [recordView setBackgroundColor:UIColorFromRGB(0xff8261, 1.0)];   // 报警录像橘黄色
        }
        recordView.tag = recordFileViewTag + i++;
        [_recViewArray addObject:recordView];
        [_drawView addSubview:recordView];
    }
}

/** @fn	drawContentBar
 *  @brief  绘制进度条
 *  @param  recorderArray - 录像文件数组
 *  @return 无
 */
- (BOOL)drawContentBar:(NSMutableArray *)recorderArray
{
    // 首先清空原录像视图View, 无论本次是否为空
    if ([_recViewArray count] > 0)
    {
        for (UIView *recView in _recViewArray)
        {
            [recView removeFromSuperview];
        }
        [_recViewArray removeAllObjects];
    }
    
    if (recorderArray == nil)
    {
        return NO;
    }
    NSUInteger iRecorderCounter = [recorderArray count];
    
    if (iRecorderCounter == 0)
    {
        // 无录像提示
        return NO;
    }
    
    [self drawViewWithRecords:recorderArray];

    return YES;
}

/** @fn	cleanContentBar
 *  @brief  清除掉录像条
 *  @param  
 *  @return 无
 */
- (void)cleanContentBar
{
    // 首先清空原录像视图View, 无论本次是否为空
    if ([_recViewArray count] > 0)
    {
        for (UIView *recView in _recViewArray)
        {
            [recView removeFromSuperview];
        }
        [_recViewArray removeAllObjects];
    }
}

/** @fn	updateSlider
 *  @brief  更新进度位置
 *  @param  curTime - 当前播放时间
 *  @return 无
 */
- (BOOL)updateSlider:(ABSTIME *)curTime;
{
    if (curTime == nil)
    {
        return NO;
    }
    
    if (_scrollView.dragging)
    {
        return YES;
    }
    
    // 更新进度条位置
    if (_scrollView != nil)
    {
        long secs_x = curTime->hour * 3600 + curTime->minute * 60 + curTime->second;
        CGPoint curPoint = CGPointMake(secs_x * self.frame.size.width / _currentPageSize /3600, 0);
        [_scrollView setContentOffset:curPoint animated:YES];
    }
    
    return YES;
}

/** @fn	updateTimeBarTime
 *  @brief  更新时间标签内容
 *  @param  curTime - 当前时间
 *  @return 
 */
- (void)updateTimeBarTime:(ABSTIME *)curTime
{
    if (curTime == nil)
    {
        return;
    }
    
    // 更新时间显示标签
    [_timeLab setText:[NSString stringWithFormat:@"%@:%@:%@", 
                       [self genString:curTime->hour], 
                       [self genString:curTime->minute], 
                       [self genString:curTime->second]]];
}

/** @fn	genString
 *  @brief  由int生成string
 *  @param  i - int数
 *  @return NSString 对象
 */
- (NSString *)genString:(int)i
{
    if (i < 0 || i >= 60)
    {
        return @"00";
    }
    
    if (i < 10)
    {
        return [NSString stringWithFormat:@"0%d", i];
    }
    else
    {
        return [NSString stringWithFormat:@"%d", i];
    }
}
@end
