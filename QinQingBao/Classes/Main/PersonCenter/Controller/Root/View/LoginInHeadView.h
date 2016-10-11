//
//  LoginInHeadView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RefreshViewStateNormal,
    RefreshViewStateWillRefresh,
    RefreshViewStateRefreshing,
} RefreshViewState;

@protocol HeadRefleshDelegate <NSObject>

- (void)refleshWithStates:(RefreshViewState)states;
@end



@interface LoginInHeadView : UIView

/**
 *  是否是用户资料界面
 *  用户资料界面显示关注和私信按钮，个人中心不显示
 */
//@property (nonatomic, assign) BOOL isUserata;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIButton *followBtn;

@property (strong, nonatomic) IBOutlet UIButton *letterBtn;

@property (strong, nonatomic) IBOutlet UILabel *professionLab;

@property (strong, nonatomic) IBOutlet UIImageView *refleshBtn;

- (IBAction)letterHandler:(id)sender;

- (IBAction)followHandler:(id)sender;

- (IBAction)loginHandler:(id)sender;

/**
 *  用户点击个人资料
 */
@property (nonatomic, copy) void (^inforClick)(void);

/**
 *  用户点击私信和关注
 */
@property (nonatomic, copy) void (^navbtnClick)(NSInteger tag);

/**
 *
 *
 *  @param name         名字
 *  @param professional 职称
 *  @param isfriend 是否已经关注
 *  @param is_mine 是否是自己
 */
-(void)initWithName:(NSString *)name professional:(NSString *)professional isfriend:(NSString *)isfriend is_mine:(NSString *)is_mine;

@property (nonatomic, assign) id <HeadRefleshDelegate>delegate;

@property (nonatomic, assign) RefreshViewState states;
- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y scrollView:(UIScrollView*)scrollView;
@end
