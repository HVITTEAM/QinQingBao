//
//  QuestionResultController3.m
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionResultController3.h"
#import "ArchivesCell.h"
#import "QuestionResultCell.h"

@interface QuestionResultController3 ()

@end

@implementation QuestionResultController3

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评估结果";
    
    self.tableView.separatorColor = [UIColor colorWithRGB:@"dcdcdc"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [self getFooterView];
}

#pragma mark - 协议方法
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        QuestionResultCell *resultCell = [QuestionResultCell createCellWithTableView:tableView];
        [resultCell setItem];
        return resultCell;
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        static NSString *titleCellId = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.textLabel.font = [UIFont systemFontOfSize:14];
            titleCell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            titleCell.layoutMargins = UIEdgeInsetsZero;
        }
        titleCell.textLabel.text = @"我的亲友";
        return titleCell;
        
    }else{
        ArchivesCell *archivesCell = [ArchivesCell createCellWithTableView:tableView];
//        archivesCell.relativesArr = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1", nil];
        
        return archivesCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        return 40;
        
    }else{
        return [ArchivesCell cellHeight];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - 私有方法
/**
 *  创建底部确定按钮
 */
- (UIView *)getFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 150)];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, MTScreenW - 20, 40)];
    [btn1 setTitle:@"确定归档" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor colorWithRGB:@"94bf36"];
    btn1.layer.cornerRadius = 8.0f;
    [footerView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn1.frame) + 10, MTScreenW - 20, 40)];
    [btn2 setTitle:@"默默忽略" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRGB:@"94bf36"] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.cornerRadius = 8.0f;
    [footerView addSubview:btn2];
    
    return footerView;
}

@end
