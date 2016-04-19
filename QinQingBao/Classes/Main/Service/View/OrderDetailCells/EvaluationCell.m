//
//  EvaluationCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "EvaluationCell.h"

@implementation EvaluationCell

+ (EvaluationCell*) evaluationCell
{
    EvaluationCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    
    self.contentView.backgroundColor = HMGlobalBg;
    
    self.Evaview.userInteractionEnabled = NO;
    
    self.HeadImage.layer.cornerRadius = self.HeadImage.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)queryAllEvaluationClickHandler:(id)sender
{
    self.queryClick(sender);
}


-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    if (!itemInfo)
        return;
    self.evanumLab.text = [NSString stringWithFormat:@"%.01f分",[itemInfo.sumgrad floatValue]/[itemInfo.sumdis floatValue]];
    float score = [itemInfo.sumgrad floatValue]/[itemInfo.sumdis floatValue];
    
    if (score >= 0 && score <= 5)
        [self.Evaview setScore:score/5 withAnimation:NO];
    else
        [self.Evaview setScore:0 withAnimation:NO];
    
    [self.queryEva setTitle:[NSString stringWithFormat:@"查看全部%@条评价",itemInfo.sumdis] forState:UIControlStateNormal];
}

-(void)setEvaItem:(EvaluationModel *)evaItem
{
    _evaItem = evaItem;
    if (!evaItem)
        return;
    self.nameLab.text  = @"匿名";
    self.timeLab.text  = evaItem.wpjtime;
    self.contentLab.text  = evaItem.dis_con;
    
    CGRect tmpRect = [self.contentLab.text boundingRectWithSize:CGSizeMake(MTScreenW - 20, 1000)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.contentLab.font,NSFontAttributeName, nil]
                                            context:nil];

    self.contentLabWidth.constant = tmpRect.size.height;

    //60是下方的高度
    self.height = CGRectGetMaxY(self.contentLab.frame) + 30;
    
}
@end
