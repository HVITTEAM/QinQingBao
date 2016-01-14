//
//  CommonGoodsCellBottom.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGoodsModel.h"

@interface CommonGoodsCellBottom : UITableViewCell

+(CommonGoodsCellBottom *) commonGoodsCellBottom;

-(void)setitemWithData:(CommonGoodsModel *)item;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet UILabel *desLab;
@property (strong, nonatomic) IBOutlet UIButton *evaBtn;
@property (strong, nonatomic) IBOutlet UIButton *deliverBtn;
@property (strong, nonatomic) IBOutlet UIButton *delateBtn;

@property (nonatomic, copy) void (^buttonClick)(UIButton *btn);

@end
