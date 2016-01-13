//
//  AddressManagerCell.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressManagerCell.h"

@implementation AddressManagerCell

+ (AddressManagerCell *)addressManagerCell
{
    AddressManagerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressManagerCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        UIImage *btimg = [UIImage imageNamed:@"Unselected.png"];
        UIImage *selectImg = [UIImage imageNamed:@"Selected.png"];
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 75, 25, 25)];
        [_leftBtn addTarget:self action:@selector(clickAll:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag = 10000;
        [_leftBtn setImage:btimg forState:UIControlStateNormal];
        [_leftBtn setImage:selectImg forState:UIControlStateSelected];
        // _leftBtn.selected = YES;
        [self addSubview:_leftBtn];
    }
    return _leftBtn;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.deleteBtn.layer.cornerRadius = 3;
    self.deleteBtn.backgroundColor = [UIColor clearColor];
    
    self.editBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.cornerRadius = 3;
    self.editBtn.backgroundColor = [UIColor clearColor];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
}

-(void)clickAll:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.chooseLable.hidden = !sender.selected;
    self.clickSetDefault(self.item);
}

-(void)setItem:(MallAddressModel *)item
{
    _item = item;
    self.leftBtn.selected = [item.is_default isEqualToString:@"0"] ? NO : YES;
    self.chooseLable.hidden = [item.is_default isEqualToString:@"0"] ? YES : NO;;
    self.name.text = item.true_name;
    self.phone.text = item.mob_phone;
    self.address.text = [NSString stringWithFormat:@"%@%@",item.area_info,item.address];
}

- (IBAction)setDefaultaddresHandler:(id)sender
{
    //失效
}

- (IBAction)clickDeleteBtn:(id)sender
{
    self.clickDelete(self.item);
}
- (IBAction)clickEditBtn:(id)sender
{
    self.clickEdit(self.item);
}


- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
