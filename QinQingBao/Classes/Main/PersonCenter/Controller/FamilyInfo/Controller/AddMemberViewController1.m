//
//  AddMemberViewController1.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/14.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AddMemberViewController1.h"

@interface AddMemberViewController1 ()
{
    
}

@end

@implementation AddMemberViewController1

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    self.title = @"添加家属";
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup1];
    [self setupFooter];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonTextfieldItem *numfield = [HMCommonTextfieldItem itemWithTitle:@"亲属昵称" icon:nil];
    numfield.placeholder = @"如:爷爷、奶奶、二大爷等";
    self.numfield = numfield;
    
    numfield.buttonClickBlock = ^(UIButton *btn){
        NSLog(@"----点击了确认按钮-");
        self.telfield.rightText.text = @"15261212811";
        self.telfield.rightText.clearButtonMode =  UITextFieldViewModeNever;
    };
    
    numfield.operation = ^{
        NSLog(@"----点击了n---%@",self.numfield.rightText.text);
    };
    
    HMCommonTextfieldItem *telfield = [HMCommonTextfieldItem itemWithTitle:@"身份证号" icon:nil];
    telfield.placeholder = @"绑定家属的身份证号";
    self.telfield = telfield;
    self.telfield.rightText.userInteractionEnabled = NO;
    telfield.operation = ^{
        NSLog(@"----点击了n---");
    };
    
    group.items = @[numfield,telfield];
}

- (void)setupFooter
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 80)];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(sureHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    [footview addSubview:okBtn];
    
    UIButton *changeType = [[UIButton alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(okBtn.frame) + 10, 120, 20)];
    changeType.titleLabel.font = [UIFont systemFontOfSize:13];
    [changeType setTitle:@"通过手机号码绑定" forState:UIControlStateNormal];
    [changeType setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
    [changeType addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [changeType.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:changeType.titleLabel.font}];
    
    changeType.width = size.width;
    changeType.x = MTScreenW - size.width - 10;
    [footview addSubview:changeType];
    
    self.tableView.tableFooterView = footview;
}

-(void)changeType
{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma  mark

/**
 *  确认绑定
 *
 *  @param sender <#sender description#>
 */
-(void)sureHandler:(id)sender
{
    [self.view endEditing:YES];
    if (self.numfield.rightText.text.length == 0)
    {
        [NoticeHelper AlertShow:@"请输入家属昵称" view:self.view];
        return;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Bang_relation parameters: @{ @"oldcardnum" : self.telfield.rightText.text,
                                                                       @"member_id":[SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                       @"rname" : self.numfield.rightText.text,
                                                                       @"client":@"ios",
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
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                         [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                         if (self.backHandlerClick)
                                             self.backHandlerClick();
                                         UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-3];
                                         [self.navigationController popToViewController:vc animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

@end
