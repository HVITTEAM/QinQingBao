//
//  CMyCameraListViewController.m
//  VideoGo
//
//  Created by hikvision hikvision on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CMyCameraListViewController.h"

#import "YSHTTPClient.h"
#import "YSMobilePages.h"
#import "YSPlayerController.h"
#import "YSConstStrings.h"

#import "MyCameraListCell.h"
#import "YSCameraInfo.h"
#import "CPlaybackController.h"
#import "YSDemoDataModel.h"
#import "YSDemoAlarmListViewController.h"
#import "RealPlayViewController.h"
#import "YSShowDeviceCaptureViewController.h"
#import "CSNAddByQRcodeViewController.h"

@interface CMyCameraListViewController () <UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>{
}


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, weak) IBOutlet UIButton *reloadBtn;

@property (nonatomic, strong) NSMutableDictionary *coverDict;
@property (nonatomic, strong) NSMutableArray *cameraList;
@property (nonatomic, strong) YSMobilePages *mp;

@end

@implementation CMyCameraListViewController


#pragma -
#pragma mark - object
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _cameraList = [[NSMutableArray alloc] init];
        _coverDict = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cameraCoverRequestDidFinished:)
                                                     name:kRequestCameraCaptureDidFinishedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceDidAddNotification:)
                                                     name:kAddDeviceSuccessNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    self.title = @"设备列表";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCameraListCell" bundle:nil] forCellReuseIdentifier:@"deviceCell"];
    
    [[_reloadBtn layer] setBorderWidth:1.0];
    [[_reloadBtn layer] setBorderColor:[UIColor grayColor].CGColor];
    
    [_indicator setHidden:YES];
    [_tableView setHidden:YES];
    
    YSMobilePages *mobilePage = [[YSMobilePages alloc] init];
    self.mp = mobilePage;
    
    [self searchCameras];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cameraList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    MyCameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    cell.parentViewController = self;
    YSCameraInfo *device = _cameraList[indexPath.row];
    [cell setDeviceInfo:device];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 * ([UIScreen mainScreen].bounds.size.width/320.0f);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        YSCameraInfo *ci = [_cameraList objectAtIndex:indexPath.row];
        [[YSHTTPClient sharedInstance] requestDeleteDeviceWithDeviceId:ci.deviceId complition:^(id responseObject, NSError *error) {
            if (responseObject) {
                NSDictionary *dictionary = (NSDictionary *)responseObject;
                NSNumber *resultCode = [dictionary objectForKey:@"resultCode"];
                if (HTTP_REQUEST_OK_CODE == [resultCode intValue])
                {
                    [_cameraList removeObject:ci];
                    [_tableView reloadData];
                }
            }
        }];
    }
    
}


#pragma mark - MyCameraListCellDelegate

- (void)go2Manager:(YSCameraInfo *)info
{
    [_mp manageDevice:self withDeviceId:info.deviceId accessToken:[[YSDemoDataModel sharedInstance] userAccessToken]];
}

- (void)go2CapturePicture:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入图片uuid"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (IBAction)reloadList:(id)sender {
    
    [self searchCameras];
}


/**
 *  查询摄像头列表
 *
 */
- (void)searchCameras
{
    if (0 == [[[YSDemoDataModel sharedInstance] userAccessToken] length])
    {
        return;
    }
    
    [[YSHTTPClient sharedInstance] requestSearchCameraListPageFrom:0 pageSize:30 complition:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSNumber *resultCode = [dictionary objectForKey:@"resultCode"];
            if (HTTP_REQUEST_OK_CODE == [resultCode intValue])
            {
                [self parseCameraList:dictionary];
                
                [_tableView reloadData];
                
//                [self captureRealTimeImages];
                
                [_tableView setHidden:NO];
                
            }
            else
            {
                [_reloadBtn setHidden:NO];
            }
        }
        else
        {
            [_reloadBtn setHidden:NO];
        }
        
        [_indicator setHidden:YES];
        [_indicator stopAnimating];
    }];
    
    [_reloadBtn setHidden:YES];
    [_tableView setHidden:YES];
    [_indicator setHidden:NO];
    [_indicator startAnimating];
}

- (void)parseCameraList:(NSDictionary *)dictionary
{
    [_cameraList removeAllObjects];

    NSArray *array = [dictionary objectForKey:@"cameraList"];
    for (int i = 0; i < [array count]; i++)
    {
        YSCameraInfo *camera = [[YSCameraInfo alloc] init];
        NSDictionary *dic = [array objectAtIndex:i];
        [camera setCameraFromDict:dic];
        [_cameraList addObject:camera];
    }
}

- (void)login
{
    [_mp login:self completion:^(NSString *accessToken) {
        if (accessToken)
        {
            NSLog(@"Client access token is: %@", accessToken);
            [EzvizDemoGlobalKit sharedKit].token = accessToken;
            [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
            [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
        }
    }];
}

- (void)addDevice {
    CSNAddByQRcodeViewController * snScanViewController = [[CSNAddByQRcodeViewController alloc] initWithNibName:@"CSNAddByQRcodeViewController" bundle:nil];
    [self.navigationController pushViewController:snScanViewController animated:YES];
}

- (void)captureRealTimeImages
{
    NSMutableArray *arrayId = [NSMutableArray array];
    for (YSCameraInfo *ci in _cameraList)
    {
        [arrayId addObject:ci.cameraId];
    }
    
    if (0 != [arrayId count])
    {
        [YSPlayerController requestCapturesWithCameraId:arrayId];
    }
}

- (void)cameraCoverRequestDidFinished:(NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    if (dict)
    {
        [_coverDict addEntriesFromDictionary:dict];
        
        [_tableView reloadData];
    }
}

- (void)deviceDidAddNotification:(NSNotification *)notification
{
    // 开发者根据实际需要控制跳转
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *deviceId = [notification object];
    
    NSLog(@"device: %@ did add.", deviceId);
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSString *uuid = [alertView textFieldAtIndex:0].text;
        [[YSHTTPClient sharedInstance] requestGetDevicePictureWithUUID:uuid imageWidth:200 complication:^(id responseObject, NSError *error) {
            
            UIImage *capture = (UIImage *)responseObject;
            
            if (capture)
            {
               YSShowDeviceCaptureViewController *controller = [[YSShowDeviceCaptureViewController alloc] initWithNibName:@"YSShowDeviceCaptureViewController" bundle:nil];
                controller.image = capture;
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                NSLog(@"error msg:%@, error code:%d", error.domain, (int)error.code);
            }
        }];
    }

}

@end
