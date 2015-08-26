//
//  PlaceOrderController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PlaceOrderController.h"

@interface PlaceOrderController ()
{
    NSArray* day;
    NSArray* time;
    NSArray* min;
    
    NSString* daystr;
    NSString* timestr;
    NSString* minstr;
}

@end

@implementation PlaceOrderController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    [self setupGroups];
    
    [self initDatePickView];
    
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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 12;
    btn.backgroundColor = HMColor(29, 164, 232);
    btn.frame = CGRectMake(20, MTScreenH - 180, MTScreenW - 40, 40);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:btn];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 60)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"上门体检 200元";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    lab.textColor = HMColor(33, 165, 233);
    lab.width = MTScreenW;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.height = headView.height;
    [headView addSubview:lab];
}

-(void)sendMsg
{
    
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"我要下单";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"default_common_navibar_prev_normal.png"
//                                                                 highImageName:@"default_common_navibar_prev_highlighted.png"
//                                                                        target:self action:@selector(back)];
}

/**
 *   创建、并初始化2个NSArray对象，分别作为2列的数据
 */
-(void)initDatePickView
{ 
    NSDate* date=[NSDate date];
    
    //明天
    NSString * tomorrow = [MTDateHelper getDaySinceday:date days:1];
    
    //后天
    NSString * aftertomorrow = [MTDateHelper getDaySinceday:date days:2];
    
    //大后天
    NSString * aftertomorrow1 = [MTDateHelper getDaySinceday:date days:3];
    
    //大大后天
    NSString * aftertomorrow2 = [MTDateHelper getDaySinceday:date days:4];
    
    self.datePickView = [[UIPickerView alloc] init];
    
    day = [NSArray arrayWithObjects:@"今天",
           @"明天", @"后天",tomorrow,aftertomorrow,aftertomorrow1,aftertomorrow2, nil];
    time = [NSArray arrayWithObjects:@"9点" , @"10点"
            , @"11点",@"12点", @"13点", @"14点",
            @"15点", @"16点" , @"17点",@"18点", nil];
    
    min = [NSArray arrayWithObjects:@"0分" , @"30分", nil];
    
    self.datePickView.dataSource = self;
    self.datePickView.delegate = self;
    
    daystr = [day objectAtIndex:0];
    timestr = [time objectAtIndex:0];
    minstr = [min objectAtIndex:0];
}


// UIPickerViewDataSource中定义的方法，该方法返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}

// UIPickerViewDataSource中定义的方法，该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return day.count;
    else  if (component == 1)
        return time.count;
    else
        return min.count;
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列、指定列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return [day objectAtIndex:row];
    else  if (component == 1)
        return [time objectAtIndex:row];
    else
        return [min objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            daystr = [day objectAtIndex:row];
            break;
        case 1:
            timestr = [time objectAtIndex:row];
            break;
        case 2:
            minstr = [min objectAtIndex:row];
            break;
        default:
            break;
    }
    
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:[NSString stringWithFormat:@"你选中的%@%@%@"
                                   , daystr , timestr,minstr]
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
//    [alert show];
    self.item2.subtitle = [NSString stringWithFormat:@"%@%@%@"
    , daystr , timestr,minstr];
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    if (component == 0)
        return 120;
    else  if (component == 1)
        return 90;
    else
        return 90;
}


# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
    
    [self setupGroup1];
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonArrowItem *item1 = [HMCommonArrowItem itemWithTitle:@"服务对象" icon:@"user"];
    item1.subtitle = @"张全蛋";
    
    self.item2 = [HMCommonArrowItem itemWithTitle:@"服务时间" icon:@"time"];
    self.item2.subtitle = @"请选择服务时间";
    
    __weak typeof(self) weakSelf = self;
    
    self.item2.operation = ^{
        [weakSelf showDatePicker];
    };
    
    HMCommonTextfieldItem *item3 = [HMCommonTextfieldItem itemWithTitle:@"服务地点" icon:@"addre"];
    item3.placeholder = @"小区名字、门牌号";
    
    group.items = @[item1,self.item2,item3];
    
}
- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    
    HMCommonTextfieldItem *item4 = [HMCommonTextfieldItem itemWithTitle:@"备注" icon:@"other"];
    item4.placeholder = @"请填写您的其他要求";
    
    group.items = @[item4];
}

-(void)showDatePicker
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self setDatePickerIos8];
    else
        [self setDatePickerIos7];
}

-(void)setDatePickerIos8
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    self.datePicker = [[UIDatePicker alloc]init];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSDate* date=[self.datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * curentDatest=[formatter stringFromDate:date];
//        self.item2.subtitle = curentDatest;
        [self.tableView reloadData];
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:self.datePickView];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)setDatePickerIos7
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle: @"\n\n\n\n\n\n\n\n\n\n\n"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确认"
                                  otherButtonTitles:nil];
    
    self.datePicker = [[UIDatePicker alloc] init];
    
    [actionSheet addSubview:self.datePicker];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSDate* date=[self.datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * curentDatest=[formatter stringFromDate:date];
        self.item2.subtitle = curentDatest;
        [self.tableView reloadData];
        
    }
}

# pragma  mark 返回上一界面

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
