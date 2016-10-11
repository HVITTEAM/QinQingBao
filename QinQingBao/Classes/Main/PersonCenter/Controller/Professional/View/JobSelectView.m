//
//  JobSelectView.m
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "JobSelectView.h"

#define kCellHeight 45

@interface JobSelectView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataProvider;       //数据源

@property (strong, nonatomic) UITableView *tableview;

@end

@implementation JobSelectView

+ (instancetype)showJobSelectViewWithdatas:(NSArray *)datas
{
    JobSelectView *selecteView = [[JobSelectView alloc] init];
    selecteView.dataProvider = datas;
    
    UIWindow *keyWd = [UIApplication sharedApplication].keyWindow;
    selecteView.frame = keyWd.bounds;
    
    [keyWd addSubview:selecteView];
    
    return selecteView;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.tableview = [[UITableView alloc] init];
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.layoutMargins = UIEdgeInsetsZero;
        self.tableview.separatorInset = UIEdgeInsetsZero;
        self.tableview.layer.cornerRadius = 8.0f;
        self.tableview.layer.masksToBounds = YES;
        self.tableview.bounces = NO;
        [self addSubview:self.tableview];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = self.dataProvider.count * kCellHeight;
    
    if (h > kCellHeight * 6) {
        h = kCellHeight * 6;
    }
    
    self.tableview.frame = CGRectMake((MTScreenW - 240) / 2, (MTScreenH - h) / 2, 240, h);
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectCellId = @"selectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:selectCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.layoutMargins = UIEdgeInsetsZero;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kCellHeight)];
        lb.tag = 900;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = HMColor(51, 51, 51);
        lb.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lb];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:900];
    ExpertModel *model = self.dataProvider[indexPath.row];
    label.text = model.grouptitle;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertModel *model = self.dataProvider[indexPath.row];
    if (self.selectCompleteCallBack) {
        self.selectCompleteCallBack(model);
    }
    
    [self hideView];
}

- (void)hideView
{
    [self removeFromSuperview];
}

@end
