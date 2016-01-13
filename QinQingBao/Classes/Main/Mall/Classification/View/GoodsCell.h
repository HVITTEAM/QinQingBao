//
//  GoodsCell.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceModel.h"

@interface GoodsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet Star *starView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *serviceTitleLab;
@property (strong, nonatomic) IBOutlet UILabel *serviceDetailLab;
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;
@property (strong, nonatomic) IBOutlet UILabel *evaLab;

- (void)setitemWithData:(ServiceModel *)item;

+ (GoodsCell*) goodsCell;

@end
