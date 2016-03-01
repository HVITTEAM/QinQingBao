//
//  EditInfoTableViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EditInfoTableViewController.h"
#import "HMCommonTextfieldItem.h"

@interface EditInfoTableViewController ()

@property(strong,nonatomic)HMCommonTextfieldItem *textItem;       //数据源

@end

@implementation EditInfoTableViewController

# pragma  mark -- 生命周期方法 --
-(instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStylePlain target:self action:@selector(finishOperation:)];
    self.navigationItem.title = self.titleStr;
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.tableView.tableHeaderView = head;
    
}

-(HMCommonTextfieldItem *)textItem
{
    if (!_textItem) {
        _textItem = [[HMCommonTextfieldItem alloc] init];
        _textItem.title = self.titleStr;
        _textItem.placeholder = self.placeholderStr;
    }
    return _textItem;
}

# pragma  mark -- 协议方法 --
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMCommonCell *cell = [HMCommonCell cellWithTableView:tableView];
    cell.item = self.textItem;
    // 设置cell所处的行号 和 所处组的总行数
    [cell setIndexPath:indexPath rowsInSection:(int)1];
    
    self.textItem.rightText.text = self.contentStr;
    
    return cell;
}

# pragma  mark -- 事件方法 --
/**
 *  完成按钮点击调用
 */
-(void)finishOperation:(UIBarButtonItem *)barItem
{
    if (self.finishUpdateOperation) {
        self.finishUpdateOperation(self.titleStr,self.textItem.rightText.text,self.placeholderStr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

