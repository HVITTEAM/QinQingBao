//
//  EvaluationNoneCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationNoneCell : UITableViewCell
@property (strong, nonatomic) IBOutlet Star *evaView;


+ (EvaluationNoneCell*) evanoneCell;
@end