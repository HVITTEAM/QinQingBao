//
//  YSLinearButtonListView.h
//  VideoGo
//
//  Created by zhengwen zhu on 6/21/14.
//
//

#import <UIKit/UIKit.h>

@protocol YSLinearButtonListViewDelegate;

@class RecordingBtnView;

@interface YSLinearButtonListView : UIScrollView

@property (nonatomic, assign) id<YSLinearButtonListViewDelegate> myDelegate;
//@property (nonatomic, retain, readonly) NSMutableArray *arrayButtons;
@property (nonatomic, assign, readonly) BOOL layoutVertical;

- (id)initWithFrame:(CGRect)frame layoutVertical:(BOOL)vertical;

- (void)reloadContentSubviewsWithVertical:(BOOL)vertical;

- (RecordingBtnView *)recordView;

- (void)setPauseButtonImage:(UIImage *)image hightedImage:(UIImage *)hightedImage;

- (void)resetAccessoryButtonImage;

- (void)updateTrafficValue:(float)value downloadSpeed:(NSString *)speed totalValue:(NSString *)total;

- (void)enableListButtons:(BOOL)enable;

@end

@protocol YSLinearButtonListViewDelegate <NSObject>

@optional

- (void)buttonListView:(YSLinearButtonListView *)view didSelectButton:(UIView *)button;

@end