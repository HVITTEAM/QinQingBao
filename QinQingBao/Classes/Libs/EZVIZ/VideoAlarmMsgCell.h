//
//  VideoAlarmMsgCell.h
//  VideoGo
//
//  Created by luohs on 11/27/13.
//
//

#import <UIKit/UIKit.h>

@class YSAlarmInfo, VideoAlarmMsgCell;

@protocol VideoAlarmMsgCellDelegate <NSObject>

@optional
- (void)startRealPlayWithCell:(VideoAlarmMsgCell *)cell;
- (void)startPlaybackWithCell:(VideoAlarmMsgCell *)cell;

@end

@interface VideoAlarmMsgCell : UITableViewCell

@property (nonatomic, weak) id<VideoAlarmMsgCellDelegate> delegate;
@property (nonatomic, strong) YSAlarmInfo *alarmInfo;

+ (float)cellHeight;

@end


