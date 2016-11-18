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

    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5 - 10);
}

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
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusButton];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.plusButton pointInside:newP withEvent:event]) {
            return self.plusButton;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}
@end
