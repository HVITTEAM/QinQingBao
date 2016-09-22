//
//  ChangePwdViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/12.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    [self setupGroups];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = HMStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(HMStatusCellMargin - 35, 0, 0, 0);
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"修改密码";
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
    [self setupFooter];
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonTextfieldItem *old = [HMCommonTextfieldItem itemWithTitle:@"旧密码" icon:@""];
    old.placeholder = @"请输入旧密码";
    old.secureTextEntry = YES;
    self.old = old;
    
    HMCommonTextfieldItem *now = [HMCommonTextfieldItem itemWithTitle:@"新的密码" icon:@""];
    now.secureTextEntry = YES;
    now.placeholder = @"请输入新密码";
    self.nowpwd = now;
    
    HMCommonTextfieldItem *cknowpwd = [HMCommonTextfieldItem itemWithTitle:@"确认密码" icon:@""];
    cknowpwd.placeholder = @"请再输入一次新密码";
    cknowpwd.secureTextEntry = YES;
    self.cknowPwd = cknowpwd;
    
    group.items = @[old,now,cknowpwd];
}

- (void)setupFooter
{
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"确定" forState:UIControlStateNormal];
    [logout setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(sureHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = 50;
    
    self.tableView.tableFooterView = logout;
}

-(void)sureHandler:(UIButton *)sender
{
    //去除左右两边空格
    NSString *str1 = [self.nowpwd.rightText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *str2 = [self.cknowPwd.rightText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *str3 = [self.old.rightText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //旧密码
    NSString *oldpwd = [SharedAppUtil defaultCommonUtil].userVO.pwd;
    if([str1 isEqualToString:oldpwd])
        return [NoticeHelper AlertShow:@"新密码和旧密码不能相同" view:self.view];
    if(str1.length < 6 )
        return [NoticeHelper AlertShow:@"新密码不能少于6位!" view:self.view];
    if(![str1 isEqualToString:str2] )
        return [NoticeHelper AlertShow:@"两次密码输入不同!" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_ChangePWD_New parameters: @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                  @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                  @"client" : @"ios",
                                                                  @"oldpassword" : [SecurityUtil encryptMD5String:str3],
                                                                  @"newpassword" : [SecurityUtil encryptMD5String:str1],
                                                                  @"confirmpassword" : [SecurityUtil encryptMD5String:str2]}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                     
                                     if (dict == nil)
                                         return [NoticeHelper AlertShow:@"未知错误！" view:self.view];
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [NoticeHelper AlertShow:@"修改成功！" view:self.view];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [NoticeHelper AlertShow:@"修改失败!" view:self.view];
                                 }];
    
}

@end
