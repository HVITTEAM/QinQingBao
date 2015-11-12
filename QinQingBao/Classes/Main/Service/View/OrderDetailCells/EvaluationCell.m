//
//  EvaluationCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "EvaluationCell.h"

@implementation EvaluationCell

- (void)awakeFromNib {
    
    self.contentView.backgroundColor = HMGlobalBg;
    
    self.Evaview.userInteractionEnabled = NO;
    
    //    [self.queryEva setImage:[UIImage imageNamed:@"second_normal.png"] forState:UIControlStateNormal];//给button添加image
    //    self.queryEva.imageEdgeInsets = UIEdgeInsetsMake(0,MTScreenW - 30,0, 10);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
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
    [self.Evaview setScore:score/5 withAnimation:YES];
    [self.queryEva setTitle:[NSString stringWithFormat:@"查看全部%@条评价",itemInfo.sumdis] forState:UIControlStateNormal];
}

-(void)setEvaItem:(EvaluationModel *)evaItem
{
    _evaItem = evaItem;
    if (!evaItem)
        return;
    self.nameLab.text  = evaItem.oldname;
    self.timeLab.text  = evaItem.wpjtime;
    self.contentLab.text  = evaItem.dis_con;
    self.contentLab.text  = @"味道很好，速度很快，赞！味道很好，速度很快，赞！味道很好，速度很快，赞！味道很好，速度很快，赞";
//    self.height = CGRectGetMaxY(self.queryEva.frame);
}
@end
