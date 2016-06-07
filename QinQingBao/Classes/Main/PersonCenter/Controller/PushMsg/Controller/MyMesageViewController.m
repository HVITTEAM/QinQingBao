//
//  MyMesageViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/3/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MyMesageViewController.h"
#import "EventInfoController.h"
#import "MessageTypeCell.h"
#import "FristMsgModel.h"

/**
 *  活动咨询上一次获取消息的ID
 */
#define kEventInfo @"EventInfo_ID"
/**
 *  健康小贴士上一次获取消息的ID
 */
#define kHealthTips @"healthTips_ID"
/**
 *  通知消息上一次获取消息的ID
 */
#define kPushMsg @"pushMsg_ID"
/**
 *  物流助手上一次获取消息的ID
 */
#define kLogistics @"logistics_ID"


@interface MyMesageViewController ()
{
    NSDictionary *dataProvider;
    
    FristMsgModel *eventInfo;
    
    NSString *eventInfo_ID;
    NSString *healthTips_ID;
    NSString *pushMsg_ID;
    NSString *logistics_ID;
}

@end

@implementation MyMesageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
    self.view.backgroundColor  = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //判断消息未读与已读
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    eventInfo_ID = [standard objectForKey:kEventInfo];
    healthTips_ID = [standard objectForKey:kHealthTips];
    pushMsg_ID = [standard objectForKey:kPushMsg];
    logistics_ID = [standard objectForKey:kLogistics];
    
    [self getDataProvider];
    
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_get_systemmsginfos_by_type_first parameters: @{@"client" : @"ios",
                                                                                         @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         //                                         dataProvider = [FristMsgModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         dataProvider = [dict objectForKey:@"datas"];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
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
    MessageTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"MTMessageTypeCell"];
    
    if (typeCell == nil)
        typeCell =  [MessageTypeCell messageTypeCell];
    
    NSArray *itemArr =  [FristMsgModel objectArrayWithKeyValuesArray:[dataProvider objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]]];
    
    FristMsgModel *item;
    if (itemArr && itemArr.count > 0)
    {
        item = itemArr[0];
        typeCell.timeLab.text = item.push_time;
        typeCell.subtitleLab.text = item.msg_title;
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            typeCell.headImg.image = [UIImage imageNamed:@"eventinfo.png"];
            typeCell.titleLab.text = @"活动资讯";
            if (item && eventInfo_ID && ![eventInfo_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = NO;
            }
            else if (item && eventInfo_ID && [eventInfo_ID isEqualToString:item.systemmsg_id]){
                typeCell.badgeView.hidden = YES;
            }
        }
            break;
        case 1:
        {
            typeCell.headImg.image = [UIImage imageNamed:@"healthTips.png"];
            typeCell.titleLab.text = @"健康小贴士";
            if (item && healthTips_ID && ![healthTips_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = NO;
            }
            else  if (item && healthTips_ID && [healthTips_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = YES;
            }
        }
            break;
        case 2:
        {
            typeCell.headImg.image = [UIImage imageNamed:@"pushMsg.png"];
            typeCell.titleLab.text = @"通知消息";
            if (item && pushMsg_ID && ![pushMsg_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = NO;
            }
            else if (item && pushMsg_ID && [pushMsg_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = NO;
            }
        }            break;
        case 3:
        {
            typeCell.headImg.image = [UIImage imageNamed:@"logistics.png"];
            typeCell.titleLab.text = @"物流助手";
            if (item && logistics_ID && ![logistics_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = NO;
            }
            else  if (item && logistics_ID && [logistics_ID isEqualToString:item.systemmsg_id]) {
                typeCell.badgeView.hidden = NO;
            }
        }
            break;
        default:
            break;
    }
    
    return typeCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemArr =  [FristMsgModel objectArrayWithKeyValuesArray:[dataProvider objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]]];
    FristMsgModel *item;
    if (itemArr && itemArr.count > 0)
        item = itemArr[0];
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    EventInfoController *vc = [[EventInfoController alloc] init];
    switch (indexPath.row)
    {
        case 0:
        {
            vc.type = MessageTypeEventinfo;
            vc.title = @"活动资讯";
            if (item)
            {
                [standard setObject:item.systemmsg_id forKey:kEventInfo];
            }
        }
            break;
        case 1:
        {
            vc.type = MessageTypeHealthTips;
            vc.title = @"健康小贴士";
            
            if (item)
            {
                [standard setObject:item.systemmsg_id forKey:kHealthTips];
            }
        }
            break;
        case 2:
        {
            vc.type = MessageTypePushMsg;
            vc.title = @"通知消息";
            if (item)
            {
                [standard setObject:item.systemmsg_id forKey:kPushMsg];
            }
        }
            break;
        case 3:
        {
            vc.type = MessageTypeLogistics;
            vc.title = @"物流助手";
            if (item)
            {
                [standard setObject:item.systemmsg_id forKey:kLogistics];
            }
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



@end
