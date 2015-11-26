//
//  OrderSubmitController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderSubmitController.h"
#import "FamilyModel.h"
#import "OrderServiceDetailCell.h"
#import "UseCouponsViewController.h"
#import "CouponsModel.h"
#import "OrderItem.h"


@interface OrderSubmitController ()
{
    NSArray* day;
    NSArray* time;
    NSArray* min;
    
    NSString* daystr;
    NSString* timestr;
    NSString* minstr;
    
    //是否选择了服务对象
    BOOL haveObj;
    
    NSInteger selectedIndex;
    
    //服务时间
    NSString *selectedTimestr;
    FamilyModel *famVO;
    
    OrderSubmitCell *orderSubmitCell;
    
    //优惠券
    CouponsModel *couponsItem;
    
}

@end

@implementation OrderSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    [self initDatePickView];
    
    selectedIndex = 0;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MTNotificationCenter addObserver:self selector:@selector(selectedObjectHanlder:) name:@"selected" object:nil];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    orderSubmitCell = [OrderSubmitCell orderSubmitCell];
    __weak typeof(self) weakSelf = self;
    orderSubmitCell.payClick = ^(UIButton *button){
        [weakSelf submitClickHandler];
    };
    orderSubmitCell.serviceDetailItem = self.serviceDetailItem;
    orderSubmitCell.width = MTScreenW;
    [self.tableView addSubview:orderSubmitCell];
}

-(void)sendMsg
{
    
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    orderSubmitCell.y = MTScreenH - self.navigationController.navigationBar.height - 10 + sender.contentOffset.y;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"提交订单";
    haveObj = NO;
}

/**
 *
 */
-(void)selectedObjectHanlder:(NSNotification *)notification
{
    haveObj = YES;
    famVO  = notification.object;
    [self.tableView reloadData];
}

#pragma mark - datePicker data source

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
    //    self.item2.subtitle = [NSString stringWithFormat:@"%@%@%@"
    //                           , daystr , timestr,minstr];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return haveObj ? 2 : 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
        return 90;
    else if (indexPath.section == 1 && indexPath.row == 1)
        return 70;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *conmoncell = @"MTCommoncell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conmoncell];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:conmoncell];
                cell.textLabel.text = @"服务对象";
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return  cell;
        }
        else
        {
            ServiceCustomCell *serviceCuscell = [tableView dequeueReusableCellWithIdentifier:@"MTServiceCustomcell"];
            
            if(serviceCuscell == nil)
                serviceCuscell = [ServiceCustomCell serviceCustomCell];
            
            [serviceCuscell setdataWithItem:famVO];
            
            return serviceCuscell;
        }
        
    }
    else  if (indexPath.section == 2 && indexPath.row == 0)
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:conmoncell];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        cell.textLabel.text = @"预约时间";
        cell.detailTextLabel.text =  selectedTimestr;
        return  cell;
    }
    else  if (indexPath.section == 3)
    {
        UITableViewCell *payTypecell = [tableView dequeueReusableCellWithIdentifier:@"MTPaytypeCell"];
        if (payTypecell == nil)
            payTypecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTPaytypeCell"];
        payTypecell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        payTypecell.textLabel.text = indexPath.row == 0 ? @"在线支付": @"货到付款";
        
        if (selectedIndex == indexPath.row)
            payTypecell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            payTypecell.accessoryType = UITableViewCellAccessoryNone;
        
        return  payTypecell;
    }
    else  if (indexPath.section == 4)
    {
        UITableViewCell *vouchercell = [tableView dequeueReusableCellWithIdentifier:@"MTVoucherCell"];
        if (vouchercell == nil)
            vouchercell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTVoucherCell"];
        vouchercell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        vouchercell.textLabel.text = @"优惠券";
        if (couponsItem)
            vouchercell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",couponsItem.voucher_price];
        vouchercell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        vouchercell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
        vouchercell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background_highlighted"]];
        return  vouchercell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:conmoncell];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            }
            cell.accessoryType = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"服务详情";
            cell.detailTextLabel.text = @"";
            return  cell;
        }
        else
        {
            OrderServiceDetailCell *orderServiceDetailCell = [tableView dequeueReusableCellWithIdentifier:@"MTOrderServiceDetailCell"];
            
            if(orderServiceDetailCell == nil)
                orderServiceDetailCell = [OrderServiceDetailCell orderServiceDetailCell];
            
            [orderServiceDetailCell setdataWithItem:self.serviceDetailItem];
            
            return orderServiceDetailCell;
        }
    }
    //    else
    //    {
    //        OrderSubmitCell *orderSubmitCell = [tableView dequeueReusableCellWithIdentifier:@"MTOrderSubmitCell"];
    //
    //        if(orderSubmitCell == nil)
    //            orderSubmitCell = [OrderSubmitCell orderSubmitCell];
    //
    //        __weak typeof(self) weakSelf = self;
    //        orderSubmitCell.payClick = ^(UIButton *button){
    //            [weakSelf submitClickHandler];
    //        };
    //        return orderSubmitCell;
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        FamilyViewController *familyView = [[FamilyViewController alloc] init];
        familyView.isfromOrder = YES;
        [self.navigationController pushViewController:familyView animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        [self showDatePicker];
    }
    else if (indexPath.section == 3)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        
        selectedIndex = indexPath.row;
        
        [self.tableView reloadData];
    }
    else if (indexPath.section == 4)
    {
        //优惠券
        UseCouponsViewController *coupons = [[UseCouponsViewController alloc] init];
        coupons.selectedClick = ^(CouponsModel *item)
        {
            NSLog(@"选择优惠券");
            couponsItem = item;
            [orderSubmitCell setCouponsModel:item];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:coupons animated:YES];
    }
}

/**
 *  提交订单、前往支付
 */
-(void)submitClickHandler
{
    if (selectedTimestr.length == 0)
        return [NoticeHelper AlertShow:@"请选择预约时间" view:self.view];
    else if (famVO == nil)
        return [NoticeHelper AlertShow:@"请选择服务对象" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Create_order parameters: @{@"tid" : self.serviceTypeItem.tid,
                                                                     @"iid" : self.serviceDetailItem.iid,
                                                                     @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                                                                     @"wtime" : selectedTimestr,
                                                                     @"wname" : famVO.oldname,
                                                                     @"wprice" : self.serviceDetailItem.price,
                                                                     @"dvcode" : famVO.totalname,
                                                                     @"wtelnum" : famVO.oldphone,
                                                                     @"waddress" : famVO.totalname,
                                                                     @"client" : @"ios",
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"wlevel" : @"1",
                                                                     @"wremark" : @"用户留言",
                                                                     @"voucher_id" : couponsItem ? couponsItem.voucher_id : @"",
                                                                     @"pay_type" : @"1",
                                                                     @"wlat" :  [SharedAppUtil defaultCommonUtil].lat,
                                                                     @"wlng" :  [SharedAppUtil defaultCommonUtil].lon}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     OrderItem *item = [OrderItem objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     if (item.wcode.length != 0)
                                     {
                                         PayViewController *payView = [[PayViewController alloc] init];
                                         [self.navigationController pushViewController:payView animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"下单失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
    
}

-(void)showDatePicker
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self setDatePickerIos8];
    else
        [self setDatePickerIos7];
}


#pragma mark --- DatePicker

-(void)setDatePickerIos8
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    self.datePicker = [[UIDatePicker alloc]init];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //        NSDate* date=[self.datePicker date];
        //        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //        NSString * curentDatest=[formatter stringFromDate:date];
        //        UIAlertView* alert = [[UIAlertView alloc]
        //                              initWithTitle:@"提示"
        //                              message:[NSString stringWithFormat:@"你选中的%@%@%@"
        //                                       , daystr , timestr,minstr]
        //                              delegate:nil
        //                              cancelButtonTitle:@"确定"
        //                              otherButtonTitles:nil];
        //        [alert show];
        
        selectedTimestr = [NSString stringWithFormat:@"%@%@%@", daystr , timestr,minstr];
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
    }
}

@end
