//
//  BalanceViewController.m
//  QinQingBao
//   我的余额
//  Created by 董徐维 on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BalanceViewController.h"
#import "BalanceModel.h"
#import "BalanceLogModel.h"
#import "MTDateHelper.h"
#import "RechargeViewController.h"

@interface BalanceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;

@property (strong, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UILabel *balanceLb;

@property(strong,nonatomic)BalanceModel *balanceModel;

@property(strong,nonatomic)NSArray *balanceLogArray;

@end

@implementation BalanceViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadBalanceData];
}

/**
 *  初始化界面
 */
- (void)initView
{
    self.navigationItem.title = @"我的余额";
    
    self.headView.layer.cornerRadius = self.headView.height/2;
    
    self.rechargeBtn.layer.borderColor = [[UIColor colorWithRGB:@"cccccc"] CGColor];
    self.rechargeBtn.layer.borderWidth = 0.5;
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.tableFooterView = [[UIView alloc] init];
}

/**
 *  初始化界面
 */
-(NSArray *)balanceLogArray
{
    if (!_balanceLogArray) {
        _balanceLogArray = [[NSArray alloc] init];
    }
    
    return _balanceLogArray;
}

#pragma mark - 协议方法
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.balanceLogArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    BalanceLogModel *model = self.balanceLogArray[indexPath.row];
    
    if (commoncell == nil){
        commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MTCommonCell"];
        UILabel *lb = [[UILabel alloc] init];
        lb.font = [UIFont systemFontOfSize:16];
        commoncell.accessoryView = lb;
        float f = [model.lg_av_amount floatValue];
        if (f < 0)
        {
            lb.textColor = MTNavgationBackgroundColor;
            lb.text = model.lg_av_amount;
        }
        else
        {
            lb.text = [NSString stringWithFormat:@"+%@",model.lg_av_amount];
            lb.textColor = [UIColor orangeColor];
        }
        commoncell.textLabel.font = [UIFont systemFontOfSize:16];
        commoncell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        commoncell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    commoncell.detailTextLabel.text = [MTDateHelper getDaySince1970:model.lg_add_time dateformat:@"yyyy-MM-dd HH:mm:ss"];
    commoncell.textLabel.text = model.lg_desc;
    [((UILabel *)commoncell.accessoryView) sizeToFit];
    return commoncell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - 网络相关
/**
 *  获取余额相关信息包括使用记录
 */
-(void)loadBalanceData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"curpage":@"1",
                             @"page":@"50"};
    [CommonRemoteHelper RemoteWithUrl:URL_get_member_blance parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [HUD removeFromSuperview];
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"未获取到数据" view:self.view];
        }else{
            BalanceModel *balanceMD = [BalanceModel objectWithKeyValues:dict[@"datas"]];
            self.balanceModel = balanceMD;
            self.balanceLogArray = balanceMD.log;
            self.balanceLb.text = balanceMD.available_rc_balance;
            [self.table reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求失败" view:self.view];
        [HUD removeFromSuperview];
    }];
}

#pragma mark - 工具方法
/**
 *  将类型转换成相关的描述
 */
-(NSString *)switchTypeToDesc:(NSString *)type
{
    if ([type isEqualToString:@"order_pay"]) {
        return @"下单支付预存款";
    }else if ([type isEqualToString:@"order_freeze"]){
        return @"下单冻结预存款";
    }else if ([type isEqualToString:@"order_cancel"]){
        return @"取消订单解冻预存款";
    }else if ([type isEqualToString:@"order_comb_pay"]){
        return @"下单支付被冻结的预存款";
    }else if ([type isEqualToString:@"recharge"]){
        return @"充值";
    }else if ([type isEqualToString:@"cash_apply"]){
        return @"申请提现冻结预存款";
    }else if ([type isEqualToString:@"cash_pay"]){
        return @"提现成功";
    }else if ([type isEqualToString:@"cash_del"]){
        return @"取消提现申请，解冻预存款";
    }else if ([type isEqualToString:@"refund"]){
        return @"退款";
    }
    return nil;
}

/**
 *  跳转到充值界面
 */
- (IBAction)rechargeAction:(id)sender
{
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

@end
