//
//  DietaryHabit.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DietaryHabit.h"
#import "SSCheckBoxView.h"

@interface DietaryHabit()
{
    
}
@property (strong, nonatomic) IBOutlet UIView *contentBoxView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic)  SSCheckBoxView *cb1;
@property (strong, nonatomic)  SSCheckBoxView *cb2;
@property (strong, nonatomic)  SSCheckBoxView *cb3;
@property (strong, nonatomic)  SSCheckBoxView *cb4;
@property (strong, nonatomic)  SSCheckBoxView *cb5;
@property (strong, nonatomic)  SSCheckBoxView *cb6;
@property (strong, nonatomic)  SSCheckBoxView *cb7;
@property (strong, nonatomic)  SSCheckBoxView *cb8;

@property (strong, nonatomic) NSMutableArray *selectedItems;


@end
@implementation DietaryHabit

#pragma mark - 周期方法
/**
 *  创建一个SMSVerificationView并显示到指定view上
 */
+(DietaryHabit *)showTargetViewToView:(UIView *)targetView
{
    DietaryHabit *smsView = [[[NSBundle mainBundle] loadNibNamed:@"DietaryHabit" owner:nil options:nil] lastObject];
    
    smsView.frame = targetView.bounds;
    [targetView addSubview:smsView];
    smsView.contentBoxView.layer.cornerRadius = 8;
    smsView.contentBoxView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    [UIView animateWithDuration:0.3 animations:^{
        smsView.contentBoxView.transform = CGAffineTransformIdentity;
    }];
    return smsView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initview];
}

- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = [[NSMutableArray alloc] init];
    }
    return _selectedItems;
}

-(void)initview{
    
    __weak typeof(self) weakSelf = self;
    
    _cb1 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, 10,100, 40) style:3 checked:NO];
    [_cb1 setText:@"荤素均衡"];
    [_cb1 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb1];
    
    _cb2 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cb1.frame) + 10, 10,70, 40) style:3 checked:NO];
    [_cb2 setText:@"清淡"];
    [_cb2 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb2];

    
    _cb3 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cb2.frame) + 10, 10,70, 40) style:3 checked:NO];
    [_cb3 setText:@"素食"];
    [_cb3 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb3];

    
    _cb4 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, 60,100, 40) style:3 checked:NO];
    [_cb4 setText:@"碳酸饮料"];
    [_cb4 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb4];
    
    _cb5 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cb4.frame) + 10, 60,70, 40) style:3 checked:NO];
    [_cb5 setText:@"嗜甜"];
    [_cb5 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb5];
    
    _cb6 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cb5.frame) + 10, 60,80, 40) style:3 checked:NO];
    [_cb6 setText:@"重口味"];
    [_cb6 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb6];
    
    
    _cb7 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, 110,80, 40) style:3 checked:NO];
    [_cb7 setText:@"爱喝茶"];
    [_cb7 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb7];
    
    
    _cb8 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cb7.frame) + 10, 110,80, 40) style:3 checked:NO];
    [_cb8 setText:@"嗜咖啡"];
    [_cb8 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb8];
}

/**
 *  从指定view上删除
 */
-(void)hideSMSVerificationView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentBoxView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.contentBoxView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    //删除监听键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 事件方法
/**
 *  点击取消按钮
 */
- (IBAction)tapCancleBtnAction:(id)sender
{
    [self hideSMSVerificationView];
}

/**
 *  点击确认按钮
 */
- (IBAction)tapConfirmBtnAction:(id)sender
{
    if (self.selectItemBlock) {
        self.selectItemBlock(self.selectedItems);
    }
    
    [self hideSMSVerificationView];
}



@end
