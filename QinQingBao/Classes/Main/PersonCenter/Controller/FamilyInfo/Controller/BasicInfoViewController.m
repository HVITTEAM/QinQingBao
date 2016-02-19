//
//  BasicInfoViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "AddDeviceViewController.h"
#import "UpdateAddressController.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"
#import "HeadProcessView.h"

@interface BasicInfoViewController ()<UIAlertViewDelegate>
{
    NSInteger selectedSexIdx;
    NSString *selectedSexStr;
    
    NSString *selectedAddressStr;
    NSString *selectedCodeStr;
    
    
}
@property (nonatomic,retain) HMCommonTextfieldItem *itemNick;
@property (nonatomic,retain) HMCommonTextfieldItem *itemTel;

@property (nonatomic,retain) HMCommonArrowItem *itemSex;
@property (nonatomic,retain) HMCommonTextfieldItem *itemName;
@property (nonatomic,retain) HMCommonTextfieldItem *itemId;
@property (nonatomic,retain) HMCommonArrowItem *itemAddress;




@end

@implementation BasicInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self setupGroups];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.itemTel.rightText.keyboardType = UIKeyboardTypeNumberPad;
    self.itemId.rightText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

-(void)initTableSkin
{
    self.title = @"基本信息登记";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设备解绑" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
    [self setupGroup1];
    [self setupFooter];
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.itemNick = [HMCommonTextfieldItem itemWithTitle:@"亲属昵称" icon:nil];
    self.itemNick.placeholder = @"如:爷爷、奶奶等";
    self.itemNick.buttonClickBlock = ^(UIButton *btn){
        NSLog(@"----点击了确认按钮-");
        //        self.telfield.rightText.text = @"15261212811";
        //        self.telfield.rightText.clearButtonMode =  UITextFieldViewModeNever;
    };
    
    self.itemNick.operation = ^{
        
    };
    
    self.itemTel = [HMCommonTextfieldItem itemWithTitle:@"手机号码" icon:nil];
    self.itemTel.placeholder = @"请输入手机号码";
    self.itemTel.operation = ^{
        NSLog(@"----点击了n---");
    };
    
    group.items = @[self.itemNick,self.itemTel];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.itemName = [HMCommonTextfieldItem itemWithTitle:@"姓名" icon:nil];
    self.itemName.placeholder = @"请填写真实姓名";
    self.itemName.operation = ^{
        
    };
    
    self.itemSex = [HMCommonArrowItem itemWithTitle:@"性别" icon:nil];
    self.itemSex.subtitle = selectedSexStr.length == 0 ? @"选填项" : selectedSexStr;
    __weak __typeof(self)weakSelf = self;
    self.itemSex.operation = ^{
        UIAlertView *alertSex = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:@"" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil];
        [alertSex show];
    };
    
    self.itemId = [HMCommonTextfieldItem itemWithTitle:@"身份证" icon:nil];
    self.itemId.placeholder = @"选填项";
    self.itemId.operation = ^{
        NSLog(@"----点击了n---");
    };
    
    self.itemAddress = [HMCommonArrowItem itemWithTitle:@"居住地址" icon:nil];
    self.itemAddress.subtitle = selectedAddressStr.length == 0 ? @"选填项" : selectedAddressStr;
    self.itemAddress.operation = ^{
        UpdateAddressController *textView = [[UpdateAddressController alloc] init];
        //        textView.inforVO = infoVO;
        textView.changeDataBlock = ^(NSDictionary *dict, NSString *addressStr){
            selectedCodeStr = [dict objectForKey:@"member_areaid"];
            selectedAddressStr = [NSString stringWithFormat:@"%@%@",addressStr,[dict objectForKey:@"member_areainfo"]];
            [weakSelf.groups removeAllObjects];
            [weakSelf setupGroups];
            [weakSelf.tableView reloadData];
        };
        textView.title = @"居住地址";
        [weakSelf.navigationController pushViewController:textView animated:YES];
    };
    group.items = @[self.itemName,self.itemSex,self.itemId,self.itemAddress];
}

- (void)setupFooter
{
    HeadProcessView *headView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    headView.backgroundColor = HMGlobalBg;
    [headView initWithShowIndex:0];
    self.tableView.tableHeaderView = headView;
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:okBtn];
    
    self.tableView.tableFooterView = footview;
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        return;
    selectedSexIdx = buttonIndex;
    
    switch (buttonIndex)
    {
        case 1:
            selectedSexStr = @"男";
            break;
        case 2:
            selectedSexStr = @"女";
            break;
        case 3:
            selectedSexStr = @"保密";
            break;
        default:
            break;
    }
    [self.groups removeAllObjects];
    [self setupGroups];
    [self.tableView reloadData];
}

-(void)next:(UIButton *)sender
{
    AddDeviceViewController *view = [[AddDeviceViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    return;
    
    [self.view endEditing:YES];
    
    if (self.itemNick.rightText.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入家属昵称" view:nil];
    }
    else if (self.itemName.rightText.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入家属真实姓名" view:nil];
    }
    else if (self.itemTel.rightText.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入家属手机号码" view:nil];
    }
    else if (self.itemTel.rightText.text.length != 11)
    {
        return [NoticeHelper AlertShow:@"请输入正确的手机号码格式" view:nil];
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Add_mobile_user parameters: @{@"username" : self.itemNick.rightText.text,
                                                                        @"truename":self.itemName.rightText.text,
                                                                        @"sex" : selectedSexIdx ? [NSString stringWithFormat:@"%ld",(long)selectedSexIdx] : @"",
                                                                        @"mobile":self.itemTel.rightText.text,
                                                                        @"areaid":selectedCodeStr ? selectedCodeStr:  @"" ,
                                                                        @"areainfo":selectedAddressStr ? selectedAddressStr : @"",
                                                                        @"identity":self.itemId.rightText.text ?  self.itemId.rightText.text : @""}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [self bangdin];
                                         NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                         NSString *member_id = [dict1 objectForKey:@"member_id"];
                                         AddDeviceViewController *view = [[AddDeviceViewController alloc] init];
                                         view.member_id = member_id;
                                         [self.navigationController pushViewController:view animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

/**用户增加完成之后绑定家属**/
-(void)bangdin
{
    [CommonRemoteHelper RemoteWithUrl:URL_Bang_relation parameters: @{@"mobile" : self.itemTel.rightText.text,
                                                                      @"member_id":[SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                      @"rname" : self.itemNick.rightText.text,
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
                                         NSLog(@"用户关系绑定成功");
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];

}

/**临时方法 解绑设备*/
-(void)delete
{
    [CommonRemoteHelper RemoteWithUrl:URL_Del_device parameters: @{@"imei" : @"626010120141513"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解绑成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

@end
