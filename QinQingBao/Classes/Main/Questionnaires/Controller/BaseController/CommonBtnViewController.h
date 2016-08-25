//
//  QuestionThreeViewController.h
//  Healthy
//
//  Created by shi on 16/7/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonQuesViewController.h"
#import "ButtonCell.h"

@interface CommonBtnViewController : CommonQuesViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;

@property (weak, nonatomic) IBOutlet UICollectionView *btnCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigImageViewWidthHeightCons;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLb;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;

@property (assign,nonatomic) BOOL isTwo;         //设置是否显示两排数据     默认是NO,一排按钮

@property (assign,nonatomic)BOOL isMultipleSelection;  //设置是否可以多选   默认单选

@property (assign,nonatomic)CGFloat btnHeight;   //设置按钮高度    默认是45

@property (assign,nonatomic)NSInteger eq_id;     //当前题目的序号(即页面序号,默认为0)

@property (strong, nonatomic)NSMutableArray *selectedIdxArray;   //选中的选项(数组元素是NSIndexPath)

@property (strong,nonatomic)NSArray *datas;      //题目选项按钮的数据源,默认数组元素个数为0

//分析规则
-(NSArray *)analyzeRules:(NSString *)rule;

@end
