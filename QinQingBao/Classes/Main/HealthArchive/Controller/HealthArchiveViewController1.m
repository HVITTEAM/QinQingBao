//
//  HealthArchiveViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//


#import "HealthArchiveViewController1.h"
#import "HealthArchiveViewController2.h"

#import "AddressController.h"
#import "TextCell.h"
#import "TextTwoCell.h"
#import "CommonRulerViewController.h"
#import "HeadProcessView.h"

#define kContent @"cellContent"
#define kTitle @"cellTitle"
#define kPlaceHolder @"cellPlaceHolder"

@interface HealthArchiveViewController1 ()

@property (strong,nonatomic)NSArray *datas;     //UITableView数据源

@property (strong,nonatomic)UIControl* dateSelectView;

@property (strong,nonatomic)UIDatePicker *datePicker;

@property (strong,nonatomic)NSIndexPath *currentIdx;

@end

@implementation HealthArchiveViewController1

-(instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.title = @"健康档案";
    
    if (!_archiveData) {
        _archiveData = [[ArchiveData alloc] init];
    }
    
    [self setupFooter];
}

-(NSArray *)datas
{
    if (!_datas) {
        NSMutableDictionary *(^createItem)(NSString *content,NSString *title,NSString *placeHolder) = ^NSMutableDictionary *(NSString *content,NSString *title,NSString *placeHolder){
            
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            [item setValue:content forKey:kContent];
            [item setValue:title forKey:kTitle];
            [item setValue:placeHolder forKey:kPlaceHolder];
            return item;
        };
        
        NSMutableArray *section0 = [[NSMutableArray alloc] init];
        //设置默认值
        NSString *diabetes = self.archiveData.diabetes.length!=0?self.archiveData.diabetes:@"0";
        NSString *hereditarycardiovascular = self.archiveData.hereditarycardiovascular.length!=0?self.archiveData.hereditarycardiovascular:@"0";
        [section0 addObject:createItem(diabetes,@"是否患有糖尿病",@"")];
        [section0 addObject:createItem(self.archiveData.medicalhistory,@"其它既往病史",@"请填写")];
        [section0 addObject:createItem(hereditarycardiovascular,@"父母亲是否有心血管病史",@"")];
        [section0 addObject:createItem(self.archiveData.geneticdisease,@"其它家族病史",@"请填写")];
        [section0 addObject:createItem(self.archiveData.physicalcondition,@"当前身体情况",@"请填写")];
        [section0 addObject:createItem(self.archiveData.events,@"个人健康方面的重大事件",@"请填写")];
        [section0 addObject:createItem(self.archiveData.takingdrugs,@"在服用的药物及营养素",@"请填写")];

        self.datas = @[section0];
    }
    return _datas;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)self.datas[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *sections = self.datas[indexPath.section];
    NSMutableDictionary *rowItem = sections[indexPath.row];
    
    if (indexPath.row == 0 || indexPath.row == 2)
    {
        TextCell *textCell = [TextCell createCellWithTableView:tableView];
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 23)];
        switchBtn.onTintColor = [UIColor orangeColor];
        switchBtn.tag = indexPath.row;
        [switchBtn addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];

        textCell.accessoryView = switchBtn;
        textCell.textLabel.text = rowItem[kTitle];
        textCell.textLabel.font = [UIFont systemFontOfSize:16];
        textCell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
        textCell.field.placeholder = rowItem[kPlaceHolder];
        textCell.field.enabled = NO;
        
        //不是档案创建者不允许修改
        if (!self.isAddArchive && !self.isCreator) {
            switchBtn.enabled = NO;
        }
        
        switchBtn.on = [rowItem[kContent] boolValue];
        
        return textCell;
    }
    else
    {
        TextTwoCell *textTwoCel = [TextTwoCell createCellWithTableView:tableView];
        textTwoCel.titleLb.text = rowItem[kTitle];
        textTwoCel.titleLb.font = [UIFont systemFontOfSize:16];
        textTwoCel.titleLb.textColor = [UIColor colorWithRGB:@"333333"];
        textTwoCel.contentTextView.text = rowItem[kContent];
        textTwoCel.placeHolderLb.text = rowItem[kPlaceHolder];
        if (textTwoCel.contentTextView.text.length > 0) {
            textTwoCel.placeHolderLb.hidden = YES;
        }else{
            textTwoCel.placeHolderLb.hidden = NO;
        }
        
        textTwoCel.idx = indexPath;
        textTwoCel.contentChangeCallBack = ^(NSIndexPath *idx,NSString *contentStr){
            weakSelf.datas[idx.section][idx.row][kContent] = contentStr;
        };
        
        //不是档案创建者不允许修改
        if (!self.isAddArchive && !self.isCreator) {
            textTwoCel.contentTextView.editable = NO;
        }
        
        return textTwoCel;
        
    }
    return nil;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2) {
        return 50;
    }
    return 114;
}

#pragma mark - 设置footer View

- (void)setupFooter
{
    HeadProcessView *headView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    headView.backgroundColor = [UIColor clearColor];
    [headView initWithShowIndex:1];
    self.tableView.tableHeaderView = headView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, MTScreenW - 40, 40)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRGB:@"70a426"];
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    
    self.tableView.tableFooterView = bottomView;
}

#pragma mark - 事件方法
/**
 *  点击确定按钮后调用
 */
-(void)next:(UIButton *)sender
{
    [self.view endEditing:YES];

    //糖尿病,心血管病史必填,默认是0
    self.archiveData.diabetes = self.datas[0][0][kContent];
    self.archiveData.medicalhistory = self.datas[0][1][kContent];
    self.archiveData.hereditarycardiovascular = self.datas[0][2][kContent];
    self.archiveData.geneticdisease = self.datas[0][3][kContent];
    self.archiveData.physicalcondition = self.datas[0][4][kContent];
    self.archiveData.events = self.datas[0][5][kContent];
    self.archiveData.takingdrugs = self.datas[0][6][kContent];
    
    HealthArchiveViewController2 *vc = [[HealthArchiveViewController2 alloc] init];
    vc.archiveData = self.archiveData;
    vc.isCreator = self.isCreator;
    //新增时候才保存临时的数据在本地
    if (self.isAddArchive) {
        [self.archiveData saveArchiveDataToFile];
        vc.addArchive = YES;
    }else{
        vc.addArchive = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchValueChange:(UISwitch *)sender
{
    self.datas[0][sender.tag][kContent] = sender.on?@"1":@"0";
    NSLog(@"%@",self.datas[0][sender.tag][kContent]);
}

@end
