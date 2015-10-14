//
//  YSDemoAlarmListViewController.m
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/18/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSDemoAlarmListViewController.h"
#import "YSHTTPClient.h"
#import "YSAlarmInfo.h"
#import "VideoAlarmMsgCell.h"
#import "CPlaybackController.h"
#import "RealPlayViewController.h"

#define HTTP_REQUEST_OK_CODE          200

@interface YSDemoAlarmListViewController () <UITableViewDataSource, UITableViewDelegate, VideoAlarmMsgCellDelegate>

@property (nonatomic, copy) NSString *cameraId;
@property (nonatomic, strong) NSMutableArray *alarmList;

@end

@implementation YSDemoAlarmListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cameraId:(NSString *)cid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cameraId = [cid copy];
        _alarmList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self searchAlarmList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_alarmList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoAlarmMsgCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"VideoAlarmMsgCell"];
    if (cell == nil){
        cell = [[VideoAlarmMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoAlarmMsgCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSAlarmInfo *ai = [_alarmList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", ai.alarmName, ai.alarmStart];
    cell.alarmInfo = ai;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoAlarmMsgCell cellHeight];
}


- (void)startPlaybackWithCell:(VideoAlarmMsgCell *)cell
{
    CPlaybackController *playbackController = [[CPlaybackController alloc] initWithNibName:@"CPlaybackController"
                                                                                    bundle:nil
                                                                                    camera:_cameraInfo];
    // 设置录像开始时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   *startTime    = [formatter dateFromString:cell.alarmInfo.alarmStart];
    NSTimeInterval fStartTime = [startTime timeIntervalSince1970];
    playbackController.fPlayStartTime = fStartTime;
    [self.navigationController pushViewController:playbackController animated:YES];
}

- (void)startRealPlayWithCell:(VideoAlarmMsgCell *)cell
{
    RealPlayViewController *realPlayController = [[RealPlayViewController alloc] init];
    realPlayController.cameraInfo = _cameraInfo;
    [self.navigationController pushViewController:realPlayController animated:YES];
}


#pragma mark - Private


- (void)searchAlarmList
{
    YSAlarmSearchInfo *si = [[YSAlarmSearchInfo alloc] init];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strStartTime = [formatter stringFromDate:date];
    NSDate   *startTime    = [formatter dateFromString:strStartTime];
    NSTimeInterval fStartTime = [startTime timeIntervalSince1970];
    NSTimeInterval fStopTime  = fStartTime + 23 * 3600.0 + 59 * 60 + 59;
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *csStartDate = [[NSDate alloc] initWithTimeIntervalSince1970:fStartTime];
    NSString *csStartTime = [formatter stringFromDate:csStartDate];
    
    NSDate *csStopDate = [[NSDate alloc] initWithTimeIntervalSince1970:fStopTime];
    NSString *csStopTime = [formatter stringFromDate:csStopDate];
    
    si.startTime = csStartTime;
    si.endTime = csStopTime;
    si.alarmType = -1; // 全部类型
    si.status = @"2";  // 全部状态
    
    [[YSHTTPClient sharedInstance] requestSearchAlarmListWithCameraId:_cameraId alarmSearchInfo:si pageFrom:0 pageSize:20 complition:^(id responseObject, NSError *error)
    {
        if (responseObject)
        {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSNumber *resultCode = [dictionary objectForKey:@"resultCode"];
            if (HTTP_REQUEST_OK_CODE == [resultCode intValue])
            {
                [self parseAlarmListWithDict:dictionary];
                
                [_tableView reloadData];
            }
        }
     
    }];
}

- (void)parseAlarmListWithDict:(NSDictionary *)dict
{
    [_alarmList removeAllObjects];
    
    NSArray *array = [dict objectForKey:@"alarmList"];
    for (int i = 0; i < [array count]; i++)
    {
        YSAlarmInfo *ai = [[YSAlarmInfo alloc] init];
        NSDictionary *dic = [array objectAtIndex:i];
        [ai setAlarmInfoFromDict:dic];
        [_alarmList addObject:ai];
    }
}

@end
