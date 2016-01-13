//
//  ClassificationViewController.h
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSMutableArray *goodsClass; 

@property (weak, nonatomic) IBOutlet UITableView *symptomTableView;
@property (weak, nonatomic) IBOutlet UITableView *positionTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;

@end
