//
//  CheckSelfViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CheckSelfViewController.h"

@interface CheckSelfViewController ()

@end

@implementation CheckSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigation];
    [self initTableView];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.navigationItem.title = @"状态自查";
}

/**
 *  初始化表视图
 */
-(void)initTableView
{
    self.positionTableView.delegate = self;
    self.positionTableView.dataSource = self;
    self.symptomTableView.delegate = self;
    self.symptomTableView.dataSource = self;
    self.symptomTableView.tableFooterView = [[UIView alloc] init];
    
    //解决tableView分割线右移问题
    if ([ self.positionTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.positionTableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.positionTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.positionTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([ self.symptomTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.symptomTableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.symptomTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.symptomTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //设置默认选中cell
    [self.positionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //初始化症状位置数组
    self.symptomPositions = @[@"全身症状",@"皮肤症状",@"头部",@"咽颈部",@"胸部",@"腹部",@"生殖部位",@"骨盆",@"四肢",@"腰背部",@"臀部及肛门"];
    
    //初始化具体症状数组
    self.symptoms = [[NSMutableArray alloc]init];
    for (int i=0; i<15; i++) {
        NSString *symString = [[NSString alloc] initWithFormat:@"全身症状%d",i];
        [self.symptoms addObject:symString];
    }
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

#pragma mark tableView dataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.positionTableView == tableView) {
        return self.symptomPositions.count;
    }
    return self.symptoms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellPosition = @"positionCell";
    static NSString *cellSymptom = @"symptomCell";
    
    if (self.positionTableView == tableView) {
        //返回症状位置Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPosition];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PositionCell" owner:nil options:nil] lastObject];
        }
        ((UILabel *)[cell viewWithTag:2]).text = self.symptomPositions[indexPath.row];
        return cell;
    }else{
        //返回具体症状Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSymptom];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellSymptom];
        }
        cell.detailTextLabel.text = self.symptoms[indexPath.row];
        return cell;
    }
}

#pragma mark tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.positionTableView == tableView) {
        return 100.0f;
    }
    return 55.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.positionTableView == tableView) {
        [self.symptomTableView reloadData];
    }else{
        NSLog(@"跳转");
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell选中时的背景View
    UIView* sbkView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = sbkView;
    if (self.positionTableView == tableView) {
        sbkView .backgroundColor = [UIColor whiteColor];
    }else sbkView .backgroundColor = HMGlobalBg;
    
    //解决tableView分割线右移问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}

@end
