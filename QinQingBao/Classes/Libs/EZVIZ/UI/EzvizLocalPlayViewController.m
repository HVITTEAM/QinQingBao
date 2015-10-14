//
//  EzvizLocalPlayViewController.m
//  EzvizOpenSDKDemo
//
//  Created by DeJohn Dong on 15/6/27.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import "EzvizLocalPlayViewController.h"
#import "YSPlayerController.h"

@interface EzvizLocalPlayViewController ()<YSPlayerControllerDelegate>{
    YSPlayerController *playerController;
    
    NSString *key;
    NSString *userCode;
    
}

@property (nonatomic, weak) IBOutlet UIView *playerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation EzvizLocalPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    playerController = [[YSPlayerController alloc] initWithDelegate:self];
    
    if([_params[@"pwd"] length] == 6){
        key = _params[@"pwd"];
    }else{
        userCode = _params[@"pwd"];
    }
    
    self.heightConstraint.constant = 160 * ([UIScreen mainScreen].bounds.size.width/320.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [playerController startLocalRealPayWithKey:key userId:userCode ip:_params[@"ip"] inView:self.playerView];
//    [playerController startLocalRealPayWithKey:@"IDASET" userId:@"" ip:_ip inView:self.playerView];
//    [playerController startLocalRealPayWithKey:nil userId:@"0483adcdcd8e4b299e25ea5a263e5454" ip:_ip inView:self.playerView];
//    [playerController startLocalRealPayWithKey:nil userId:@"caf6ec5ec7f94e61a2e43f4e983cb5da" ip:_ip inView:self.playerView];
    //db1461f472b3275b
//    [playerController startLocalRealPayWithKey:nil userId:@"db1461f472b3275b" ip:_ip inView:self.playerView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)playerOperationMessage:(YSPlayerMessageType)msgType withValue:(id)value{
    
}

@end
