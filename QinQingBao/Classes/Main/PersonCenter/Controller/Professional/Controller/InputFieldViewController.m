//
//  InputFieldViewController.m
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InputFieldViewController.h"
#import "HMCommonTextfieldItem.h"

@interface InputFieldViewController ()

@property (strong, nonatomic) HMCommonTextfieldItem *textItem;

@end

@implementation InputFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableviewSkin];

    [self initNavigation];
    
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
    self.title = [self.dict valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
}

# pragma  mark - 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
}

- (void)setupGroup
{
    [self.groups removeAllObjects];
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.textItem = [HMCommonTextfieldItem itemWithTitle:[self.dict valueForKey:@"text"] icon:nil];
    self.textItem.placeholder = [self.dict valueForKey:@"placeholder"];
    self.textItem.textValue = [self.dict valueForKey:@"value"];
    
    group.items = @[self.textItem];
    [self.tableView reloadData];
}

-(void)doneClickHandler
{
    self.dict[@"value"] = self.textItem.rightText.text;
    
    if (self.completeCallBack) {
        self.completeCallBack(self.dict,self.idx);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
