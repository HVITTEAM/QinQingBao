//
//  VideoListViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "VideoListViewController.h"
#import "YSMobilePages.h"
#import "YSDemoDataModel.h"
#import "YSCameraInfo.h"
#import "MyCameraListCell.h"
#import "RealPlayViewController.h"

@interface VideoListViewController ()<MyCameraListCellDelegate>
{
    YSMobilePages *mp;
}

@property (nonatomic, strong) NSMutableArray *cameraList;

@end

@implementation VideoListViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.title = @"设备列表";
    
    [self initTableViewSkin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _cameraList = [[NSMutableArray alloc] init];
    
    mp = [[YSMobilePages alloc] init];
    
    [self login];
    
    
    
    //    {"id": "123456",
    //        "system": {
    //                    "key": "116622259fed4920a3e8957e13dc2346",
    //                    "sign": "8845c7ad6066c9cf1df170afd7dd5f06",
    //                    "time": 1415843917,
    //                    "ver": "1.0"
    //                },
    //        "method": "token/getAccessToken",
    //        "params": {
    //                   "phone" : "13588996397"
    //                }
    //    }
    //    [CommonRemoteHelper RemoteWithUrl:@"https://open.ys7.com/api/method/token/getAccessToken"
    //                           parameters: @{@"id" : @"123456",
    //                                         @"system" : @{@"key":AppKey,
    //                                                       @"sign":@"8845c7ad6066c9cf1df170afd7dd5f06",
    //                                                       @"time":  @"1415843917",
    //                                                       @"ver":  @"1.0" },
    //                                         @"method":@"token/getAccessToken",
    //                                         @"params":@{
    //                                                 @"phone" : @"13539917404"
    //                                                 }
    //                                         }
    //                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
    //                                     id codeNum = [dict objectForKey:@"code"];
    //                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
    //                                     {
    //
    //                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //                                         [alertView show];
    //                                     }
    //                                     else
    //                                     {
    //
    //                                     }
    //                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //                                     NSLog(@"发生错误！%@",error);
    //                                 }];
    
}


-(void)initTableViewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  登录页面
 */
- (void)login
{
    if([EzvizDemoGlobalKit sharedKit].token)
    {
        [[YSDemoDataModel sharedInstance] saveUserAccessToken:[EzvizDemoGlobalKit sharedKit].token];
        [[YSHTTPClient sharedInstance] setClientAccessToken:[EzvizDemoGlobalKit sharedKit].token];
        [self searchCameras];
    }else{
        [mp login:self completion:^(NSString *accessToken) {
            if (accessToken)
            {
                NSLog(@"Client access token is: %@", accessToken);
                [EzvizDemoGlobalKit sharedKit].token = accessToken;
                [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
                [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
                [self searchCameras];
            }
        }];
    }
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
                
                [self.tableView reloadData];
                
            }
            else
            {
            }
        }
        else
        {
        }
    }];
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
    static NSString *deviceCellIdentifier = @"deviceCell";
    
    MyCameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceCellIdentifier];
    
    if (!cell)
    {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyCameraListCell" owner:nil options:nil];
        cell = (MyCameraListCell*)[nibs lastObject];
        cell.parentViewController = self;
    }
    cell.delegate = self;
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
                    [self.tableView reloadData];
                }
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RealPlayViewController *realPlayController = [[RealPlayViewController alloc] init];
    YSCameraInfo *device = _cameraList[indexPath.row];
    realPlayController.cameraInfo = device;
    [self.navigationController pushViewController:realPlayController animated:YES];
}

#pragma mark - MyCameraListCellDelegate

- (void)didClickOnPlayBackButtonInCell:(MyCameraListCell *)cell
{
    NSLog(@"回放");
}
- (void)didClickOnLocalPlayButtonInCell:(MyCameraListCell *)cell
{
    NSLog(@"配置");
}

- (void)didClickOnCaptureInCell:(MyCameraListCell *)cell
{
    NSLog(@"抓图");
}

- (void)didClickOnVoiceMessageButtonInCell:(MyCameraListCell *)cell
{
    NSLog(@"报警");
}

- (void)didClickOnRealPlayButtonInCell:(YSCameraInfo *)info
{
    RealPlayViewController *realPlayController = [[RealPlayViewController alloc] init];
    YSCameraInfo *device = info;
    realPlayController.cameraInfo = device;
    [self.navigationController pushViewController:realPlayController animated:YES];
}

@end
