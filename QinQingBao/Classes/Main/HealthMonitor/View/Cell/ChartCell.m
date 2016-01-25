//
//  ChartCell.m
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ChartCell.h"
#import "UULineChart.h"
@implementation ChartCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加表格
    }
    return self;
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
    
    [self addScrollChart];
}


-(void)addScrollChart
{
    //创建表格对象
    UULineChart *scrollChart = [[UULineChart alloc] initWithFrame:CGRectMake(10, 10, MTScreenW-20, 150)];
    [self.contentView addSubview:scrollChart];
    
    //设置表格的曲线颜色
    scrollChart.colors = @[UUGreen,UURed,UUBrown];
    //设置表格数值标注范围
    //    scrollChart.markRange =  CGRangeMake(55, 27);
    //Y轴值范围
    scrollChart.chooseRange = CGRangeMake(130, 0);
    scrollChart.showRange = NO;
    
    NSMutableArray *YTitles = [NSMutableArray array];
    
    NSMutableArray *YTitles1 = [NSMutableArray array];
    
    
    switch (self.type) {
        case ChartTypeBlood:
            for (HealthDataModel *item in self.dataProvider) {
                
                if (!item.systolic)
                    item.systolic = @"0";
                
                if (!item.diastolic)
                    item.diastolic = @"0";
                [YTitles addObject:item.systolic];
                [YTitles1 addObject:item.diastolic];
                
                scrollChart.chooseRange = CGRangeMake(200, 0);
            }
            break;
            
        case ChartTypeSugar:
            for (HealthDataModel *item in self.dataProvider) {
                [YTitles addObject:item.bloodglucose];
            }
            break;
            
        case ChartTypeHeart:
            for (HealthDataModel *item in self.dataProvider) {
                [YTitles addObject:item.heartrate_avg];
            }
            break;
        default:
            break;
    }
    [scrollChart setYValues:@[YTitles,YTitles1]];
    
    //设置表格各条曲线是否显示最大最小值,1表示对应的曲线要显示最大最小值
    NSMutableArray *showMaxMinArray = [[NSMutableArray alloc]init];
    for (int i=0; i<scrollChart.yValues.count; i++) {
        [showMaxMinArray addObject:@"1"];
    }
    scrollChart.ShowMaxMinArray = showMaxMinArray;
    
    //设置表格上的横线是否要显示
    NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
    for (int i=0; i<5; i++) {
        [showHorizonArray addObject:@"1"];
    }
    scrollChart.ShowHorizonLine = showHorizonArray;
    
    //设置X轴的显示标识
    NSMutableArray *xTitles = [NSMutableArray array];
    
    NSRange range = NSMakeRange(11, 8);
    for (HealthDataModel *item in self.dataProvider) {
        
        switch (self.type)
        {
            case ChartTypeBlood:
            {
                if (!item.bloodp_time)
                    item.bloodp_time = item.heart_time;
                [xTitles addObject:[item.bloodp_time substringWithRange:range]];
            }
                break;
                
            case ChartTypeSugar:
                [xTitles addObject:[item.boolg_time substringWithRange:range]];
                break;
                
            case ChartTypeHeart:
                [xTitles addObject:[item.heart_time substringWithRange:range]];
                break;
            default:
                break;
        }
    }
    
    [scrollChart setXLabels:xTitles];
    
    [scrollChart setYValues:@[YTitles,YTitles1]];
    
    //绘制表格
    [scrollChart strokeChart];
}

@end
