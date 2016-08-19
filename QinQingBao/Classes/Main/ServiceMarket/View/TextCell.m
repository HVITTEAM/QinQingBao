//
//  TextCell.m
//  QinQingBao
//
//  Created by shi on 16/8/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "TextCell.h"

@interface TextCell ()<UITextFieldDelegate>



@end

@implementation TextCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"textCell";
    TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = (TextCell*)[[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textView = [[UITextField alloc] init];
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = HMColor(51, 51, 51);
        textView.textAlignment = NSTextAlignmentRight;
        textView.delegate = cell;
        [textView addTarget:cell action:@selector(contentDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:textView];
        cell.field = textView;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = HMColor(51, 51, 51);
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.field.frame = CGRectMake(100, 0, self.width - 120, self.height);
}

- (void)contentDidChange:(UITextField *)textField
{
    if (self.contentChangeCallBack) {
        self.contentChangeCallBack(self.idx,textField.text);
    }
}

@end
