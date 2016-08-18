//
//  MTShoppingCartEndView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterveneEndViewDelegate;

@interface InterveneEndView : UIView


@property(nonatomic,assign)BOOL isEdit;
@property(weak,nonatomic)id<InterveneEndViewDelegate> delegate;
@property(nonatomic,strong)UILabel *freightLab;
@property(nonatomic,strong)UILabel *Lab;
@property(nonatomic,strong)UIButton *pushBt;
@property(nonatomic,strong)UIButton *selectedAllbt;
@property(nonatomic,strong)UIButton *deleteBt;

+(CGFloat)getViewHeight;

@end

@protocol InterveneEndViewDelegate <NSObject>

-(void)clickALLEnd:(UIButton *)bt;

-(void)clickRightBT:(UIButton *)bt;
@end
