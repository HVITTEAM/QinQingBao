//
//  DietaryHabit.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BadHabit.h"
#import "SSCheckBoxView.h"

#define KCellHight 25
#define KMargin 5

@interface BadHabit()
{
    
}
@property (strong, nonatomic) IBOutlet UIView *contentBoxView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic)  SSCheckBoxView *cb1;
@property (strong, nonatomic)  SSCheckBoxView *cb2;
@property (strong, nonatomic)  SSCheckBoxView *cb3;
@property (strong, nonatomic)  SSCheckBoxView *cb4;

@property (strong, nonatomic) NSMutableArray *selectedItems;


@end
@implementation BadHabit

#pragma mark - 周期方法
/**
 *  创建一个SMSVerificationView并显示到指定view上
 */
+(BadHabit *)showTargetViewToView:(UIView *)targetView
{
    BadHabit *smsView = [[[NSBundle mainBundle] loadNibNamed:@"BadHabit" owner:nil options:nil] lastObject];
    
    smsView.frame = targetView.bounds;
    [targetView addSubview:smsView];
    smsView.contentBoxView.layer.masksToBounds = YES;
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
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    lab.text = @"请选择（可多选）";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor  = [UIColor colorWithRGB:@"94bF36"];
    [self.contentBoxView addSubview:lab];
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), 320, 0.5)];
    line0.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line0];
    
    _cb1 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, 50,100, KCellHight) style:5 checked:NO];
    [_cb1 setText:@"无"];
    [_cb1 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        [weakSelf selectStatusChangeWithCurrentItem:cbv];
    }];
    [self.contentBoxView addSubview:_cb1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb1.frame), 320, 0.5)];
    line.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line];
    
    _cb2 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb1.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb2 setText:@"久坐"];
    [_cb2 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        [weakSelf selectStatusChangeWithCurrentItem:cbv];
    }];
    [self.contentBoxView addSubview:_cb2];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb2.frame), 320, 0.5)];
    line1.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line1];
    
    _cb3 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb2.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb3 setText:@"经常熬夜"];
    [_cb3 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        [weakSelf selectStatusChangeWithCurrentItem:cbv];
    }];
    [self.contentBoxView addSubview:_cb3];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb3.frame), 320, 0.5)];
    line2.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line2];
    
    _cb4 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb3.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb4 setText:@"常看手机"];
    [_cb4 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        [weakSelf selectStatusChangeWithCurrentItem:cbv];
    }];
    [self.contentBoxView addSubview:_cb4];
}

- (void)setValueArray:(NSArray *)valueArray
{
    for (NSString *value in valueArray) {
        
        if ([value isEqualToString:@"无"]) {
            _cb1.checked = YES;
        }
        
        if ([value isEqualToString:@"久坐"]) {
            _cb2.checked = YES;
        }
        
        if ([value isEqualToString:@"经常熬夜"]) {
            _cb3.checked = YES;
        }
        
        if ([value isEqualToString:@"常看手机"]) {
            _cb4.checked = YES;
        }
  
    }
    
    [self.selectedItems addObjectsFromArray:valueArray];
    [self.selectedItems removeObject:@""];
    [self.selectedItems removeObject:@"(null)"];
    
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

- (void)selectStatusChangeWithCurrentItem:(SSCheckBoxView *)cbv
{
    if (cbv == _cb1 && _cb1.checked) {
        _cb2.checked = NO;
        _cb3.checked = NO;
        _cb4.checked = NO;
        [self.selectedItems removeObject:_cb2.textLabel.text];
        [self.selectedItems removeObject:_cb3.textLabel.text];
        [self.selectedItems removeObject:_cb4.textLabel.text];

    }else if(_cb2.checked || _cb3.checked || _cb4.checked){
        _cb1.checked = NO;
        [self.selectedItems removeObject:_cb1.textLabel.text];
    }
    
    if (cbv.checked) {
        [self.selectedItems addObject:cbv.textLabel.text];
    }else{
        [self.selectedItems removeObject:cbv.textLabel.text];
    }
}

@end
