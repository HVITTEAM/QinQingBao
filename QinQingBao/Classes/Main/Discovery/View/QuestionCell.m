//
//  QuestionCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionCell.h"
#import "ClasslistModel.h"

@implementation QuestionCell


+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *siglePicCardCellId = @"questionCell";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:siglePicCardCellId];
    if (!cell) {
        cell.height = 85;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setDataProvider:(NSArray *)dataProvider
{
    _dataProvider = dataProvider;
    ClasslistModel *model = dataProvider[0];
    ClasslistModel *model1 = dataProvider[1];

    NSURL *url = [NSURL URLWithString:model.c_itemurl];
    NSURL *url1 = [NSURL URLWithString:model1.c_itemurl];

    self.img1.layer.masksToBounds = YES;
    self.img1.layer.cornerRadius = 6;
    self.img2.layer.masksToBounds = YES;
    self.img2.layer.cornerRadius = 6;
    [self.img1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.img2 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    self.img1.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [self.img1 addGestureRecognizer:singleTap];

    self.img2.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [self.img2 addGestureRecognizer:singleTap2];

}

-(void)onClickImage:(UITapGestureRecognizer *)recognizer
{
    if(self.portraitClick)
    {
        if (recognizer.view == self.img1)
        {
            self.portraitClick(_dataProvider[0]);
        }
        else
        {
            self.portraitClick(_dataProvider[1]);
        }
    }
}

@end
