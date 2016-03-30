//
//  EmergencyContactViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EmergencyContactViewController.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"
#import "HeadProcessView.h"

#import "AddContactViewController.h"
#import "EditContactViewController.h"

#import "RelationTotal.h"
#import "RelationModel.h"
#import "BindingResultViewController.h"


@interface EmergencyContactViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *relationArr;
}
@property (nonatomic,retain) HMCommonArrowItem *item0;
@property (nonatomic,retain) HMCommonTextfieldItem *item1;
@property (nonatomic,retain) HMCommonButtonItem *itemBtn;
@end

@implementation EmergencyContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self setupGroups];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

-(void)initTableSkin
{
    self.title = @"紧急联系人";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
    [self.groups removeAllObjects];
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    NSMutableArray *itemarr = [[NSMutableArray alloc] init];
    for (RelationModel *obj in relationArr)
    {
        // 2.设置组的所有行数据
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:[NSString stringWithFormat:@"%@    %@",obj.sos_name,obj.sos_phone] icon:nil];
        item.subtitle = obj.sos_relation;
        obj.index = [relationArr indexOfObject:obj];
        item.operation = ^{
            EditContactViewController *vc = [[EditContactViewController alloc] init];
            vc.editResultClick = ^(RelationModel *item){
                [relationArr replaceObjectAtIndex:item.index withObject:item];
                [self setupGroup];
                [self.tableView reloadData];
                [self.navigationController popViewControllerAnimated:YES];
            };
            vc.deleteResultClick = ^(RelationModel *item){
                [relationArr removeObjectAtIndex:item.index];
                [self setupGroup];
                [self.tableView reloadData];
                [self.navigationController popViewControllerAnimated:YES];
            };
            vc.item = obj;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [itemarr addObject:item];
    }
    group.items = [itemarr copy];
    [self.tableView reloadData];
}

- (void)setupFooter
{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    HeadProcessView *proView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    proView.backgroundColor = HMGlobalBg;
    [proView initWithShowIndex:2];
    [headview addSubview:proView];
    
    // 1.创建按钮
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, MTScreenW, 50)];
    
    // 2.设置属性
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addBtn setTitle:@"+ 添加紧急联系人" forState:UIControlStateNormal];
    [addBtn setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    [headview addSubview:addBtn];
    
    
    self.tableView.tableHeaderView = headview;
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:okBtn];
    
    self.tableView.tableFooterView = footview;
}

-(void)addContact:(UIButton *)sender
{
    if (relationArr.count ==3)
        return [NoticeHelper AlertShow:@"紧急联系人最多设置3个" view:nil];
    AddContactViewController *vc = [[AddContactViewController alloc] init];
    vc.addResultClick = ^(RelationModel *item){
        if (!relationArr)
            relationArr = [[NSMutableArray alloc] init];
        [relationArr addObject:item];
        [self setupGroup];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)next:(UIButton *)sender
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[SharedAppUtil defaultCommonUtil].userVO.member_id forKey:@"member_id"];
    [dict setValue:self.ud_id forKey:@"ud_id"];
    [dict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[relationArr count]] forKey:@"sos_count"];
    [dict setValue:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    [dict setValue:@"ios" forKey:@"client"];
    for (int i = 1; i < relationArr.count+1 ; i++)
    {
        RelationModel *obj = relationArr[i-1];
        [dict setValue:obj.sos_name forKey:[NSString stringWithFormat:@"sos_name_%d",i]];
        [dict setValue:obj.sos_phone forKey:[NSString stringWithFormat:@"sos_phone_%d",i]];
        [dict setValue:obj.sos_relation forKey:[NSString stringWithFormat:@"sos_relation_%d",i]];
    }
    
    if (relationArr.count == 0 )
        return [NoticeHelper AlertShow:@"请设置紧急联系人" view:nil];
    
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
                                         [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                         BindingResultViewController *vc = [[BindingResultViewController alloc] init];
                                         [self.navigationController pushViewController:vc animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

#pragma  mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)back
{
    if (!self.isFromStart)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认退出绑定流程？退出后可以在个人中心-->我的亲友中完成后续操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确认退出",nil];
        [alertView show];
    }
}
@end
