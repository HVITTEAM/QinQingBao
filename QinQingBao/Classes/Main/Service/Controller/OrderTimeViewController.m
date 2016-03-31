//
//  OrderTimeViewController.m
//  QinQingBao
//
//  Created by shi on 16/3/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//



#import "OrderTimeViewController.h"
#import "OrderTimeCell.h"

static const NSInteger navBarHeight = 64;
static const NSInteger bottomViewHeight = 50;
static NSString *orderTimeCellId = @"orderTimeCell";

extern NSString * const kTimekey;
extern NSString * const kAmStateKey;
extern NSString * const kPmStateKey;

@interface OrderTimeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView *tableView;

@property (strong,nonatomic)NSMutableArray *timeArray;

@property (copy,nonatomic)NSDictionary *selectedTimeDict;

@property (strong,nonatomic)NSDateFormatter *formatterShort;

@property (strong,nonatomic)NSDateFormatter *formatterLong;

@end

@implementation OrderTimeViewController

@synthesize timeArray = _timeArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initNavBar];
    
    [self initBottomBar];
}

#pragma mark --- setUI 方法 ---
/**
 *  初始化导航条
 */
-(void)initNavBar
{
   self.navigationItem.title = @"选择时间";
}

/**
 *  初始TableView
 */
-(void)initTableView
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - bottomViewHeight - navBarHeight ) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UINib *cellNib = [UINib nibWithNibName:@"OrderTimeCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:orderTimeCellId];
}

/**
 *  初始底部工具条
 */
-(void)initBottomBar
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - bottomViewHeight - navBarHeight, MTScreenW, bottomViewHeight)];
    [self.view addSubview:bottomView];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, MTScreenW / 2, bottomViewHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(bottomBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 100;
    [bottomView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(MTScreenW / 2, 0, MTScreenW / 2, bottomViewHeight);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(bottomBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.tag = 101;
    [bottomView addSubview:confirmBtn];
    
    UIView *lineMiddle = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), 10, 0.5, bottomViewHeight - 20)];
    lineMiddle.backgroundColor = HMColor(205, 205, 205);
    [bottomView addSubview:lineMiddle];
    
    UIView *lineTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, .5f)];
    lineTop.backgroundColor = HMColor(205, 205, 205);
    [bottomView addSubview:lineTop];
}

#pragma mark -- setter和getter方法 --
-(NSDateFormatter *)formatterShort
{
    if (!_formatterShort) {
        _formatterShort = [[NSDateFormatter alloc] init];
        [_formatterShort setDateFormat:@"yyyy年MM月dd日 EEEE"];
    }
    return _formatterShort;
}

-(NSDateFormatter *)formatterLong
{
    if (!_formatterLong) {
        _formatterLong = [[NSDateFormatter alloc] init];
        [_formatterLong setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatterLong;
}

-(NSMutableArray *)timeArray
{
    if (!_timeArray) {
        _timeArray = [[NSMutableArray alloc] init];
        NSDate *currentDate = [NSDate date];
        for (int i = 0; i < 7; i++) {
            NSString *dateStr = [MTDateHelper getDaySinceday:currentDate days:i formatter:self.formatterShort];
            NSMutableDictionary *dict = [@{
                                   kTimekey:dateStr,
                                   kAmStateKey:@(NO),
                                   kPmStateKey:@(NO)
                                   }mutableCopy];
            [_timeArray addObject:dict];
        }
    }
    return _timeArray;
}

#pragma mark --- 协议方法 ---
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:orderTimeCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.cellData = self.timeArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.selectTimeCallBack = ^(NSMutableDictionary *dict,NSIndexPath *idx){
        
        [weakSelf.timeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((NSMutableDictionary *)obj)[kAmStateKey] = @(NO);
            ((NSMutableDictionary *)obj)[kPmStateKey] = @(NO);
        }];
         weakSelf.selectedTimeDict = dict;
        [weakSelf.timeArray replaceObjectAtIndex:idx.row withObject:dict];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark --- 事件方法 ---
/**
 *  上午，下午按钮被点击时调用
 */
-(void)bottomBtnTapped:(UIButton *)sender
{
    if (sender.tag == 101) {
        //用于界面显示
        NSString *shortTimeBefor = [self.selectedTimeDict[kAmStateKey] boolValue] ? @"上午" : @"下午";
        NSString *shortTime = [NSString stringWithFormat:@"%@ %@",self.selectedTimeDict[kTimekey],shortTimeBefor];
        
        //用于上传到后台
        NSDate *longDate = [self.formatterShort dateFromString:self.selectedTimeDict[kTimekey]];
        NSString *longTimeBefor = [self.formatterLong stringFromDate:longDate];
        NSString *longTimeAfter = [self.selectedTimeDict[kAmStateKey] boolValue] ? @"08:00:00" : @"14:00:00";
        NSString *longTime = [NSString stringWithFormat:@"%@ %@",longTimeBefor,longTimeAfter];
        
        self.finishTimeCallBack(shortTime,longTime);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
