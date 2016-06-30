//
//  MarketCustominfoController.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketCustominfoController.h"
#import "HMCommonTextfieldItem.h"

@interface MarketCustominfoController ()

@property (strong,nonatomic)HMCommonTextfieldItem *nameItem;

@property (strong,nonatomic)HMCommonTextfieldItem *telItem;

@property (strong,nonatomic)HMCommonTextfieldItem *addressItem;

@property (strong,nonatomic)HMCommonTextfieldItem *emailItem;

@property (copy,nonatomic)NSString *name;

@property (copy,nonatomic)NSString *tel;

@property (copy,nonatomic)NSString *address;

@property (copy,nonatomic)NSString *email;

@end

@implementation MarketCustominfoController

+(instancetype)initWith:(NSString *)name tel:(NSString *)tel address:(NSString *)address email:(NSString *)email
{
    MarketCustominfoController *vc = [[MarketCustominfoController alloc] init];
    vc.name = name;
    vc.tel = tel;
    vc.address = address;
    vc.email = email;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户信息";
    
    [self setupGroups];
    [self setupFooter];
}


-(void)setupGroups
{
    HMCommonGroup *group = [[HMCommonGroup alloc] init];
    [self.groups addObject:group];
    
    self.nameItem = [[HMCommonTextfieldItem alloc] init];
    self.nameItem.title = @"姓名";
    self.nameItem.placeholder = @"必填";
    self.nameItem.textValue = self.name;
    
    self.telItem = [[HMCommonTextfieldItem alloc] init];
    self.telItem.title = @"手机号";
    self.telItem.placeholder = @"必填";
    self.telItem.keyboardType = UIKeyboardTypeNumberPad;
    self.telItem.textValue = self.tel;
    
    self.addressItem = [[HMCommonTextfieldItem alloc] init];
    self.addressItem.title = @"地址";
    self.addressItem.placeholder = @"必填";
    self.addressItem.textValue = self.address;
    
    self.emailItem = [[HMCommonTextfieldItem alloc] init];
    self.emailItem.title = @"邮箱";
    self.emailItem.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.emailItem.placeholder = @"选填";
    self.emailItem.textValue = self.email;
    
    group.items = @[self.nameItem,self.telItem,self.addressItem,self.emailItem];

}

- (void)setupFooter
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 60, MTScreenW, 60)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 40, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor = HMColor(33, 193, 181);
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    
    self.tableView.tableFooterView = bottomView;
}

-(void)next:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    self.name = self.nameItem.rightText.text;
    if (self.name.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入姓名" view:nil];
    }
    
    self.tel = self.telItem.rightText.text;
    if (self.tel.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入手机号" view:nil];
    }
    
    if (![self validatePhoneNumOrEmail:self.tel type:1]) {
        return [NoticeHelper AlertShow:@"输入手机号码格式不正确" view:nil];
    }
    
    self.address = self.addressItem.rightText.text;
    if (self.address.length == 0) {
        return [NoticeHelper AlertShow:@"请输入地址" view:nil];
    }
    
    //邮箱选填,只有输入邮箱时才验证
    self.email = self.emailItem.rightText.text;
    if (self.email.length != 0) {
        if (![self validatePhoneNumOrEmail:self.email type:2]) {
            return [NoticeHelper AlertShow:@"输入邮箱格式不正确" view:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.inforClick)
    {
        self.inforClick(self.name,self.tel,self.address,self.email);
    }
}

/**
 *  验证手机或邮箱是否合法
 *
 *  @param phoneNumOrEmail 手机号码或邮箱
 *  @param type            1:表示验证手机号码,2:表示验证邮箱
 *
 *  @return  yes:表示通过验证,no表示未通过
 */
-(BOOL)validatePhoneNumOrEmail:(NSString *)phoneNumOrEmail type:(NSInteger)type
{
    //默认为验证手机号
    NSString *regular = @"^1[3578]\\d{9}$";
    if (type == 2) {
        //验证邮箱
        regular = @"^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";
    }
    
    NSPredicate *prediccate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    BOOL result =[prediccate evaluateWithObject:phoneNumOrEmail];
    return result;
    
}

@end
