//
//  IntercomView.m
//  VideoGo
//
//  Created by yudan on 14-5-26.
//
//

#import "IntercomView.h"
#import "IntercomCtrlView.h"

#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>



@interface IntercomView () <IntercomCtrlViewDelegate>
{
    IntercomCtrlView   *_ivView;
}

@property (nonatomic, strong) IntercomCtrlView   *ivView;                     // 对讲显示音量视图

@end


@implementation IntercomView

@synthesize intercomType = _intercomType;
@synthesize ivView = _ivView;
@synthesize realCtrl = _realCtrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.intercomType = INTERCOM_TYPE_DUPLEX;

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    self.ivView.delegate = nil;
    self.ivView = nil;
    
    self.realCtrl = nil;
    
}


- (void)initView
{
    IntercomVolumnViewType intercomType = self.intercomType == INTERCOM_TYPE_DUPLEX?IntercomVolumnViewTypeWithoutButton:IntercomVolumnViewTypeWithButton;
    self.ivView = [[IntercomCtrlView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                  withType:intercomType
                                                   forMail:NO];
    self.ivView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.ivView];
    self.ivView.delegate = self;
    
}


- (void)intercomIntensity:(unsigned int)nIntensity
{
    // 双工模式下，value+10，否则数值太小，绘图看不出来
    if (self.intercomType == INTERCOM_TYPE_DUPLEX && nIntensity > 0)
    {
        nIntensity += 10;
        nIntensity = MIN(nIntensity, 100);
    }
    
    [self.ivView drawViewWithIntercomVolumn:nIntensity];
}

#pragma mark -
#pragma mark ivView delegate
/**
 *  对讲按钮按下事件
 */
- (void)didTouchDownOnIntercomButton
{
    if ([self.realCtrl isIntercom])
    {
        [self.realCtrl intercomEnableSpeak];
    }
}

/**
 *  对讲按钮弹起事件
 */
- (void)didTouchUpInsideOnIntercomButton
{
    if ([self.realCtrl isIntercom])
    {
        [self.realCtrl intercomEnablePlay];
    }
}

/**
 *  对讲弹起在按钮外时间
 */
- (void)didTouchUpOutsideOnIntercomButton
{
    if ([self.realCtrl isIntercom])
    {
        [self.realCtrl intercomEnablePlay];
    }
}


@end
