//
//  ServiceHeadCell.m
//  QinQingBao
//
//  Created by shi on 16/5/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ServiceHeadCell.h"
#import "OrderModel.h"

@interface ServiceHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *serviceImgView;   //图片view

@property (weak, nonatomic) IBOutlet UILabel *titleLb;              //标题UILabel

@property (weak, nonatomic) IBOutlet UILabel *memPriceLb;           //会员价UILabel

@property (weak, nonatomic) IBOutlet UILabel *priceLb;              //原价价UILabel

@end

@implementation ServiceHeadCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *serviceHeadCellId = @"serviceHeadCell";
    ServiceHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceHeadCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceHeadCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataWithOrderModel:(OrderModel *)aModel
{
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,aModel.item_url]];
    [self.serviceImgView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.titleLb.text = aModel.icontent;
    self.memPriceLb.text = [NSString stringWithFormat:@"%@元",aModel.wprice];
    
    NSString *priceStr = @"非会员:";
    aModel.price = [NSString stringWithFormat:@"%.02f",[aModel.price floatValue]];
    if (aModel.price) {
        priceStr = [priceStr stringByAppendingFormat:@"%@元",aModel.price];
    }
    
    NSDictionary *attrDic =@{
                             NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:priceStr attributes:attrDic];
    self.priceLb.attributedText = attrStr;
    
}


@end
