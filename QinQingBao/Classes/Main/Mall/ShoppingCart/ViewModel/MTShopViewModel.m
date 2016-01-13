//
//  MTShopViewModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTShopViewModel.h"
#import "MTShoppIngCarModel.h"
#import "MJExtension.h"
#import "MTCommodityModel.h"


#import "ShopCarModelTotal.h"

#import "ShopCarModel.h"

@implementation MTShopViewModel


- (void)getNumPrices:(void (^)()) priceBlock
{
    _priceBlock = priceBlock;
}

- (void)getShopData:(void (^)(NSArray * commonArry))shopDataBlock  priceBlock:(void (^)()) priceBlock
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return [MTNotificationCenter postNotificationName:MTLoginTimeout object:nil userInfo:nil];
    [CommonRemoteHelper RemoteWithUrl:URL_Cart_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                  @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     
                                     ShopCarModelTotal *result = [ShopCarModelTotal objectWithKeyValues:dict1];
                                     
                                     self.cart_list = result.cart_list;
                                     //                                     self.carDataArrList = result.cart_list;
                                     //                                     [self.tableView reloadData];
                                     //                                     if (result.cart_list.count == 0)
                                     //                                     {
                                     //                                         [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
                                     //                                     }
                                     
//                                     if (self.cart_list.count == 0)
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:MTNoGoodsInCarNotification object:nil];
                                     
                                     NSMutableArray *commonMuList = [NSMutableArray array];
                                     
                                     for (ShopCarModel  *item in self.cart_list)
                                     {
                                         MTCommodityModel *item_info =  [[MTCommodityModel alloc] init];
                                         item_info.full_name = item.goods_name;
                                         item_info.icon = item.goods_image_url;
                                         item_info.sale_price = item.goods_price;
                                         item_info.item_state = @"1";
                                         item_info.stock_quantity = @"99";
                                         
                                         MTShoppIngCarModel *goodsModel = [[MTShoppIngCarModel alloc] init];
                                         goodsModel.item_info = item_info;
                                         goodsModel.count = item.goods_num;
                                         goodsModel.item_id = item.cart_id;
                                         goodsModel.goods_id = item.goods_id;
                                         goodsModel.item_size = @"SINGLE";
                                         goodsModel.type = 1;
                                         goodsModel.vm = self;
                                         goodsModel.isSelect=NO;
                                         [commonMuList addObject:goodsModel];
                                     }
                                     
                                     if (commonMuList.count>0)
                                         [commonMuList addObject:[self verificationSelect:commonMuList type:@"1"]];
                                     _priceBlock = priceBlock;
                                     shopDataBlock(commonMuList);
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
    
    return;
    
    //访问网络 获取数据 block回调失败或者成功 都可以在这处理
    
    //本demo 直接读 本地数据了
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSMutableDictionary *strategyDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    NSArray *commonList = [strategyDic objectForKey:@"common"];
    
    NSMutableArray *commonMuList = [NSMutableArray array];
    
    
    for (int i = 0; i< commonList.count; i++) {
        MTShoppIngCarModel *model = [MTShoppIngCarModel objectWithKeyValues:[commonList objectAtIndex:i]];
        model.vm =self;
        model.type=1;
        model.isSelect=YES;
        [commonMuList addObject:model];
        
    }
    if (commonMuList.count>0) {
        
        [commonMuList addObject:[self verificationSelect:commonMuList type:@"1"]];
        
    }
    
    _priceBlock = priceBlock;
    shopDataBlock(commonMuList);
}
- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"YES" forKey:@"checked"];
    [dic setObject:type forKey:@"type"];
    for (int i =0; i<arr.count; i++) {
        MTShoppIngCarModel *model = (MTShoppIngCarModel *)[arr objectAtIndex:i];
        if (!model.isSelect) {
            [dic setObject:@"NO" forKey:@"checked"];
            break;
        }
    }
    
    return dic;
}


- (void)pitchOn:(NSMutableArray *)carDataArrList
{
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        [dic setObject:@"YES" forKey:@"checked"];
        for (int j=0; j<dataList.count-1; j++) {
            MTShoppIngCarModel *model = (MTShoppIngCarModel *)[dataList objectAtIndex:j];
            if (model.type==1 ) {
                if (!model.isSelect && ![model.item_info.sale_state isEqualToString:@"3"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
            }
            else if(model.type==2 )
            {
                if (!model.isSelect &&![model.item_info.sale_state isEqualToString:@"3"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
            }
        }
    }
}


-(void)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt
{
    bt.selected = !bt.selected;
    
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        for (int j=0; j<dataList.count-1; j++) {
            MTShoppIngCarModel *model = (MTShoppIngCarModel *)[dataList objectAtIndex:j];
            if (model.type==1 && bt.tag==100) {
                if (bt.selected) {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                }
                
            }
            else if(model.type==2 &&bt.tag==101)
            {
                if (bt.selected) {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                }
            }
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"开始计算价钱");
    if ([keyPath isEqualToString:@"isSelect"]) {
        if (_priceBlock!=nil) {
            _priceBlock();
        }
    }
}



@end
