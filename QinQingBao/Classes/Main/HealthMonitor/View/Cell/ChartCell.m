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
        [self addScrollChart];
    }
    return self;
}


-(void)addScrollChart
{
    //创建表格对象
    UULineChart *scrollChart = [[UULineChart alloc] initWithFrame:CGRectMake(10, 10, MTScreenW-20, 150)];
    [self.contentView addSubview:scrollChart];
    
    //设置表格的曲线颜色
    scrollChart.colors = @[UUGreen,UURed,UUBrown];
    //设置表格数值标注范围
    scrollChart.markRange =  CGRangeMake(55, 27);
    //Y轴值范围
    scrollChart.chooseRange = CGRangeMake(110, 0);
    scrollChart.showRange = NO;
    
    //模拟的两条曲线
    NSArray*arr1 = @[@"20",@"44",@"15",@"40",@"42",@"42",@"77",@"43",@"30",@"89",@"20",@"55",@"52",@"42",@"47",@"70"];
    NSArray*arr2 = @[@"30",@"89",@"20",@"15",@"18",@"25",@"55",@"52",@"42",@"77",@"43",@"89",@"20",@"55",@"42",@"77"];
    [scrollChart setYValues:@[arr1,arr2]];
    
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
    for (int i=0; i<16; i++) {
        NSString *str = [NSString stringWithFormat:@"R-%d",i];
        [xTitles addObject:str];
    }
    [scrollChart setXLabels:xTitles];
    
    [scrollChart setYValues:@[arr1,arr2]];
    
    //绘制表格
    [scrollChart strokeChart];
}

@end
