//
//  EvaluationCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "ServiceItemModel.h"
#import "EvaluationModel.h"


@interface EvaluationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet TQStarRatingView *Evaview;
@property (strong, nonatomic) IBOutlet UIButton *queryEva;
@property (strong, nonatomic) IBOutlet UIImageView *HeadImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
//评价内容的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabWidth;

- (IBAction)queryAllEvaluationClickHandler:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *evanumLab;
@property (nonatomic, copy) void (^queryClick)(UIButton *btn);
@property (nonatomic, retain) ServiceItemModel *itemInfo;
@property (nonatomic, retain) EvaluationModel *evaItem;

+ (EvaluationCell*) evaluationCell;
@end
