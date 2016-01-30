//
//  SymptomDetailViewController.h
//  QinQingBao
//
//  Created by shi on 16/1/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SymptomNameModel;

@interface SymptomDetailViewController : UITableViewController

@property(strong,nonatomic)SymptomNameModel *nameModel;          //症状名字模型

@end
