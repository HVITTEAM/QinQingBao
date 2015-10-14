//
//  YSVideoSquarePlayingViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/20/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import "YSVideoSquarePlayingViewController.h"

#import "YSPlayerController.h"

@interface YSVideoSquarePlayingViewController () <YSPlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playingView;
@property (weak, nonatomic) IBOutlet UILabel *lblUrl;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) YSPlayerController *player;

@end

@implementation YSVideoSquarePlayingViewController


#pragma mark - YSPlayerControllerDelegate

- (void)playerOperationMessage:(YSPlayerMessageType)msgType withValue:(id)value
{
    switch (msgType)
    {
        case YSPlayerMsgSoundUnvailable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"该视频不支持播放声音"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
       case YSPlayerMsgRealPlayFail:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"播放失败(%d)", [((NSNumber *)value) intValue]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [_playingView setBackgroundColor:[UIColor blackColor]];
    self.heightConstraint.constant = [UIScreen mainScreen].bounds.size.width/320.0 * 180.0f;
   
    _lblUrl.text = _rtspUrl;
    
    _player = [[YSPlayerController alloc] initWithDelegate:self];
    [_player startRealPlayWithURLString:_rtspUrl inView:_playingView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_player stopRealPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openAudio:(id)sender {
    [_player setAudioOpen:YES];
}

- (void)viewDidUnload {
    [self setPlayingView:nil];
    [self setLblUrl:nil];
    [super viewDidUnload];
}
@end
