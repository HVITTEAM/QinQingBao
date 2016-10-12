//
//  AbilityCell.m
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AbilityCell.h"

@interface AbilityCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation AbilityCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *abilityCellId = @"abilityCell";
    AbilityCell *cell = [tableView dequeueReusableCellWithIdentifier:abilityCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AbilityCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentTextView.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.contentTextView.layer.borderWidth = 1.0f;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.markedTextRange == nil)
        NSLog(@"dad");
    if (textView.text.length > 0) {
        self.placeholderLb.hidden = YES;
    }else{
        self.placeholderLb.hidden = NO;
    }

    if (self.textDidChangeCallBack) {
        self.textDidChangeCallBack(textView.text);
    }
}

@end
