//
//  YSShowDeviceCaptureViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 10/22/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSShowDeviceCaptureViewController.h"

@interface YSShowDeviceCaptureViewController ()

@end

@implementation YSShowDeviceCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_captureImageView setImage:_image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
