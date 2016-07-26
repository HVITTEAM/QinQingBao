//
//  QuestionThreeViewController.h
//  Healthy
//
//  Created by shi on 16/7/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonQuesViewController.h"

@interface QuestionBtnViewController : CommonQuesViewController

@property (strong,nonatomic)NSArray *datas;      //数据源(题目选项按钮的数据)

@property (assign,nonatomic) BOOL isTwo;         //设置是否显示两排数据     默认是NO,一排按钮

@property (assign,nonatomic)BOOL isMultipleSelection;  //设置是否可以多选   默认单选

@property (assign,nonatomic)CGFloat btnHeight;   //设置按钮高度    默认是45

@property (assign,nonatomic)NSInteger eq_id;     //当前题目id

/**
 *  题目数据
 */
@property (nonatomic, retain) NSArray *dataProvider;

@end
