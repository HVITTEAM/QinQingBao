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
}
@end
