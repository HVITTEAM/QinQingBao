//
//  ConfirmViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ConfirmViewController.h"
#import "ConfirmOrderEndView.h"

static CGFloat ENDVIEW_HEIGHT = 50;

@interface ConfirmViewController ()
{
    
}

@property (nonatomic,strong) ConfirmOrderEndView *endView;

@end



@implementation ConfirmViewController


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
    
    self.view.backgroundColor = HMGlobalBg;
    _endView = [[ConfirmOrderEndView alloc]initWithFrame:CGRectMake(0, MTScreenH - ENDVIEW_HEIGHT, MTScreenW,ENDVIEW_HEIGHT)];
//    _endView.delegate = self;
    [self.view addSubview:_endView];

}



@end
