//
//  DietaryHabit.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietaryHabit : UIView

+(DietaryHabit *)showTargetViewToView:(UIView *)targetView;

@property (copy) void(^selectItemBlock)(NSArray *selectedItems);

@property (strong, nonatomic) NSArray *valueArray;

@end
