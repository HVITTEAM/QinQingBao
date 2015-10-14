//
//  MyCameraListCell.m
//  VideoGo
//
//  Created by zhengwen zhu on 10/14/13.
//
//

#import "MyCameraListCell.h"
#import "YSCameraInfo.h"
#import "UIImageView+EzvizCapturePicture.h"

#define CAMERA_NAME_HEIGHT                   30
#define CAMERA_COVER_HEIGHT                  100
#define CAMERA_FUNCGION_BUTTON_HEIGHT        50
#define CELL_EDGE_SPACE                      10
#define CELL_INSIDE_SPACE                    5


@implementation MyCameraListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - MyCameraListCellDelegate

//配置
- (IBAction)settingClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnLocalPlayButtonInCell:)]) {
        [self.delegate didClickOnLocalPlayButtonInCell:self];
    }
}

//抓图
- (IBAction)capturePictureClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnCaptureInCell:)]) {
        [self.delegate didClickOnCaptureInCell:self];
    }
}

//报警
- (IBAction)alarmListClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnVoiceMessageButtonInCell:)]) {
        [self.delegate didClickOnVoiceMessageButtonInCell:self];
    }
}

//回放
- (IBAction)playbackClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnPlayBackButtonInCell:)]) {
        [self.delegate didClickOnPlayBackButtonInCell:self];
    }
}

//实时
- (IBAction)realTimePlaybackClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickOnRealPlayButtonInCell:)]) {
        [self.delegate didClickOnRealPlayButtonInCell:_cameraInfo];
    
    }
}

- (void)setDeviceInfo:(YSCameraInfo *)info{
    _cameraInfo = info;
    self.lblDeviceName.text = info.cameraName;
    [self.deviceScreenshot ezviz_setImageWithCameraInfo:_cameraInfo.cameraId andPlaceholderImage:[UIImage imageNamed:@"cover"]];
    if (0 == [info.status intValue])
    { // 设备不在线
        self.offlineIcon.hidden = NO;
    }
    else
    { // 设备在线
        self.offlineIcon.hidden = YES;
    }
}

///**
// *  初始化
// *
// *  @param style           单元格风格
// *  @param reuseIdentifier 复用标识
// *  @param theCameraInfo   关联摄像机对象
// *
// *  @return MyCameraListCell
// */
//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier
//     withCameraInfo:(YSCameraInfo *)theCameraInfo
//{
//    if (nil == theCameraInfo) {
//        return nil;
//    }
//    
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.cameraInfo = theCameraInfo;
//    }
//    
//    
//    return self;
//}

#pragma mark - Public

//- (void)reloadWithCamera:(YSCameraInfo *)ci
//{
//    if (nil == ci) {
//        return;
//    }
//    
//    self.cameraInfo = ci;
//    _cameraNameLbl.text = ci.cameraName;
//    
//    if (0 == [self.cameraInfo.status intValue])
//    { // 设备不在线
//        [_offLineImageView setHidden:NO];
//    }
//    else
//    { // 设备在线
//        [_offLineImageView setHidden:YES];
//    }
//    self.coverImgView.clipsToBounds = YES;
//}


//
//- (IBAction)onClickRealPlayButton:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(didClickOnRealPlayButtonInCell:)]) {
//        [self.delegate didClickOnRealPlayButtonInCell:self];
//    }
//}
//
//- (IBAction)onCLickPlayBackButton:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(didClickOnPlayBackButtonInCell:)]) {
//        [self.delegate didClickOnPlayBackButtonInCell:self];
//    }
//}
//
//- (IBAction)onClickLocalPlayButton:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(didClickOnLocalPlayButtonInCell:)]) {
//        [self.delegate didClickOnLocalPlayButtonInCell:self];
//    }
//}
//
//- (IBAction)onClickVoiceMesageButton:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(didClickOnVoiceMessageButtonInCell:)]) {
//        [self.delegate didClickOnVoiceMessageButtonInCell:self];
//    }
//}
//
//- (IBAction)clickCapture:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(didClickOnCaptureInCell:)]) {
//        [self.delegate didClickOnCaptureInCell:self];
//    }
//}


@end
