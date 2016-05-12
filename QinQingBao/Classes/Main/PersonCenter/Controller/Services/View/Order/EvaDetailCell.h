//
//  EvaDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "TQStarRatingView.h"

@interface EvaDetailCell : UITableViewCell

+ (EvaDetailCell*) evaDetailCell;

@property (strong, nonatomic) IBOutlet UITextView *evaLab;

@property (strong, nonatomic) IBOutlet UILabel *evaTimeLab;
@property (strong, nonatomic) IBOutlet TQStarRatingView *evaView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *evaWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *evaHeight;

@property (nonatomic, retain) OrderModel *item;
@end
