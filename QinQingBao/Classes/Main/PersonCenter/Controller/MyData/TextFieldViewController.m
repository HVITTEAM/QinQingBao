//
//  TextFieldViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "TextFieldViewController.h"
#import "HMCommonTextfieldItem.h"

@interface TextFieldViewController ()

@end

@implementation TextFieldViewController
{
    HMCommonTextfieldItem *textItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.groups removeAllObjects];
    
    [self initNavigation];
    
    [self setupGroups];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_address parameters: @{@"dvcode_id" : @330102003050,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                    @"all": @"1"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict,  id responseObject) {
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
    
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
    self.title = [self.dict valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
    
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    textItem = [HMCommonTextfieldItem itemWithTitle:[self.dict valueForKey:@"text"] icon:nil];
    textItem.placeholder = [self.dict valueForKey:@"placeholder"];
    group.items = @[textItem];
    textItem.textValue = [self.dict valueForKey:@"value"];
    NSLog(@"%@",self.inforVO.member_name);
    [self.tableView reloadData];
}

-(void)doneClickHandler
{
    NSString *addressStr = [self.title isEqualToString:@"修改地址"] ? textItem.rightText.text : self.inforVO.member_areainfo;
    NSString *nameStr = [self.title isEqualToString:@"修改姓名"] ? textItem.rightText.text : self.inforVO.member_truename;
    NSString *mailStr = [self.title isEqualToString:@"修改邮箱"] ? textItem.rightText.text : self.inforVO.member_email;

    if ([self.title isEqualToString:@"修改邮箱"])
    {
        if (![self checkMailInput:textItem.rightText.text])
            return [NoticeHelper AlertShow:@"请输入正确的邮箱格式" view:nil];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"ios" forKey:@"client"];
    if (self.inforVO.member_sex != nil && [self.inforVO.member_sex floatValue] > 0)
        [dict setObject:self.inforVO.member_sex forKey:@"member_sex"];
    if (nameStr)
        [dict setObject:nameStr forKey:@"member_truename"];
    if (mailStr)
        [dict setObject:mailStr forKey:@"member_email"];
    if (self.inforVO.member_birthday != nil)
        [dict setObject:self.inforVO.member_birthday forKey:@"member_birthday"];
    if (addressStr)
        [dict setObject:addressStr forKey:@"member_areainfo"];
    if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
        [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_EditUserInfor parameters:dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                      if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存失败" message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [self.navigationController popViewControllerAnimated:YES];
                                         self.refleshDta();
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
    
}


- (BOOL)checkMailInput:(NSString *)mail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

@end
