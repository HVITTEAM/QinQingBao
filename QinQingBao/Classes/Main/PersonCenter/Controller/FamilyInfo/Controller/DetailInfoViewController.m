//
//  DetailInfoViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "UpdateAddressController.h"
#import "TextFieldViewController.h"
#import "EditInfoTableViewController.h"
#import "HMCommonTextfieldItem.h"
#import "MTAddressPickController.h"
#import "RelationModel.h"

#import "EditContactViewController.h"
#import "AddContactViewController.h"

@interface DetailInfoViewController ()<UIAlertViewDelegate>
{
    HMCommonItem *nameItem;
    HMCommonArrowItem *telItem;
    HMCommonItem *IDItem;
    
    //可编辑姓名item
    HMCommonArrowItem *nameItem1;
}

@end

@implementation DetailInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
    
    [self initTableView];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"家属基本信息";
    self.view.backgroundColor = HMGlobalBg;
}

/**
 *  初始化表视图
 */
-(void)initTableView
{
    self.tableView.backgroundColor = HMGlobalBg;
    
    //设置底部按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 0, 50);
    [addBtn setTitle:@"+ 添加紧急联系人" forState:UIControlStateNormal];
    [addBtn setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = addBtn;
}

#pragma  mark -- 事件方法 --
/**
 *  添加紧急联系人
 */
-(void)addContact:(UIButton *)sender
{
    if (self.self.itemInfo.ud_sos.count ==3){
        return [NoticeHelper AlertShow:@"紧急联系人最多设置3个" view:nil];
    }
    
    AddContactViewController*vc = [[AddContactViewController alloc] init];
    vc.addResultClick = ^(RelationModel *item){
        if (!self.itemInfo.ud_sos)
            self.itemInfo.ud_sos = [[NSMutableArray alloc] init];
        [self.itemInfo.ud_sos addObject:item];
        [self uploadFamilyInforWithFamilyModel];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}



# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup0];
    
    [self setupGroup1];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    __weak typeof(self) weakSelf = self;
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    group.header = @"基本信息";
    
    [self.groups addObject:group];
    
    //姓名
    nameItem = [HMCommonItem itemWithTitle:@"姓名" icon:@""];
    nameItem.subtitle = self.itemInfo.ud_name;
    
    
    nameItem1 = [HMCommonArrowItem itemWithTitle:@"姓名" icon:@""];
    nameItem1.subtitle = self.itemInfo.ud_name;
    nameItem1.operation = ^{
        EditInfoTableViewController *textFieldVC = [[EditInfoTableViewController alloc]init];
        textFieldVC.titleStr = @"姓名";
        textFieldVC.contentStr = weakSelf.itemInfo.ud_name;
        textFieldVC.placeholderStr = @"请输入姓名";
        textFieldVC.finishUpdateOperation = ^(NSString *title,NSString *content,NSString *placeholder){
            weakSelf.itemInfo.ud_name = content;
            [weakSelf setupGroups];
            [weakSelf uploadFamilyInforWithFamilyModel];
        };
        [weakSelf.navigationController pushViewController:textFieldVC animated:YES];
    };
    
    
    //电话
    telItem = [HMCommonArrowItem itemWithTitle:@"昵称" icon:@""];
    telItem.subtitle = self.itemInfo.rel_name;
    telItem.operation = ^{
        EditInfoTableViewController *textFieldVC = [[EditInfoTableViewController alloc]init];
        textFieldVC.titleStr = @"昵称";
        textFieldVC.contentStr = weakSelf.itemInfo.rel_name;
        textFieldVC.placeholderStr = @"请输入家属昵称";
        textFieldVC.finishUpdateOperation = ^(NSString *title,NSString *content,NSString *placeholder){
            weakSelf.itemInfo.rel_name = content;
            [weakSelf setupGroups];
            [weakSelf uploadFamilyInforWithFamilyModel];
        };
        [weakSelf.navigationController pushViewController:textFieldVC animated:YES];
    };
    
    
    //身份证
    IDItem = [HMCommonItem itemWithTitle:@"身份证" icon:@""];
    IDItem.subtitle = self.itemInfo.ud_identity;
//    IDItem.operation = ^{
//        EditInfoTableViewController *textFieldVC = [[EditInfoTableViewController alloc]init];
//        textFieldVC.titleStr = @"身份证号";
//        textFieldVC.contentStr = weakSelf.itemInfo.ud_identity;
//        textFieldVC.placeholderStr = @"请输入正确的身份证号";
//        textFieldVC.finishUpdateOperation = ^(NSString *title,NSString *content,NSString *placeholder){
//            weakSelf.itemInfo.ud_identity = content;
//            [weakSelf setupGroups];
//            [weakSelf uploadFamilyInforWithFamilyModel];
//        };
//        [weakSelf.navigationController pushViewController:textFieldVC animated:YES];
//    };
    
    NSLog(@"%@,%@",self.itemInfo.member_id,[SharedAppUtil defaultCommonUtil].userVO.member_id);
    if ([self.itemInfo.member_id isEqualToString:[SharedAppUtil defaultCommonUtil].userVO.member_id])
        group.items = @[telItem,nameItem1,IDItem];
    else
        group.items = @[telItem,nameItem,IDItem];
}

/**
 *  设置第2个 section 数据
 */
- (void)setupGroup1
{
    //没有紧急联系人就不设置section
    if (self.itemInfo.ud_sos.count == 0) {
        return;
    }
    
    HMCommonGroup *group = [HMCommonGroup group];
    group.header = @"紧急联系人";
    
    NSMutableArray *tempItemArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemInfo.ud_sos.count; i++) {
        RelationModel *model = self.itemInfo.ud_sos[i];
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:[NSString stringWithFormat:@"%@   %@",model.sos_name,model.sos_phone]];
        item.subtitle = model.sos_relation;
        [tempItemArray addObject:item];
        model.index = i;
        item.operation = ^{
            EditContactViewController *editVC = [[EditContactViewController alloc] init];
            editVC.item = model;
            editVC.editResultClick = ^(RelationModel *relationMd){
                [self.itemInfo.ud_sos replaceObjectAtIndex:relationMd.index withObject:relationMd];
                [self uploadFamilyInforWithFamilyModel];
            };
            editVC.deleteResultClick = ^(RelationModel *relationMd){
                if (self.itemInfo.ud_sos.count <= 1) {
                    [[[UIAlertView alloc] initWithTitle:@"请至少保留一个紧急联系人" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    return;
                }
                [self.itemInfo.ud_sos removeObjectAtIndex:relationMd.index];
                [self uploadFamilyInforWithFamilyModel];
            };
            [self.navigationController pushViewController:editVC animated:YES];
        };
    }
    group.items = tempItemArray;
    [self.groups addObject:group];
}


# pragma  mark -- 协议方法 --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    //如果点击的不是取消按钮就更新数据
    [self setupGroups];
    [self uploadFamilyInforWithFamilyModel];
}

/**
 *  上传更新后的亲属信息
 */
-(void)uploadFamilyInforWithFamilyModel
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[SharedAppUtil defaultCommonUtil].userVO.member_id forKey:@"member_id"];
    [dict setValue:self.itemInfo.ud_id forKey:@"ud_id"];
    [dict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[self.itemInfo.ud_sos count]] forKey:@"sos_count"];
    [dict setValue:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    [dict setValue:@"ios" forKey:@"client"];
    [dict setValue:self.itemInfo.rel_name forKey:@"rel_name"];
//    [dict setValue:self.itemInfo.ud_identity forKey:@"ud_identity"];
    [dict setValue:self.itemInfo.ud_name forKey:@"ud_name"];
    
    for (int i = 1; i < self.itemInfo.ud_sos.count+1 ; i++)
    {
        RelationModel *obj = self.itemInfo.ud_sos[i-1];
        [dict setValue:obj.sos_name forKey:[NSString stringWithFormat:@"sos_name_%d",i]];
        [dict setValue:obj.sos_phone forKey:[NSString stringWithFormat:@"sos_phone_%d",i]];
        [dict setValue:obj.sos_relation forKey:[NSString stringWithFormat:@"sos_relation_%d",i]];
    }
    
    //    if (self.itemInfo.ud_sos.count == 0 )
    //        return [NoticeHelper AlertShow:@"请设置紧急联系人" view:nil];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_edit_user_devide parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"设置成功！");
                                         [self setupGroups];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

@end
