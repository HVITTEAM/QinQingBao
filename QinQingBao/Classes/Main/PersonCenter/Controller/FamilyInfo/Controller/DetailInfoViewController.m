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

@interface DetailInfoViewController ()<UIAlertViewDelegate>

@end

@implementation DetailInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"家属基本信息";
    self.view.backgroundColor = HMGlobalBg;
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
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    __weak typeof(self) weakSelf = self;
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    //姓名
    HMCommonItem *nameItem = [HMCommonItem itemWithTitle:@"姓名" icon:@""];
    nameItem.subtitle = self.itemInfo.member_truename;
    
    //电话
    HMCommonItem *telItem = [HMCommonItem itemWithTitle:@"电话号码" icon:@""];
    telItem.subtitle = self.itemInfo.member_mobile;
    
    //性别
    HMCommonArrowItem *sexItem = [HMCommonArrowItem itemWithTitle:@"性别" icon:@""];
    NSInteger sexCode = [self.itemInfo.member_sex integerValue];
    sexItem.subtitle = sexCode == 1?@"男":sexCode == 2?@"女":@"保密";
    sexItem.operation = ^{
        [[[UIAlertView alloc] initWithTitle:@"选择性别" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密",nil] show];
    };
    
    //身份证
    HMCommonArrowItem *IDItem = [HMCommonArrowItem itemWithTitle:@"身份证" icon:@""];
    IDItem.subtitle = self.itemInfo.identity;
    IDItem.operation = ^{
        EditInfoTableViewController *textFieldVC = [[EditInfoTableViewController alloc]init];
        textFieldVC.titleStr = @"身份证号";
        textFieldVC.contentStr = weakSelf.itemInfo.identity;
        textFieldVC.placeholderStr = @"请输入正确的身份证号";
        textFieldVC.finishUpdateOperation = ^(NSString *title,NSString *content,NSString *placeholder){
            weakSelf.itemInfo.identity = content;
            [weakSelf setupGroups];
            [weakSelf uploadFamilyInforWithFamilyMode:self.itemInfo];
        };
        [weakSelf.navigationController pushViewController:textFieldVC animated:YES];
    };
    
    //居住地址
    
    NSString * addressString;
    if (self.itemInfo.totalname && self.itemInfo.member_areainfo)
       addressString  =[NSString stringWithFormat:@"%@%@",self.itemInfo.totalname,self.itemInfo.member_areainfo];
    
    HMCommonArrowItem *addressItem = [HMCommonArrowItem itemWithTitle:@"居住地址" icon:nil];
    addressItem.subtitle = !addressString ? @"" :addressString;
    
    addressItem.operation = ^{
        MTAddressPickController *textView = [[MTAddressPickController alloc] init];
        textView.changeDataBlock = ^(AreaModel *selectedRegionmodel, NSString *addressStr,NSString *areaInfo){
            weakSelf.itemInfo.member_areainfo = areaInfo;
            weakSelf.itemInfo.member_areaid = selectedRegionmodel.area_id;
            NSRange range = [addressStr rangeOfString:areaInfo];
            weakSelf.itemInfo.totalname = [addressStr substringToIndex:range.location];
            [weakSelf setupGroups];
            [weakSelf uploadFamilyInforWithFamilyMode:self.itemInfo];
        };
        textView.title = @"居住地址";
        [weakSelf.navigationController pushViewController:textView animated:YES];
    };
    
    group.items = @[nameItem,telItem,sexItem,IDItem,addressItem];
}

# pragma  mark -- 协议方法 --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    //如果点击的不是取消按钮就更新数据
    self.itemInfo.member_sex = [NSString stringWithFormat:@"%d",(int)buttonIndex];
    [self setupGroups];
    [self uploadFamilyInforWithFamilyMode:self.itemInfo];
}

/**
 *  上传更新后的亲属信息
 */
-(void)uploadFamilyInforWithFamilyMode:(FamilyModel *)model
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                                    @"client":@"ios",
                                                                                    @"re_member_id":model.member_id
                                                                                    }];
    
    [params setValue:model.member_sex forKey:@"member_sex"];
    [params setValue:model.identity forKey:@"identity"];
    [params setValue:model.member_areaid forKey:@"member_areaid"];
    [params setValue:model.member_areainfo forKey:@"member_areainfo"];
    [params setValue:model.re_nicename forKey:@"re_nicename"];
    
    [CommonRemoteHelper RemoteWithUrl:URL_edit_relation_data parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        if ([dict[@"code"] integerValue] == 0) {
            
        }else if ([dict[@"code"] integerValue] == 11013) {
            //            [NoticeHelper  AlertShow:dict[@"errorMsg"] view:self.tableView];
        }else if ([dict[@"code"] integerValue] == 11010){
            //            [NoticeHelper  AlertShow:dict[@"errorMsg"] view:self.tableView];
        }else if ([dict[@"code"] integerValue] == 14001){
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper  AlertShow:@"请求失败" view:self.tableView];
    }];
}

@end
