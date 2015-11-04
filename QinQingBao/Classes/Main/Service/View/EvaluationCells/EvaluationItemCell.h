//
//  EvaluationItemCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/3.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface EvaluationItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headIcon;
@property (strong, nonatomic) IBOutlet TQStarRatingView *evaView;
@property (strong, nonatomic) IBOutlet UITextView *contentLab;

@end
