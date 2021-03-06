//
//  CXTabBar.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXTabBar.h"

@interface CXTabBar()
@property (nonatomic, weak) UIButton *plusButton;

@property (nonatomic, weak) UILabel *lab;

@end

@implementation CXTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) {
            self.backgroundImage = [UIImage imageWithName:@"tabbar_background"];
        }
        self.selectionIndicatorImage = [UIImage imageWithName:@"navigationbar_button_background"];
        
        // 添加中间的特殊按钮
        [self setupPlusButton];
    }
    return self;
}

/**
 *  添加按钮
 */
- (void)setupPlusButton
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor = [UIColor colorWithRGB:@"dddddd"];
    [self addSubview:line];
    
    UIButton *plusButton = [[UIButton alloc] init];
    // 设置背景
    [plusButton setBackgroundImage:[UIImage imageWithName:@"jkzx.png"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageWithName:@"jkzx.png"] forState:UIControlStateHighlighted];
    // 设置图标
    //    [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    //    [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusButton];
    self.plusButton = plusButton;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text  = @"健康咨询";
    lab.textColor = [UIColor colorWithRGB:@"999999"];
    lab.font = [UIFont systemFontOfSize:10];
    [self addSubview:lab];
    self.lab = lab;
    
}

- (void)plusClick
{
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.tabBarDelegate tabBarDidClickedPlusButton:self];
    }
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupPlusButtonFrame];
    
    [self setupAllTabBarButtonsFrame];
}

/**
 *  设置所有plusButton的frame
 */
- (void)setupPlusButtonFrame
{
    //    self.plusButton.size = self.plusButton.currentBackgroundImage.size;
    self.plusButton.size = CGSizeMake(45, 45);
    
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5 - 17);
    
    [self.lab sizeToFit];
    self.lab.center = CGPointMake(self.width * 0.5, CGRectGetMaxY(self.plusButton.frame) + 10);}

/**
 *  设置所有tabbarButton的frame
 */
- (void)setupAllTabBarButtonsFrame
{
    int index = 0;
    
    // 遍历所有的button
    for (UIView *tabBarButton in self.subviews) {
        // 如果不是UITabBarButton， 直接跳过
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        // 根据索引调整位置
        [self setupTabBarButtonFrame:tabBarButton atIndex:index];
        
        // 索引增加
        index++;
    }
}

/**
 *  设置按钮的frame
 *
 *  @param tabBarButton 需要设置的按钮
 *  @param index        按钮所在的索引
 */
- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
    CGFloat buttonW = self.width / (self.items.count + 1);
    CGFloat buttonH = self.height;
    
    tabBarButton.width = buttonW;
    tabBarButton.height = buttonH;
    if (index >= 2) {
        tabBarButton.x = buttonW * (index + 1);
    } else {
        tabBarButton.x = buttonW * index;
    }
    tabBarButton.y = 0;
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isHidden == NO) {
        CGPoint newP = [self convertPoint:point toView:self.plusButton];
        
        if ( [self.plusButton pointInside:newP withEvent:event]) {
            return self.plusButton;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
    else {
        return [super hitTest:point withEvent:event];
    }
}
@end
