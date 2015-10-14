//
//  CAttention.m
//  VideoGo
//
//  Created by hongfei hu on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CAttention.h"

#define UIColorFromRGB(rgbValue, alp)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alp]



@implementation CAttention

// 默认弱提示展示
+ (void)showAutoHiddenAttention:(NSString *)text
                         toView:(UIView *)view
{
    if (nil == view)
    {
        return;
    }
    
    MBProgressHUD *mbProgressHUD_scr = (MBProgressHUD *)[view viewWithTag:TAG_HUD];
    if (mbProgressHUD_scr != nil &&
        [mbProgressHUD_scr isKindOfClass:[MBProgressHUD class]])
    {
        [mbProgressHUD_scr hide:YES];
    }
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    mbProgressHUD.tag = TAG_HUD;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    mbProgressHUD.customView = customView;
    [mbProgressHUD setMode:MBProgressHUDModeCustomView];
    [mbProgressHUD setRemoveFromSuperViewOnHide:YES];
    if (text != nil && [text isKindOfClass:[NSString class]])
    {
        mbProgressHUD.detailsLabelText = text;
    }
    else
    {
        mbProgressHUD.detailsLabelText = @"";
    }
    mbProgressHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    
    [mbProgressHUD hide:YES afterDelay:2.0f];
}

// 自定义弱提示展示 向上偏移量 字体大小 是否需要加蒙班
+ (void)showCustomAutoHiddenAttention:(NSString *)text 
                               toView:(UIView *)view
                            toYOffset:(float)yOffset
                           toFontSize:(UIFont *)font
                    toIsDimBackground:(BOOL)bDimBackground
{
    if (nil == view)
    {
        return;
    }
    
    MBProgressHUD *mbProgressHUD_scr = nil;
    mbProgressHUD_scr = (MBProgressHUD *)[view viewWithTag:TAG_HUD];
    if (mbProgressHUD_scr != nil &&
        [mbProgressHUD_scr isKindOfClass:[MBProgressHUD class]])
    {
        [mbProgressHUD_scr hide:YES];
    }
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    mbProgressHUD.tag = TAG_HUD;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    mbProgressHUD.customView = customView;
    [mbProgressHUD setMode:MBProgressHUDModeCustomView];
    [mbProgressHUD setRemoveFromSuperViewOnHide:YES];
    [view bringSubviewToFront:mbProgressHUD];
    if (text != nil && [text isKindOfClass:[NSString class]])
    {
        mbProgressHUD.detailsLabelText = text;
    }
    else
    {
        mbProgressHUD.detailsLabelText = @"";
    }
    mbProgressHUD.yOffset = yOffset;
    //add by hyw 判断iphone5进行适当偏移
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //mbProgressHUD.yOffset = yOffset-44.0f;
    }
    
    mbProgressHUD.dimBackground = bDimBackground;
    if (font != nil) 
    {
        mbProgressHUD.detailsLabelFont = font;
    }
    else
    {
        mbProgressHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    }
    [mbProgressHUD hide:YES afterDelay:2.0f];
}

// 创建默认忙等待提示
+ (MBProgressHUD *)createWaitViewtoText:(NSString *)text
                                 toView:(UIView *)view
{
    if (nil == view)
    {
        return nil;
    }
    
    MBProgressHUD *mbProgressHUD_scr = (MBProgressHUD *)[view viewWithTag:TAG_HUD];
    if (mbProgressHUD_scr != nil &&
        [mbProgressHUD_scr isKindOfClass:[MBProgressHUD class]])
    {
        [mbProgressHUD_scr hide:YES];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.tag = TAG_HUD;
//    [view addSubview:hud];
//    hud.labelText = text;
    if (text != nil && [text isKindOfClass:[NSString class]])
    {
        if ([text length] == 0) {
            hud.labelText = nil;
        }else{
            hud.labelText = text;
        }
    }
    else
    {
        hud.labelText = nil;
    }
    return hud;
}

+ (MBProgressHUD *)loadingViewWithText:(NSString *)text toView:(UIView *)view
{
    if (nil == view)
    {
        NSLog(@"MBProgressHUD can not be initilized as the view is nil");
        return nil;
    }
    
    MBProgressHUD *mbProgressHUD_scr = (MBProgressHUD *)[view viewWithTag:TAG_HUD];
    
    if (mbProgressHUD_scr != nil && [mbProgressHUD_scr isKindOfClass:[MBProgressHUD class]])
    {
        [mbProgressHUD_scr hide:YES];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.tag = TAG_HUD;
    
    if (0 != [text length])
    {
        hud.labelText = text;
    }
    
    return hud;
}

// 创建自定义忙等待提示
+ (MBProgressHUD *)createWaitViewtoText:(NSString *)text
                                 toView:(UIView *)view
                              toYOffset:(float)yOffset
                             toFontSize:(UIFont *)font
                      toIsDimBackground:(BOOL)bDimBackground
{
    if (nil == view)
    {
        return nil;
    }
    
    MBProgressHUD *mbProgressHUD_scr = (MBProgressHUD *)[view viewWithTag:TAG_HUD];
    if (mbProgressHUD_scr != nil &&
        [mbProgressHUD_scr isKindOfClass:[MBProgressHUD class]])
    {
        [mbProgressHUD_scr hide:YES];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.tag = TAG_HUD;
//    [view addSubview:hud];
//    hud.labelText = text;
    if (text != nil && [text isKindOfClass:[NSString class]])
    {
        if ([text length] == 0) {
            hud.labelText = nil;
        }else{
            hud.labelText = text;
        }
    }
    else
    {
        hud.labelText = nil;
    }
    hud.yOffset = yOffset;
    hud.dimBackground = bDimBackground;
    if (font != nil) 
    {
        hud.labelFont = font;
    }
    return hud;
}

// 隐藏忙等待提示
+ (void)hiddenWaitView:(MBProgressHUD *)hud
{
    if (hud != nil)
    {
        [hud hide:YES];
        [hud removeFromSuperview];
//        [hud release];
//        hud = nil;
    }
}

// 添加气泡提示
+ (void)addBubble:(UIView *)view
toCancleBtnDelegate:(id)delegate
     toLabelRight:(float)right
           toText:(NSString *)text
       toBtnFrame:(CGRect)btnFrame
         toAction:(SEL)action
{
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setFrame:btnFrame];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"Notes_Mistake.png"] forState:UIControlStateNormal];
    [cancleBtn addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTag:TAG_ATTENTION_BUBBLE_BTN];
    [view addSubview:cancleBtn];
    
    CGRect partFrame = CGRectMake(btnFrame.origin.x + 3, btnFrame.origin.y - 9, 8, 8);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Notes_Part.png"]];
    [imageView setFrame:partFrame];
    [imageView setTag:TAG_ATTENTION_BUBBLE_IMG];
    [view addSubview:imageView];
    
    CGSize maximumLabelSize = CGSizeMake(320, MAXFLOAT);
    CGSize labSize = [text sizeWithFont:[UIFont systemFontOfSize:13.0f]
                      constrainedToSize:maximumLabelSize
                          lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(right - labSize.width - 4,
                                                               btnFrame.origin.y - 30,
                                                               labSize.width + 4,
                                                               21)];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTag:TAG_ATTENTION_BUBBLE_LAB];
    [label setBackgroundColor:UIColorFromRGB(0xbb2228, 1.0f)];
    [label setTextColor:[UIColor whiteColor]];
    label.layer.cornerRadius = 5.0;
    [view addSubview:label];
    [view bringSubviewToFront:label];
    [[view superview] bringSubviewToFront:view];//保证气泡提醒在最前面
}

// 移出气泡提示
+ (void)removeBubble:(UIView *)view
{
    UIButton *cancleBtn = (UIButton *)[view viewWithTag:TAG_ATTENTION_BUBBLE_BTN];
    if (cancleBtn != nil)
    {
        [cancleBtn setHidden:YES];
        [cancleBtn removeFromSuperview];
    }
    
    UIImageView *imageView = (UIImageView *)[view viewWithTag:TAG_ATTENTION_BUBBLE_IMG];
    if (imageView != nil)
    {
        [imageView setHidden:YES];
        [imageView removeFromSuperview];
    }
    
    UILabel *label = (UILabel *)[view viewWithTag:TAG_ATTENTION_BUBBLE_LAB];
    if (label != nil)
    {
        [label setHidden:YES];
        [label removeFromSuperview];
    }
}
@end
