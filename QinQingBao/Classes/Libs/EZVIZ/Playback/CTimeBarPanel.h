//
//  CTimeBarPanel.h
//  iVMSTest
//
//  Created by hikvision on 12-12-27.
//  Copyright (c) 2012年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRecInfo.h"

// 颜色值
#define UIColorFromRGB(rgbValue, alp)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                                                        green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
                                                         blue:((float)(rgbValue & 0xFF)) / 255.0 \
                                                        alpha:alp]

#define HOURS_PERPAGE                       4                                   // 每屏小时数
#define PIXELS_PERHOUR                      self.frame.size.width / HOURS_PERPAGE // 每秒像素数

#define SIZE_SCROLLCONTENT                  CGSizeMake(self.frame.size.width*(24/HOURS_PERPAGE + 1), self.frame.size.height)
#define FRAME_SLIDER                        CGRectMake(self.frame.size.width/2, 0, 2, self.frame.size.height)

// 竖屏
#define LEN_LAB                             80
#define FRAME_DATELAB                       CGRectMake(self.frame.size.width/2 - LEN_LAB - 5, 9, LEN_LAB, 15)
#define FRAME_TIMELAB                       CGRectMake((self.frame.size.width - 60) / 2, 42.5, 60, 15)


@protocol CTimeBarDelegate <NSObject>

- (void)timeBarStartDraggingDelegate;
- (void)timeBarScrollDraggingDelegate:(ABSTIME *)sTime timeBarObj:(id)timeBar;
- (void)timeBarStopScrollDelegate:(ABSTIME *)sTime;

@end

@interface CTimeBarPanel : UIView
<UIScrollViewDelegate>
{
    UIImageView             *_bgImgView;                                        // 背景
    UIImageView             *_sliderImgView;                                    // 黄线图标
    UILabel                 *_dateLab;                                          // 年月日标签
    UILabel                 *_timeLab;                                          // 时分秒标签
    
    UIScrollView            *_scrollView;
    UIView                  *_drawView;                                         // 用于绘制的父视图
    
    NSMutableArray          *_recViewArray;                                     // 录像片段视图数组
    
    ABSTIME                 _curTime;
    BOOL                    _bFullScreen;
    
    float _currentPageSize;
    BOOL  _isEnlarge;
}

@property (nonatomic, assign) id<CTimeBarDelegate> delegate;
@property BOOL bFullScreen;
@property (nonatomic, retain) UIImageView *bgImgView;

// Init
- (id)initWithFrame:(CGRect)frame bFullScreen:(BOOL)bFullScreen;

// 设置当前日期
- (void)setTimeBarDate:(NSString *)sDate;

// 绘制进度条
- (BOOL)drawContentBar:(NSMutableArray *)recorderArray;

// 清除绘制条
- (void)cleanContentBar;

// 更新进度位置
- (BOOL)updateSlider:(ABSTIME *)curTime;

// 更新时间标签内容
- (void)updateTimeBarTime:(ABSTIME *)curTime;

- (void)resetStartTime;

@end
