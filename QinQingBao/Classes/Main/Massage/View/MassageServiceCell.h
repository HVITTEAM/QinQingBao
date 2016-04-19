//
//  MassageServiceCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MassageModel.h"


@interface MassageServiceCell : UITableViewCell

+ (MassageServiceCell *)massageServiceCell;

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *sellLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, retain) MassageModel *item;
@end
