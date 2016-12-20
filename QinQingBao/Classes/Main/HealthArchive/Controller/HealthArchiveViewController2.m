//
//  HealthArchiveViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//


#import "HealthArchiveViewController2.h"
#import "HealthArchiveViewController3.h"

#import "AddressController.h"
#import "TextCell.h"
#import "TextTwoCell.h"
#import "CommonRulerViewController.h"
#import "HeadProcessView.h"

#define kContent @"cellContent"
#define kTitle @"cellTitle"
#define kPlaceHolder @"cellPlaceHolder"

#import "DietaryHabit.h"
#import "BadHabit.h"


@interface HealthArchiveViewController2 ()

@property (strong,nonatomic)NSArray *datas;     //UITableView数据源

@property (strong,nonatomic)UIControl* dateSelectView;

@property (strong,nonatomic)UIDatePicker *datePicker;

@property (strong,nonatomic)NSIndexPath *currentIdx;

@property (strong,nonatomic)NSDateFormatter *dtFormatter;

@end

@implementation HealthArchiveViewController2

-(instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
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
        [section0 addObject:createItem([ArchiveData numberToSmoke:[self.archiveData.smoke integerValue]],@"抽烟习惯",@"请选择")];
        [section0 addObject:createItem([ArchiveData numberToDrink:[self.archiveData.drink integerValue]],@"喝酒习惯",@"请选择")];
        
        __block NSString *diet = [[NSString alloc] init];
        [self.archiveData.diet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSString *dietStr =  [ArchiveData numberToDiet:[obj integerValue]];
           diet = [diet stringByAppendingFormat:@"%@,",dietStr];
        }];
        if (diet.length > 0) {
            diet = [diet substringToIndex:diet.length-1];
        }
        [section0 addObject:createItem(diet,@"饮食习惯",@"请选择")];
        
        NSMutableArray *section1 = [[NSMutableArray alloc] init];
        [section1 addObject:createItem(@"",@"睡觉习惯",@"")];
        
        NSDate *dt = [self dateFromDateString:self.archiveData.sleeptime];
        NSString *timeStr = [self shortStringFromDate:dt];
        [section1 addObject:createItem(timeStr,@"休息时间",@"请选择")];
        
        dt = [self dateFromDateString:self.archiveData.getuptime];
        timeStr = [self shortStringFromDate:dt];
        [section1 addObject:createItem(timeStr,@"起床时间",@"请选择")];
        
        NSMutableArray *section2 = [[NSMutableArray alloc] init];
        [section2 addObject:createItem([ArchiveData numberToSports:[self.archiveData.sports integerValue]],@"运动习惯",@"请选择")];
        [section2 addObject:createItem([ArchiveData numberToBadhabits:[self.archiveData.badhabits integerValue]],@"不良习惯",@"请选择")];
        
        self.datas = @[section0,section1,section2];
    }
    return _datas;
}

- (NSDateFormatter *)dtFormatter
{
    if (!_dtFormatter) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        _dtFormatter = [[NSDateFormatter alloc] init];
        _dtFormatter.timeZone = timeZone;
        _dtFormatter.locale = locale;
        _dtFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return _dtFormatter;
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
    
    if (indexPath.row == 8)
    {
        TextTwoCell *textTwoCel = [TextTwoCell createCellWithTableView:tableView];
        textTwoCel.titleLb.text = rowItem[kTitle];
        textTwoCel.titleLb.font = [UIFont systemFontOfSize:16];
        textTwoCel.titleLb.textColor = [UIColor colorWithRGB:@"333333"];
        textTwoCel.contentTextView.textColor = [UIColor colorWithRGB:@"999999"];

        textTwoCel.contentTextView.text = rowItem[kContent];
        textTwoCel.placeHolderLb.text = rowItem[kPlaceHolder];
        
        textTwoCel.idx = indexPath;
        textTwoCel.contentChangeCallBack = ^(NSIndexPath *idx,NSString *contentStr){
            weakSelf.datas[idx.section][idx.row][kContent] = contentStr;
        };
        return textTwoCel;
    }
    else
    {
        TextCell *textCell = [TextCell createCellWithTableView:tableView];
        textCell.textLabel.text = rowItem[kTitle];
        if (indexPath.row == 4 || indexPath.row == 5)
            textCell.textLabel.font = [UIFont systemFontOfSize:13];
        else
            textCell.textLabel.font = [UIFont systemFontOfSize:16];
        
        textCell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
        textCell.field.text = rowItem[kContent];
        textCell.field.enabled = NO;
        textCell.field.textColor = [UIColor colorWithRGB:@"999999"];

        textCell.field.placeholder = rowItem[kPlaceHolder];
        textCell.idx = indexPath;
        textCell.contentChangeCallBack = ^(NSIndexPath *idx,NSString *contentStr){
            weakSelf.datas[idx.section][idx.row][kContent] = contentStr;
        };
        return textCell;
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
    if (indexPath.row == 8) {
        return 114;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    
    self.currentIdx = indexPath;
    
    //不是档案创建者不允许修改
    if (!self.isAddArchive && !self.isCreator) {
        return;
    }
    
    if ( 0 == indexPath.section && 0 == indexPath.row) {
        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"无",@"偶尔",@"半包",@"一包",@"一包以上", nil] show];
    }else if (0 == indexPath.section && 1 == indexPath.row){
        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"无",@"偶尔",@"经常", nil] show];
    }else if (0 == indexPath.section && 2 == indexPath.row){
        
        DietaryHabit *dietaryHabitView = [DietaryHabit showTargetViewToView:[UIApplication sharedApplication].keyWindow];
        
        NSString *diet = self.datas[0][2][kContent];
        NSArray *diets = [diet componentsSeparatedByString:@","];
        dietaryHabitView.valueArray = diets;
        
        dietaryHabitView.selectItemBlock = ^(NSArray *selectedItems){
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [selectedItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger code = [ArchiveData dietToNumber:(NSString *)obj];
                [tempArray addObject:@(code)];
            }];
            weakSelf.archiveData.diet = tempArray;
            weakSelf.datas[0][2][kContent] = [selectedItems componentsJoinedByString:@","];
            [weakSelf.tableView reloadData];
        };
    }else if (1 == indexPath.section && 1 == indexPath.row){
        if (self.archiveData.sleeptime)
            [self showDatePickerView:[self dateFromDateString:self.archiveData.sleeptime]];
        else
            [self showDatePickerView:[self dateFromDateString:@"2016-11-28 22:30:00"]];
    }else if (1 == indexPath.section && 2 == indexPath.row){
        if (self.archiveData.getuptime)
            [self showDatePickerView:[self dateFromDateString:self.archiveData.getuptime]];
        else
            [self showDatePickerView:[self dateFromDateString:@"2016-11-28 07:30:00"]];
    }else if (2 == indexPath.section && 0 == indexPath.row){
        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"无",@"偶尔",@"经常", nil] show];
    }else if (2 == indexPath.section && 1 == indexPath.row){
        BadHabit *badHabitView = [BadHabit showTargetViewToView:[UIApplication sharedApplication].keyWindow];
        
//        NSString *diet = self.datas[0][2][kContent];
//        NSArray *diets = [diet componentsSeparatedByString:@","];
//        dietaryHabitView.valueArray = diets;
//        
//        dietaryHabitView.selectItemBlock = ^(NSArray *selectedItems){
//            
//            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//            [selectedItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSInteger code = [ArchiveData dietToNumber:(NSString *)obj];
//                [tempArray addObject:@(code)];
//            }];
//            weakSelf.archiveData.diet = tempArray;
//            weakSelf.datas[0][2][kContent] = [selectedItems componentsJoinedByString:@","];
//            [weakSelf.tableView reloadData];
//        };

//        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"无",@"久坐",@"经常熬夜",@"常看手机", nil] show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        return;
    }
    NSMutableArray *sections = self.datas[self.currentIdx.section];
    NSMutableDictionary *item = sections[self.currentIdx.row];
    
    if (0 == self.currentIdx.section && 0 == self.currentIdx.row) {
        if (1 == buttonIndex) {
            item[kContent] = @"无";
        }else if (2 == buttonIndex){
            item[kContent] = @"偶尔";
        }else if (3 == buttonIndex){
            item[kContent] = @"半包";
        }else if (4 == buttonIndex){
            item[kContent] = @"一包";
        }else if (5 == buttonIndex){
            item[kContent] = @"一包以上";
        }
    }else if(0 == self.currentIdx.section && 1 == self.currentIdx.row){
        if (1 == buttonIndex) {
            item[kContent] = @"无";
        }else if (2 == buttonIndex){
            item[kContent] = @"偶尔";
        }else if (3 == buttonIndex){
            item[kContent] = @"经常";
        }
    }else if(2 == self.currentIdx.section && 0 == self.currentIdx.row){
        if (1 == buttonIndex) {
            item[kContent] = @"无";
        }else if (2 == buttonIndex){
            item[kContent] = @"偶尔";
        }else if (3 == buttonIndex){
            item[kContent] = @"经常";
        }
    }else if(2 == self.currentIdx.section && 1 == self.currentIdx.row){
        if (1 == buttonIndex) {
            item[kContent] = @"无";
        }else if (2 == buttonIndex){
            item[kContent] = @"久坐";
        }else if (3 == buttonIndex){
            item[kContent] = @"经常熬夜";
        }else if (4 == buttonIndex){
            item[kContent] = @"常看手机";
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 设置footer View

- (void)setupFooter
{
    HeadProcessView *headView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    headView.backgroundColor = [UIColor clearColor];
    [headView initWithShowIndex:2];
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

#pragma mark - 日期选择视图相关
/**
 *  日期选择视图
 */
-(void)showDatePickerView:(NSDate*)selectedDate
{
    self.dateSelectView = [[UIControl alloc] initWithFrame:self.view.frame];
    self.dateSelectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    [self.dateSelectView addTarget:self action:@selector(datePickerViewHide:) forControlEvents:UIControlEventTouchUpInside];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, MTScreenH - 180, MTScreenW, 180)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    
    self.datePicker.timeZone = timeZone;
    self.datePicker.locale = locale;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    
    [self.dateSelectView addSubview:self.datePicker];
    
    if (selectedDate)
        self.datePicker.date = selectedDate;
    
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, MTScreenH - 224, MTScreenW, 44)];
    tb.backgroundColor = [UIColor whiteColor];
    tb.translucent = NO;
    
    UIBarButtonItem *fixSpaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixSpaceItem1.width = 15;
    UIBarButtonItem *fixSpaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixSpaceItem2.width = 15;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(datePickerViewHide:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectBirthday:)];
    tb.items = @[fixSpaceItem1,cancelItem,spaceItem,confirmItem,fixSpaceItem2];
    
    [self.dateSelectView addSubview:tb];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tb.frame), MTScreenW, 1)];
    line.backgroundColor = HMColor(230, 230, 230);
    [self.dateSelectView addSubview:line];
    
    UIWindow *kwindow = [[UIApplication sharedApplication] keyWindow];
    
    [kwindow addSubview:self.dateSelectView];
}

/**
 *  隐藏时间选择视图
 */
-(void)datePickerViewHide:(id )sender
{
    [self.dateSelectView removeFromSuperview];
}

/**
 *  选择时间
 */
-(void)selectBirthday:(UIBarButtonItem *)sender
{
    NSString *ftstr = [self shortStringFromDate:self.datePicker.date];
    NSMutableArray *sections = self.datas[self.currentIdx.section];
    NSMutableDictionary *item = sections[self.currentIdx.row];
    item[kContent] = ftstr;
    
    NSString *timeStr = [self longStringFromDate:self.datePicker.date];
    if (self.currentIdx.section == 1 && self.currentIdx.row == 1) {
        self.archiveData.sleeptime = timeStr;
    }else{
        self.archiveData.getuptime = timeStr;
    }
    
    [self.tableView reloadData];
    
    [self datePickerViewHide:nil];
}

- (NSDate *)dateFromDateString:(NSString *)dateStr
{
    self.dtFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [self.dtFormatter dateFromString:dateStr];
    return date;
}

- (NSString *)longStringFromDate:(NSDate *)date
{
    self.dtFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [self.dtFormatter stringFromDate:date];
    return dateStr;
}

- (NSString *)shortStringFromDate:(NSDate *)date
{
    self.dtFormatter.dateFormat = @"a hh:mm";
    NSString *dateStr = [self.dtFormatter stringFromDate:date];
    return dateStr;
}

#pragma mark - 事件方法
/**
 *  点击确定按钮后调用
 */
-(void)next:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    NSString *smoke = self.datas[0][0][kContent];
    int smokeCode = (int)[ArchiveData smokeToNumber:smoke];
    if (smokeCode < 0) {
        return [NoticeHelper AlertShow:@"请选择抽烟习惯" view:nil];
    }
    self.archiveData.smoke = smokeCode==-1?nil:[NSString stringWithFormat:@"%d",smokeCode];
    
    int drinkCode = (int)[ArchiveData drinkToNumber:self.datas[0][1][kContent]];
    self.archiveData.drink = drinkCode==-1?nil:[NSString stringWithFormat:@"%d",drinkCode];
    
    int sportsCode = (int)[ArchiveData sportsToNumber:self.datas[2][0][kContent]];
    self.archiveData.sports = sportsCode==-1?nil:[NSString stringWithFormat:@"%d",sportsCode];
    
    int badhabitsCode = (int)[ArchiveData badhabitsToNumber:self.datas[2][1][kContent]];
    self.archiveData.badhabits = badhabitsCode==-1?nil:[NSString stringWithFormat:@"%d",badhabitsCode];
    
    HealthArchiveViewController3 *vc = [[HealthArchiveViewController3 alloc] init];
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

@end
