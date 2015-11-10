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


@interface EvaluationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet TQStarRatingView *Evaview;
@property (strong, nonatomic) IBOutlet UIButton *queryEva;
@property (strong, nonatomic) IBOutlet UIImageView *HeadImage;
- (IBAction)queryAllEvaluationClickHandler:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *evanumLab;
@property (nonatomic, copy) void (^queryClick)(UIButton *btn);

@property (nonatomic, retain) ServiceItemModel *itemInfo;

@end
