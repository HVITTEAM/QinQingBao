//
//  AllQuestionController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClasslistModel.h"

@interface AllQuestionController : UITableViewController

@property(copy,nonatomic)NSString *c_id;  //分类ID;

@property(strong, nonatomic) ClasslistModel *classlistModel;

@end
