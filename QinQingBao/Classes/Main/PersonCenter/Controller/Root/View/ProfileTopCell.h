//
//  ProfileConsumeCell.h
//  QinQingBao
//
//  Created by shi on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTopCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fansLab;
@property (strong, nonatomic) IBOutlet UILabel *attentionLab;
@property (strong, nonatomic) IBOutlet UILabel *zanLab;

@property(copy)void(^tapConsumeCellBtnCallback)(ProfileTopCell *,NSUInteger idx);

+(instancetype)creatProfileConsumeCellWithTableView:(UITableView *)tableVie;


-(void)setZan:(NSInteger )zannum fansnum:(NSInteger)fansnum attentionnum:(NSInteger)attentionnum;
@end
