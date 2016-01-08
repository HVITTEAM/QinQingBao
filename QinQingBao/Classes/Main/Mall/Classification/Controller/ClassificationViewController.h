//
//  ClassificationViewController.h
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain)NSMutableArray *dataProvider;


@property(strong,nonatomic)NSMutableArray *symptoms; //具体症状数据源

@property (weak, nonatomic) IBOutlet UITableView *symptomTableView; //症状表视图
@property (weak, nonatomic) IBOutlet UITableView *positionTableView; //症状位置表视图
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;

@end
