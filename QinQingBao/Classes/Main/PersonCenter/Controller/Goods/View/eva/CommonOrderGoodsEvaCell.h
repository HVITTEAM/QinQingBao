//
//  CommonOrderGoodsEvaCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendOrderGoodsModel.h"

@interface CommonOrderGoodsEvaCell : UITableViewCell
{
    float maxStar;
}

+(CommonOrderGoodsEvaCell *) commonOrderGoodsEvaCell;

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UITextView *contentText;

@property (strong, nonatomic) IBOutlet UIButton *star1;
@property (strong, nonatomic) IBOutlet UIButton *star2;
@property (strong, nonatomic) IBOutlet UIButton *star3;
@property (strong, nonatomic) IBOutlet UIButton *star4;
@property (strong, nonatomic) IBOutlet UIButton *star5;
- (IBAction)starClickeHandler:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, retain) ExtendOrderGoodsModel *goodsItem;
-(void)setitemWithData:(ExtendOrderGoodsModel *)item;

-(NSString *)getEvaContent;

@end
