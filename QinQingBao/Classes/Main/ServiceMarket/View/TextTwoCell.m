//
//  TextTwoCell.m
//  QinQingBao
//
//  Created by shi on 16/8/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "TextTwoCell.h"

@interface TextTwoCell ()<UITextViewDelegate>



@end

@implementation TextTwoCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"textTwoCell";
    TextTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TextTwoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentTextView.delegate = cell;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentTextView.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.contentTextView.layer.borderWidth = 0.5f;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeHolderLb.hidden = YES;
    }else{
        self.placeHolderLb.hidden = NO;
    }
    
    if (self.contentChangeCallBack) {
        self.contentChangeCallBack(self.idx,textView.text);
    }
}

@end
