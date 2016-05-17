//
//  ProfileViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ProfileViewController.h"
#import "AboutViewController.h"
#import "FamilyViewController.h"
#import "SettingViewController.h"
#import "OrderTableViewController.h"
//#import "AccountViewController.h"
#import "PersonalDataViewController.h"
//#import "LoginViewController.h"
//#import "GoodsHeadViewController.h"
//#import "ClassificationViewController.h"
//#import "GoodsTableViewController.h"
//#import "ConfirmViewController.h"
#import "MTCouponsViewController.h"
//#import "AddressTableViewController.h"
//#import "GoodsViewController.h"
#import "GoodsTypeViewController.h"
#import "MyMesageViewController.h"
#import "BalanceViewController.h"
#import "SettlementSlideViewController.h"
#import "SWYSubtitleCell.h"
#import "ProfileConsumeCell.h"

@interface ProfileViewController ()
{
    NSURL *iconUrl;
    NSString *username;
    NSString *account;
}

@end

@implementation ProfileViewController

-(instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserIcon];
}


/**
 *  初始化界面
 */
-(void)setupUI
{
    self.navigationItem.title = @"我的";
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        SWYSubtitleCell *accountCell = [SWYSubtitleCell createSWYSubtitleCellWithTableView:tableView];
        
        if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        {
            accountCell.imageView.image =  [UIImage imageWithName:@"placeholderImage"];
            accountCell.textLabel.text = @"未登录";
            accountCell.detailTextLabel.text = @"登录后使用更多功能";
        }
        else
        {
            [accountCell.imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
            accountCell.textLabel.text = username;
            accountCell.detailTextLabel.text = [NSString stringWithFormat:@"账户：%@",account ? account : @""];
        }
        accountCell.showCorner = YES;
        accountCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = accountCell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        ProfileConsumeCell *consumeCell = [ProfileConsumeCell creatProfileConsumeCellWithTableView:tableView];
        consumeCell.tapConsumeCellBtnCallback = ^(ProfileConsumeCell *consumeCell,NSUInteger idx){
            
            if ([SharedAppUtil defaultCommonUtil].userVO == nil)
                return   [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
            if (idx == 1)
            {
                
                BalanceViewController *balanceVC = [[BalanceViewController alloc] init];
                [weakself.navigationController pushViewController:balanceVC animated:YES];
                return;
            }else if (idx == 2){
                MTCouponsViewController *balanceVC = [[MTCouponsViewController alloc] init];
                [weakself.navigationController pushViewController:balanceVC animated:YES];
                return;
            }
            [NoticeHelper AlertShow:@"尚未开通,敬请期待！" view:nil];
        };
        cell = consumeCell;
        
    }else{
        static NSString *commonCellId = @"commmCellId";
        cell = [tableView dequeueReusableCellWithIdentifier:commonCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            [self setCell:cell icon:@"pc_family.png" title:@"我的亲友"];
        }else if (indexPath.section == 1 && indexPath.row == 1){
            [self setCell:cell icon:@"pc_service.png" title:@"我的服务"];
        }else if (indexPath.section == 1 && indexPath.row == 2){
            [self setCell:cell icon:@"pc_goods.png" title:@"我的商品"];
        }else if (indexPath.section == 2 && indexPath.row == 0){
            [self setCell:cell icon:@"ic_msg.png" title:@"我的消息"];
        }else if (indexPath.section == 2 && indexPath.row == 1){
            [self setCell:cell icon:@"pc_setup.png" title:@"系统设置"];
        }else{
            [self setCell:cell icon:@"app.png" title:@"关于"];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置分割线
    [self setIndexPath:indexPath withCell:cell];
    
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section  < 2 || (indexPath.section  ==  2 && indexPath.row == 0)) && [SharedAppUtil defaultCommonUtil].userVO == nil)
        return   [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    Class class;
    if (indexPath.section == 0 && indexPath.row == 0) {
        class = [PersonalDataViewController class];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        class = [FamilyViewController class];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        class = [OrderTableViewController class];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        class = [GoodsTypeViewController class];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        class = [MyMesageViewController class];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        class = [SettingViewController class];
    }else if(indexPath.section == 2 && indexPath.row == 2){
        class = [AboutViewController class];
    }
    
    [self.navigationController pushViewController:[[class alloc] init] animated:YES];
    
}

#pragma mark - 与后台数据交互模块
/**
 *  获取用户数据数据
 */
-(void)getUserIcon
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         //NSLog(@"00000000000000%@",di);
                                         if ([di count] != 0)
                                         {
                                             NSString *url = (NSString*)[di objectForKey:@"member_avatar"];
                                             iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Icon,url]];
                                             username = (NSString*)[di objectForKey:@"member_truename"];
                                             account = (NSString*)[di objectForKey:@"member_mobile"];
                                         }
                                         
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

#pragma mark - 工具方法
/**
 *  设置cell的分割线
 */
- (void)setIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    
    int rows = (int)[self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    
    //设置背景view
    UIImageView *bgView = (UIImageView *)cell.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)cell.selectedBackgroundView;
    if (!bgView) {
        
        cell.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIImageView alloc] init];
        cell.backgroundView =bgView;
        
        selectedBgView = [[UIImageView alloc] init];
        cell.selectedBackgroundView = selectedBgView;
    }
    
    // 设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}

/**
 *  设置cell内容
 */
-(void)setCell:(UITableViewCell *)cell icon:(NSString *)iconName title:(NSString *)title
{
    cell.imageView.image = [UIImage imageNamed:iconName];
    cell.textLabel.text = title;
}

/**
 * 清空手机端访问网页的cookie
 **/
-(void)clearCookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

@end
