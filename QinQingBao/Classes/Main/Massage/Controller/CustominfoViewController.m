//
//  CustominfoViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CustominfoViewController.h"
#import "HMCommonTextfieldItem.h"

@interface CustominfoViewController ()
{
    
}
@property (nonatomic,retain) HMCommonTextfieldItem *item0;
@property (nonatomic,retain) HMCommonTextfieldItem *item1;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@end

@implementation CustominfoViewController


+ (instancetype)itemWithName:(NSString *)name phpne:(NSString *)phpne
{
    CustominfoViewController *view = [[self alloc] init];
    view.name = name;
    view.phone = phpne;
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self setupGroups];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initTableSkin
{
    self.title = @"客户信息";
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
    
    // 2.设置组的所有行数据
    self.item0 = [HMCommonTextfieldItem itemWithTitle:@"客户姓名" icon:nil];
    self.item0.textValue = _name;
    self.item0.placeholder = @"请填写姓名";
    
    self.item1 = [HMCommonTextfieldItem itemWithTitle:@"客户电话" icon:nil];
    self.item1.placeholder = @"请填写有效电话";
    self.item1.textValue = _phone;
    self.item1.keyboardType = UIKeyboardTypeNumberPad;
    
    group.items = @[self.item0,self.item1];
}

- (void)setupFooter
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:okBtn];
    
    self.tableView.tableFooterView = footview;
}

-(void)next:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.item0.rightText.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入姓名" view:nil];
    }
    else  if (self.item1.rightText.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入电话" view:nil];
    }
    else if (self.item1.rightText.text.length != 11)
    {
        return [NoticeHelper AlertShow:@"请输入正确的手机号码格式" view:nil];
    }

    [self.navigationController popViewControllerAnimated:YES];
    if (self.inforClick)
        self.inforClick(self.item0.rightText.text,self.item1.rightText.text);
}

@end
