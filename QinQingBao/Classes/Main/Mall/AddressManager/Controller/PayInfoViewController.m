//
//  PayInfoViewController.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PayInfoViewController.h"
#import "PersonInfoCell.h"
#import "CommodityInfoCell.h"
#import "InvoiceInfoCell.h"
#import "SumOfMoneyCell.h"
#import "SubmitOrderCell.h"

#import "AddressTableViewController.h"
#import "AddressManagerTableViewController.h"


@interface PayInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PayInfoViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    }
    return _tableView;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.view.backgroundColor = MTNavgationBackgroundColor;
        self.navigationController.navigationBar.backgroundColor = MTNavgationBackgroundColor;
        self.title = @"填写核对购物信息";
    }
    return self;
}

- (void)creatFooterView {
    SubmitOrderCell *cell = [SubmitOrderCell submitOrder];
    self.tableView.tableFooterView = cell;
    cell.clickSubmit = ^(UIButton *btn) {
        
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    //[self creatFooterView];
    [self.view addSubview:self.tableView];
}




#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        PersonInfoCell *personInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"personInfo"];
        if (personInfoCell == nil) {
            personInfoCell = [PersonInfoCell personInfoCell];
        }
        cell = personInfoCell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *shopName = [[UITableViewCell alloc] init];
            shopName.selectionStyle = UITableViewCellSelectionStyleNone;
            shopName.imageView.image = [UIImage imageNamed:@"app"];
            shopName.textLabel.text = @"海予孝心商城";
            shopName.textLabel.font = [UIFont systemFontOfSize:14];
            shopName.textLabel.textColor = [UIColor colorWithRed:178/255 green:178/255 blue:178/255 alpha:1];
            cell = shopName;
        }else {
            CommodityInfoCell *commodityInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"commodityInfo"];
            if (commodityInfoCell == nil) {
                commodityInfoCell = [CommodityInfoCell commodityInfoCell];
//                commodityInfoCell.commodityImage = nil;
//                commodityInfoCell.commodityName.text = @"¥";
//                commodityInfoCell.commodityPrice.text = @"";
//                commodityInfoCell.commodityQuantity.text = @"";
            }
            cell = commodityInfoCell;
        }
    }
    if (indexPath.section == 2) {
        InvoiceInfoCell *invoiceInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"invoiceInfo"];
        if (invoiceInfoCell == nil) {
            invoiceInfoCell = [InvoiceInfoCell invoiceInfoCell];
            
        }
        cell = invoiceInfoCell;
    }
    if (indexPath.section == 3) {
        UITableViewCell *voucher = [[UITableViewCell alloc] init];
        voucher.textLabel.text = @"使用消费券";
        voucher.textLabel.font = [UIFont systemFontOfSize:17];
        voucher.textLabel.textColor = [UIColor colorWithRed:178/255 green:178/255 blue:178/255 alpha:1];
        voucher.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = voucher;
    }
    if (indexPath.section == 4) {
        SumOfMoneyCell *sumOfMoneyCell = [self.tableView dequeueReusableCellWithIdentifier:@"sumOfMoney"];
        if (sumOfMoneyCell == nil) {
            sumOfMoneyCell = [SumOfMoneyCell sumOfMoneyCell];
            
        }
        cell = sumOfMoneyCell;
    }
    return cell;
}
#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
    return 1;
    }else return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }else return 80;
    }
    if (indexPath.section == 2) {
        return 60;
    }
    if (indexPath.section == 3) {
        return 44;
    }
    if (indexPath.section == 4) {
        return 60;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddressTableViewController *addressVC = [AddressTableViewController new];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
