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
    self.nameItem.placeholder = @"请输入姓名";
    self.nameItem.textValue = self.name;
    
    self.telItem = [[HMCommonTextfieldItem alloc] init];
    self.telItem.title = @"电话";
    self.telItem.placeholder = @"必填";
    self.telItem.textValue = self.tel;
    
    self.addressItem = [[HMCommonTextfieldItem alloc] init];
    self.addressItem.title = @"地址";
    self.addressItem.placeholder = @"必填";
    self.addressItem.textValue = self.address;
    
    self.emailItem = [[HMCommonTextfieldItem alloc] init];
    self.emailItem.title = @"邮箱";
    self.emailItem.placeholder = @"必填";
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
        return [NoticeHelper AlertShow:@"请输入电话" view:nil];
    }
    if (self.tel.length != 11)
    {
        return [NoticeHelper AlertShow:@"请输入正确的手机号码格式" view:nil];
    }
    
    self.address = self.addressItem.rightText.text;
    if (self.address.length == 0) {
        return [NoticeHelper AlertShow:@"请输入地址" view:nil];
    }
    
    self.email = self.emailItem.rightText.text;
    if (self.email.length == 0) {
        return [NoticeHelper AlertShow:@"请输入邮箱地址" view:nil];
    }

    [self.navigationController popViewControllerAnimated:YES];
    if (self.inforClick)
    {
        self.inforClick(self.name,self.tel,self.address,self.email);
    }
}

@end
