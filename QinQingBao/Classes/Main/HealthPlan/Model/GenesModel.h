//
//  GenesModel.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenesModel : NSObject

/**非基因检测数组 */
@property(nonatomic,copy)NSArray *ea_score_start;

/**基因检查数组 */
@property(nonatomic,copy)NSString *ea_gene_content;

/**1表示非基因检测数组【取值ea_score_start】，2和3表示基因检查数组【取值ea_gene_content】 */
@property(nonatomic,copy)NSString *entry_target_type;

/**名称 */
@property(nonatomic,copy)NSString *ycjd_name;

/**参考值 */
@property(nonatomic,copy)NSString *entry_standardscore;

/**英文标识 */
@property(nonatomic,copy)NSString *entry_name_en;

/**分值：如果entry_target_type=1，则当前参数为数字；如果entry_target_type=2或者3 则当前参数为字符串 */
@property(nonatomic,copy)NSString *ycjd_score;

/**分值对应的危险系数 */
@property(nonatomic,copy)NSString *ycjd_level;

@property(nonatomic,copy)NSString *level_flag;

/**当前指标的描述 */
@property(nonatomic,copy)NSString *ycjd_detail;

/**指标ID */
@property(nonatomic,copy)NSString *ycjd_entry_id;
@end
