//
//  EditContactViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EditContactViewController.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"

@interface EditContactViewController ()
{
    NSString *selectedRealationStr;
//    NSInteger selectedRealationIdx;
}
@property (nonatomic,retain) HMCommonArrowItem *item2;
@property (nonatomic,retain) HMCommonTextfieldItem *item0;
@property (nonatomic,retain) HMCommonTextfieldItem *item1;
@end

@implementation EditContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self setupGroups];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.item0.rightText.text = self.item.rname;
    self.item1.rightText.text = self.item.rtelnum;
    self.item1.rightText.keyboardType = UIKeyboardTypeNumberPad;
}

-(void)initTableSkin
{
    self.title = @"编辑联系人";
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
    __weak __typeof(self)weakSelf = self;
    
    selectedRealationStr = self.item.relation;
    
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.item0 = [HMCommonTextfieldItem itemWithTitle:@"联系人姓名" icon:nil];
    
    self.item0.placeholder = @"请填写真实姓名";

    self.item1 = [HMCommonTextfieldItem itemWithTitle:@"联系电话" icon:nil];
    self.item1.placeholder = @"请填写有效电话";
    
    self.item2 = [HMCommonArrowItem itemWithTitle:@"与亲友关系" icon:nil ];
    self.item2.subtitle = selectedRealationStr.length == 0  ? self.item.relation : selectedRealationStr;
    self.item2.operation = ^{
        UIAlertView *alertSex = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:@"" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"子女",@"配偶",@"其他监护人", nil];
        [alertSex show];    };
    group.items = @[self.item0,self.item1,self.item2];
}

- (void)setupFooter
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    // 1.创建按钮
    UIButton *delateBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, MTScreenW/2 - 20, 50)];
    
    // 2.设置属性
    delateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [delateBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delateBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [delateBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [delateBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [delateBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:delateBtn];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW/2 + 10, 0, MTScreenW/2 - 20, 46)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    okBtn.backgroundColor = MTNavgationBackgroundColor;
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:okBtn];
    
    self.tableView.tableFooterView = footview;
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        return;
//    selectedRealationIdx = buttonIndex;
    
    switch (buttonIndex)
    {
        case 1:
            selectedRealationStr = @"子女";
            break;
        case 2:
            selectedRealationStr = @"配偶";
            break;
        case 3:
            selectedRealationStr = @"其他监护人";
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
    else  if (selectedRealationStr.length == 0)
    {
        return [NoticeHelper AlertShow:@"请选择关系" view:nil];
    }
    RelationModel *obj = [[RelationModel alloc] init];
    obj.index = self.item.index;
    obj.rname = self.item0.rightText.text;
    obj.rtelnum = self.item1.rightText.text;
    obj.relation = selectedRealationStr;
    if (self.editResultClick)
        self.editResultClick(obj);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)delete:(UIButton *)sender
{
    RelationModel *obj = [[RelationModel alloc] init];
    obj.index = self.item.index;
    obj.rname = self.item0.rightText.text;
    obj.rtelnum = self.item1.rightText.text;
    obj.relation = selectedRealationStr;
    if (self.deleteResultClick)
        self.deleteResultClick(obj);
    [self.navigationController popViewControllerAnimated:YES];

}
@end
