//
//  HealthArchivesController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "QCListViewController.h"
#import "FamilyInforModel.h"

@interface HealthArchivesController : UIViewController<QCSlideSwitchViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

@property (nonatomic, retain) FamilyInforModel *familyInfoTotal;

@end
