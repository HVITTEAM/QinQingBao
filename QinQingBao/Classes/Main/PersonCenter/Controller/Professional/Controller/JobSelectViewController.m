//
//  JobSelectViewController.m
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "JobSelectViewController.h"

@interface JobSelectViewController ()

@end

@implementation JobSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    static NSString *selectCellId = @"selectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:selectCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }

    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertModel *model = self.dataProvider[indexPath.row];
    if (self.selectCompleteCallBack) {
        self.selectCompleteCallBack(model);
    }
}


- (void)showJobSelectViewInView:(UIView *)v
{
    CGFloat h = self.dataProvider.count * 40;
    
    if (h > 200) {
        h = 200;
    }
    
    self.view.frame = CGRectMake((MTScreenW - 100) / 2, (MTScreenH - h) / 2, 100, h);
    [v addSubview:self.view];
    [self.tableView reloadData];
}

@end
