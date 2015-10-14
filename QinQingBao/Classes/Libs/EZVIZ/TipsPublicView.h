//
//  TipsPublicView.h
//  VideoGo
//
//  Created by yudan on 14-4-4.
//
//

#import <UIKit/UIKit.h>

@interface TipsPublicView : UIView
{
    UILabel         *_tipsLab;
    UIButton        *_backBtn;
    UIButton        *_menuBtn;
    UIView          *_bottomView;
    
    UIImageView     *_bgImgView;
}

@property (nonatomic, strong) UILabel * tipsLab;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * menuBtn;
@property (nonatomic, strong) UIImageView * bgImgView;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, copy) NSString * strTitle;



/**
 *  初始化
 *
 *  @param frame    frame
 *  @param strTitle 标题文字
 *
 *  @return self  
 */
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)strTitle;

/**
 *  显示menu按钮
 */
- (void)showMenuBtn;

/**
 *  隐藏menu按钮
 */
- (void)hideMenuBtn;

/**
 *  增加返回按钮点击触发时间
 *
 *  @param action 事件响应函数
 */
- (void)addBackBtnTouchEvent:(id)target action:(SEL)action;

/**
 *  增加菜单按钮响应时间
 *
 *  @param action       事件响应函数
 *  @param controlEvent 响应事件类型
 */
- (void)addMenuBtnTouchEvent:(id)target action:(SEL)action andEvent:(UIControlEvents)controlEvent;


@end
