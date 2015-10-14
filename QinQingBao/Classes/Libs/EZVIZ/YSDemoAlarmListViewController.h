//
//  YSDemoAlarmListViewController.h
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/18/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSCameraInfo;

@interface YSDemoAlarmListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YSCameraInfo *cameraInfo;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       cameraId:(NSString *)cid;


@end
