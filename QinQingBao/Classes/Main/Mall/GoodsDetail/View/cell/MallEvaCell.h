//
//  MallEvaCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GevalModel.h"

@interface MallEvaCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, copy) void (^checkClick)(UIButton *btn);

+(MallEvaCell *)mallEvaCell;

@property (nonatomic, retain) GevalModel *gevalModel;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLab;

@property (nonatomic, assign) NSInteger totalCount;
@end
