//
//  OrderManCell.m
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "OrderManCell.h"

@interface OrderManCell ()

@property(strong,nonatomic)UILabel *nameLb;

@property(strong,nonatomic)UILabel *phoneLb;

@property(strong,nonatomic)UILabel *addressLb;

@end

@implementation OrderManCell

+(instancetype)createOrderManCellWithTableView:(UITableView *)tableview
{
    static NSString *orderManCellId = @"orderManCell";
    OrderManCell *cell = [tableview dequeueReusableCellWithIdentifier:orderManCellId];
    if (!cell) {
        cell = [[OrderManCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderManCellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.nameLb = [[UILabel alloc] init];
        cell.nameLb.font = [UIFont systemFontOfSize:14];
        cell.nameLb.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:cell.nameLb];
        
        cell.phoneLb = [[UILabel alloc] init];
        cell.phoneLb.font = [UIFont systemFontOfSize:14];
        cell.phoneLb.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:cell.phoneLb];
        
        cell.addressLb = [[UILabel alloc] init];
        cell.addressLb.font = [UIFont systemFontOfSize:14];
        cell.addressLb.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:cell.addressLb];
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)setupCellUI
{
    self.nameLb.text = self.nameStr;
    [self.nameLb sizeToFit];
    self.nameLb.frame = CGRectMake(15, 10, self.nameLb.width, self.nameLb.height);
    
    self.phoneLb.text = self.phoneStr;
    [self.phoneLb sizeToFit];
    self.phoneLb.frame = CGRectMake(CGRectGetMaxX(self.nameLb.frame) + 10, 10, self.phoneLb.width, self.phoneLb.height);
    
    self.addressLb.text = self.addressStr;
    CGSize size = [self.addressStr boundingRectWithSize:CGSizeMake(MTScreenW - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.addressLb.frame = CGRectMake(15, CGRectGetMaxY(self.nameLb.frame) + 10, size.width, size.height);
    CGFloat h = CGRectGetMaxY(self.addressLb.frame) + 10;
    return h;
}

@end
