//
//  MsgAndPushViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MsgAndPushViewController.h"
#import "PrivateLetterViewController.h"
#import "MyMesageViewController.h"

@interface MsgAndPushViewController ()

@property (nonatomic, strong) MyMesageViewController *vc1;
@property (nonatomic, strong) PrivateLetterViewController *vc2;
@end

@implementation MsgAndPushViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initRootController];
}

-(void)initRootController
{
    self.vc1 = [[MyMesageViewController alloc] init];
    self.vc1.parentVC = self;
    self.vc1.title = @"提醒";
    
    self.vc2 = [[PrivateLetterViewController alloc] init];
    self.vc1.parentVC = self;
    self.vc2.title = @"私信";
    
    self.viewArr = [NSMutableArray arrayWithObjects:self.vc1,self.vc2,nil];
}
@end
