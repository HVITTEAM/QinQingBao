//
//  ReportDetailModel.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "None_Gene_DetectionModel.h"

@interface ReportDetailModel : NSObject
//基因检测数组  （等位基因）
@property(nonatomic,copy)NSArray *gene_detection;
//多基因检测数组（非等位基因)
@property(nonatomic,copy)NSArray *various_genes;
//非基因检查(非基因类)
@property(nonatomic,strong)None_Gene_DetectionModel *none_gene_detection;
@end
