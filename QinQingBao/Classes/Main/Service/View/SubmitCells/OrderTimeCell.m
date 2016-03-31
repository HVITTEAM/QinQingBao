//
//  OrderTimeCell.m
//  QinQingBao
//
//  Created by shi on 16/3/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

NSString * const kTimekey = @"time";
NSString * const kAmStateKey = @"amState";
NSString * const kPmStateKey = @"pmState";

#import "OrderTimeCell.h"

@interface OrderTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLb;

@property (weak, nonatomic) IBOutlet UIButton *AMBtn;       //上午

@property (weak, nonatomic) IBOutlet UIButton *PMBtn;       //下午

@property (copy,nonatomic) NSString *timeStr;

@end

@implementation OrderTimeCell

- (void)awakeFromNib
{
    self.AMBtn.layer.cornerRadius = 8.0f;
    self.AMBtn.layer.masksToBounds = YES;
    self.AMBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.AMBtn.layer.borderWidth = 0.5;
    [self.AMBtn addTarget:self action:@selector(timeBtntapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.AMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.AMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.AMBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.PMBtn.layer.cornerRadius = 8.0f;
    self.PMBtn.layer.masksToBounds = YES;
    self.PMBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.PMBtn.layer.borderWidth = 0.5;
    [self.PMBtn addTarget:self action:@selector(timeBtntapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.PMBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.PMBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

-(void)setCellData:(NSDictionary *)cellData
{
    _cellData = cellData;
    
    self.dateLb.text = cellData[kTimekey];
    self.AMBtn.selected = [cellData[kAmStateKey] boolValue];
    self.PMBtn.selected = [cellData[kPmStateKey] boolValue];
    
    if (self.AMBtn.selected) {
        self.AMBtn.backgroundColor = HMColor(33, 193, 181);
    }else{
        self.AMBtn.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.PMBtn.selected) {
        self.PMBtn.backgroundColor = HMColor(33, 193, 181);
    }else{
        self.PMBtn.backgroundColor = [UIColor whiteColor];
    }
    
    [self disableBtn];
}

-(void)timeBtntapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender == self.AMBtn) {
        self.PMBtn.selected = NO;
    }else{
        self.AMBtn.selected = NO;
    }
    
    NSMutableDictionary *newCellData = [@{
                                          kTimekey:self.cellData[kTimekey],
                                          kAmStateKey:@(self.AMBtn.selected),
                                          kPmStateKey:@(self.PMBtn.selected)
                                          }mutableCopy];
    
    if (self.selectTimeCallBack) {
        self.selectTimeCallBack(newCellData,self.indexPath);
    }
}

-(void)disableBtn
{
    self.AMBtn.enabled = YES;
    self.PMBtn.enabled = YES;
    
    if (self.indexPath.row == 0) {
        
        NSDate *currentDate = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:currentDate];
        
        components.hour = 10;
        components.minute = 30;
        NSDate *amEndDate = [calendar dateFromComponents:components];
        
        components.hour = 16;
        components.minute = 30;
        NSDate *pmEndDate = [calendar dateFromComponents:components];
        
        if ([currentDate compare:pmEndDate] == NSOrderedDescending) {
            self.AMBtn.enabled = NO;
            self.PMBtn.enabled = NO;
            return;
        }
        
        if ([currentDate compare:amEndDate] == NSOrderedDescending) {
            self.AMBtn.enabled = NO;
        }
    }
    return;
}
@end
