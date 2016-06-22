//
//  MarketOrderSubmitController.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketOrderSubmitController.h"
#import "MarketOrderCell.h"
#import "MarketPromptCell.h"
#import "SWYSubtitleCell.h"
#import "PaymentViewController.h"
#import "MarketCustominfoController.h"

@interface MarketOrderSubmitController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

/**  临时使用 */
@property (strong,nonatomic)NSString *nameStr;

@end

@implementation MarketOrderSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 60) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 60, MTScreenW, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 1)];
    line.backgroundColor = HMColor(230, 230, 230);
    [bottomView addSubview:line];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 40, 40)];
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    btn.backgroundColor = HMColor(255, 126, 0);
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    [self.view addSubview:bottomView];
}

#pragma mark - 协议方法
#pragma  mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.nameStr) {
            return 1;
        }
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        //每个section的标题
        static NSString *titleCellId = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:titleCellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.section == 0) {
            titleCell.textLabel.text = @"客户信息";
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section == 1){
            titleCell.textLabel.text = @"寸欣健康科技馆";
            titleCell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            titleCell.textLabel.text = @"下单须知";
            titleCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell = titleCell;
    }else if (indexPath.section == 0){
        //客户信息
        SWYSubtitleCell *infoCell = [SWYSubtitleCell createSWYSubtitleCellWithTableView:tableView];
        infoCell.detailTextLabel.textColor = [UIColor darkGrayColor];
        infoCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        infoCell.textLabel.text = [NSString stringWithFormat:@"%@  %@",self.nameStr,@"13739009098"];
        infoCell.detailTextLabel.text = @"撒旦法杀毒发撒地方柑柑棋发地方撒点粉啥发撒地方隧道股份噶微弱微任务收到回复";
        cell = infoCell;
    }else if (indexPath.section == 1){
        //店铺信息
        MarketOrderCell *marketOrderCell = [MarketOrderCell createCellWithTableView:tableView];
        cell = marketOrderCell;
    }else{
        //下单须知
        MarketPromptCell *pCell = [MarketPromptCell createCellWithTableView:tableView];
        pCell.contentStr = @"撒旦法撒旦法杀毒发撒地方柑柑棋发贺卡收到回复看沙发哈萨克货到付款哈萨克发货的看啥货到付款哈萨克沙发沙发上发啊发啥呆的地";
        cell = pCell;
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

#pragma  mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 50;
    }else if (0 == indexPath.section){
        return 70;
    }else if (1== indexPath.section){
        return 120;
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MarketCustominfoController *vc = [MarketCustominfoController initWith:@"老王" tel:@"13739909098" address:@"杭州" email:@"123@qq.com"];
        vc.inforClick = ^(NSString *name,NSString *tel,NSString *address,NSString *email){
            NSLog(@"%@ %@ %@ %@",name,tel,address,email);
            self.nameStr = name;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 事件
-(void)submitOrder:(UIButton *)sender
{
    PaymentViewController *vc = [[PaymentViewController alloc] init];
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *backToVC = vcs[vcs.count - 2];
    vc.imageUrlStr = nil;
    vc.content = @"描述";
    vc.wprice = @"180元";
    vc.wid = @"wid";
    vc.wcode = @"wcode";
    vc.store_id = @"storeId";
    vc.productName = @"productName";
    vc.viewControllerOfback = backToVC;
    vc.doneHandlerClick = ^{
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
