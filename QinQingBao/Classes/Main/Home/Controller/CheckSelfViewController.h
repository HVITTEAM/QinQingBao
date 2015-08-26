//
//  CheckSelfViewController.h
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckSelfViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSArray *symptomPositions;//症状位置数据源
@property(strong,nonatomic)NSMutableArray *symptoms; //具体症状数据源

@property (weak, nonatomic) IBOutlet UITableView *symptomTableView; //症状表视图
@property (weak, nonatomic) IBOutlet UITableView *positionTableView; //症状位置表视图

@end
