//
//  ServiceListCell.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceModel.h"
#import "TQStarRatingView.h"
@interface ServiceListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet TQStarRatingView *starView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *serviceTitleLab;
@property (strong, nonatomic) IBOutlet UILabel *serviceDetailLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *sunSellLab;
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *priceLabWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabWidth;

//- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;

- (void)setitemWithData:(ServiceModel *)item;

@end
