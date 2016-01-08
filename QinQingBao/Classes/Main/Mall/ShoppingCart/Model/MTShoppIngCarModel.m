//
//  MTShoppIngCarModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTShoppIngCarModel.h"

@implementation MTShoppIngCarModel



- (void)setVm:(MTShopViewModel *)vm
{
    _vm = vm;
    [self addObserver:vm forKeyPath:@"isSelect" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}
-(void)dealloc
{

    
    [self removeObserver:_vm forKeyPath:@"isSelect"];

}

@end
