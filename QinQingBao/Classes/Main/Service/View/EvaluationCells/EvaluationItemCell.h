//
//  EvaluationItemCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/3.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "EvaluationModel.h"
#import "GevalModel.h"

@interface EvaluationItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UIImageView *headIcon;
@property (strong, nonatomic) IBOutlet TQStarRatingView *evaView;
@property (strong, nonatomic) IBOutlet UITextView *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;


- (void)setitemWithData:(EvaluationModel *)item;

- (void)setitemWithShopData:(GevalModel *)item;

+ (EvaluationItemCell*) evaluationItemCell;
@end
