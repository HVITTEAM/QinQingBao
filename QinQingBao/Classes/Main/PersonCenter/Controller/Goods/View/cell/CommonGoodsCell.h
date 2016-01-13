//
//  GoodsCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonGoodsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *statusLab;

@property (strong, nonatomic) IBOutlet UIImageView *goodsIconImg;

@property (strong, nonatomic) IBOutlet UILabel *goodsTitleLab;

@property (strong, nonatomic) IBOutlet UILabel *priceLab;

@property (strong, nonatomic) IBOutlet UILabel *countLab;

@property (strong, nonatomic) IBOutlet UILabel *desLab;

@property (strong, nonatomic) IBOutlet UIButton *evaBtn;

@property (strong, nonatomic) IBOutlet UIButton *deliverBtn;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
+(CommonGoodsCell *) commonGoodsCell;

@end
