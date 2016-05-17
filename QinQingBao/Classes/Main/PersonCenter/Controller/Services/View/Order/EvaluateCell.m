//
//  EvaluateCell.m
//  QinQingBao
//
//  Created by shi on 16/3/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EvaluateCell.h"

@interface EvaluateCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;

@property (weak, nonatomic) IBOutlet UITextView *evaluateTextView;

@property (weak, nonatomic) IBOutlet UILabel *startDescLb;

@end

@implementation EvaluateCell


+(instancetype)createEvaluateCellWithTableView:(UITableView *)tableview
{
    static NSString *evaluateCellId = @"evaluateCell";
    EvaluateCell *cell = [tableview dequeueReusableCellWithIdentifier:evaluateCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluateCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib
{
    self.evaluateTextView.layer.cornerRadius = 8.0f;
    self.evaluateTextView.layer.masksToBounds = YES;
    self.evaluateTextView.layer.borderColor  = HMColor(220, 220, 220).CGColor;
    self.evaluateTextView.layer.borderWidth = .5f;
    
    self.evaluateTextView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text == nil || textView.text.length == 0) {
        self.placeholderLb.hidden = NO;
    }else{
        self.placeholderLb.hidden = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(evaluateCell:didEvaluateContentChange:)]) {
        [self.delegate evaluateCell:self didEvaluateContentChange:self.evaluateTextView.text];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (IBAction)starBtnTapped:(UIButton *)sender
{
    //设置星星的显示
    if (sender.tag == 100) {
        [NoticeHelper AlertShow:@"最低为1星" view:self];
        sender.selected = YES;
    }else{
        sender.selected = !sender.selected;
    }
    
    for (int i = 100; i < sender.tag; i++) {
        UIButton *starBtn = [self viewWithTag:i];
        starBtn.selected = YES;
    }

    for (int i = (int)sender.tag + 1 ; i <= 100 + 4; i++) {
        UIButton *starBtn = [self viewWithTag:i];
        starBtn.selected = NO;
    }

    //设置分数
    NSInteger score = sender.tag - 100 ;
    if (sender.selected) {
        score++;
    }
    
    //设置星星描述
    if (score == 0)
        self.startDescLb.text = @"";
    if (score == 1)
        self.startDescLb.text = @"很差";
    else  if (score == 2)
        self.startDescLb.text = @"一般";
    else  if (score == 3)
        self.startDescLb.text = @"好";
    else  if (score == 4)
        self.startDescLb.text = @"很好";
    else  if (score == 5)
        self.startDescLb.text = @"非常好";
    
    if ([self.delegate respondsToSelector:@selector(evaluateCell:evaluateScore:)]) {
        [self.delegate evaluateCell:self evaluateScore:score];
    }
}

@end
