//
//  DietaryHabit.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DietaryHabit.h"
#import "SSCheckBoxView.h"

#define KCellHight 25
#define KMargin 5

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
@property (strong, nonatomic)  SSCheckBoxView *cb9;


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
    [_cb1 setText:@"荤素均衡"];
    [_cb1 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb1.frame), 320, 0.5)];
    line.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line];
    
    _cb2 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb1.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb2 setText:@"清淡"];
    [_cb2 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb2];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb2.frame), 320, 0.5)];
    line1.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line1];
    
    _cb3 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb2.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb3 setText:@"素食"];
    [_cb3 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb3];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb3.frame), 320, 0.5)];
    line2.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line2];
    
    _cb4 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb3.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb4 setText:@"碳酸饮料"];
    [_cb4 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb4];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb4.frame), 320, 0.5)];
    line3.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line3];
    
    _cb5 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb4.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb5 setText:@"嗜甜"];
    [_cb5 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb5];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb5.frame), 320, 0.5)];
    line4.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line4];
    
    _cb6 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb5.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb6 setText:@"重口味"];
    [_cb6 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb6];
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb6.frame), 320, 0.5)];
    line5.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line5];
    
    _cb7 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb6.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb7 setText:@"爱喝茶"];
    [_cb7 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb7];
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb7.frame), 320, 0.5)];
    line6.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line6];
    
    _cb8 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb7.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb8 setText:@"嗜咖啡"];
    [_cb8 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb8];
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cb8.frame), 320, 0.5)];
    line7.backgroundColor = [UIColor colorWithRGB:@"EBEBEB"];
    [self.contentBoxView addSubview:line7];
    
    _cb9 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cb8.frame) + KMargin,100, KCellHight) style:5 checked:NO];
    [_cb9 setText:@"偏肉食"];
    [_cb9 setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            [weakSelf.selectedItems addObject:cbv.textLabel.text];
        }else{
            [weakSelf.selectedItems removeObject:cbv.textLabel.text];
        }
    }];
    [self.contentBoxView addSubview:_cb9];

}

- (void)setValueArray:(NSArray *)valueArray
{
    for (NSString *value in valueArray) {
        
        if ([value isEqualToString:@"荤素均衡"]) {
            _cb1.checked = YES;
        }
        
        if ([value isEqualToString:@"清淡"]) {
            _cb2.checked = YES;
        }
        
        if ([value isEqualToString:@"素食"]) {
            _cb3.checked = YES;
        }
        
        if ([value isEqualToString:@"碳酸饮料"]) {
            _cb4.checked = YES;
        }
        
        if ([value isEqualToString:@"嗜甜"]) {
            _cb5.checked = YES;
        }
        
        if ([value isEqualToString:@"重口味"]) {
            _cb6.checked = YES;
        }
        
        if ([value isEqualToString:@"爱喝茶"]) {
            _cb7.checked = YES;
        }
        
        if ([value isEqualToString:@"嗜咖啡"]) {
            _cb8.checked = YES;
        }
        
        if ([value isEqualToString:@"偏肉食"]) {
            _cb9.checked = YES;
        }
    }
    
    [self.selectedItems addObjectsFromArray:valueArray];
    [self.selectedItems removeObject:@""];
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
