//
//  MyMesageViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/3/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MyMesageViewController.h"
#import "EventInfoController.h"


@interface MyMesageViewController ()

@end

@implementation MyMesageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
    self.view.backgroundColor  = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    if (commonCell == nil)
        commonCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
    commonCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:16];
    commonCell.imageView.image = [UIImage imageNamed:@"1.png"];
    switch (indexPath.row) {
        case 0:
            commonCell.textLabel.text = @"活动资讯";
            break;
        case 1:
            commonCell.textLabel.text = @"健康小贴士";
            break;
        case 2:
            commonCell.textLabel.text = @"通知消息";
            break;
        case 3:
            commonCell.textLabel.text = @"物流助手";
            break;
        default:
            break;
    }
    return commonCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventInfoController *vc = [[EventInfoController alloc] init];
    switch (indexPath.row)
    {
        case 0:
            vc.type = MessageTypeEventinfo;
            vc.title = @"活动资讯";
            break;
        case 1:
            vc.type = MessageTypeHealthTips;
            vc.title = @"健康小贴士";
            break;
        case 2:
            vc.type = MessageTypePushMsg;
            vc.title = @"通知消息";
            break;
        case 3:
            vc.type = MessageTypeLogistics;
            vc.title = @"物流助手";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}




@end
