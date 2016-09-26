//
//  QuestionCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClasslistModel.h"

@interface QuestionCell : UITableViewCell
+ (instancetype)createCellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;

@property (nonatomic, retain) NSArray *dataProvider;

@property (nonatomic, copy) void (^portraitClick)(ClasslistModel *itemData);

@end
