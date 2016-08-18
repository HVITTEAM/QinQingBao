//
//  CustomInfoController.m
//  QinQingBao
//
//  Created by shi on 16/8/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CustomInfoController.h"
#import "InfoValue1Cell.h"

@interface CustomInfoController ()

@end

@implementation CustomInfoController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title  = @"客户信息";
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 3 && indexPath.row != 9 && indexPath.row != 10 ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = HMColor(51, 51, 51);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor = HMColor(51, 51, 51);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"姓名";
                cell.detailTextLabel.text = @"姓名";
                break;
            case 1:
                cell.textLabel.text = @"电话";
                cell.detailTextLabel.text = @"电话";
                break;
            case 2:
                cell.textLabel.text = @"Email";
                cell.detailTextLabel.text = @"Email";
                break;
            case 4:
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = @"性别";
                break;
            case 5:
                cell.textLabel.text = @"出生日期";
                cell.detailTextLabel.text = @"出生日期";
                break;
            case 6:
                cell.textLabel.text = @"身高";
                cell.detailTextLabel.text = @"身高";
                break;
            case 7:
                cell.textLabel.text = @"体重";
                cell.detailTextLabel.text = @"体重";
                break;
            case 8:
                cell.textLabel.text = @"女性特殊期";
                cell.detailTextLabel.text = @"女性特殊期";
                break;
            default:
                break;
        }
        
        return cell;

    }else{
       InfoValue1Cell *infoValue1Cell = [InfoValue1Cell createCellWithTableView:tableView];
        
        if (indexPath.row == 3) {
            [infoValue1Cell setTitle:@"地址" value:nil];
        }else if (indexPath.row == 9){
            [infoValue1Cell setTitle:@"既往病史" value:@"撒旦法撒旦法来就是了"];
        }else if (indexPath.row == 10){
            [infoValue1Cell setTitle:@"既往病史" value:@"撒旦法撒旦法来就是了都放假了束带结发老师嫁老大废旧塑料地方就是李东方吉林省撒旦法撒旦法来就是了都水电费金沙岛积分拉伸000000"];
        }
        
        return infoValue1Cell;
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3 && indexPath.row != 9 && indexPath.row != 10) {
        return 45;
    }

    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

@end
