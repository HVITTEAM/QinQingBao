//
//  GroupbuyMode.h
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupbuyMode : NSObject

@property(copy,nonatomic)NSString *groupbuy_id;                //团购ID
@property(copy,nonatomic)NSString *groupbuy_name;              //活动名称
@property(copy,nonatomic)NSString *start_time;                 //开始时间
@property(copy,nonatomic)NSString *end_time;                   //结束时间
@property(copy,nonatomic)NSString *goods_id;                   //商品ID
@property(copy,nonatomic)NSString *goods_commonid;             //商品公共表ID
@property(copy,nonatomic)NSString *goods_name;                 //商品名称
@property(copy,nonatomic)NSString *store_id;                   //店铺ID
@property(copy,nonatomic)NSString *store_name;                 //店铺名称
@property(copy,nonatomic)NSString *goods_price;                //商品原价
@property(copy,nonatomic)NSString *groupbuy_price;             //团购价格
@property(copy,nonatomic)NSString *groupbuy_rebate;            //折扣
@property(copy,nonatomic)NSString *virtual_quantity;           //虚拟购买数量
@property(copy,nonatomic)NSString *upper_limit;                //购买上限
@property(copy,nonatomic)NSString *buyer_count;                //已购买人数
@property(copy,nonatomic)NSString *buy_quantity;               //购买数量
@property(copy,nonatomic)NSString *state;          //团购状态 10-审核中 20-正常 30-审核失败 31-管理员关闭 32-已结束
@property(copy,nonatomic)NSString *recommended;                //是否推荐 0.未推荐 1.已推荐
@property(copy,nonatomic)NSString *views;                      //查看次数
@property(copy,nonatomic)NSString *class_id;                   //团购类别编号
@property(copy,nonatomic)NSString *s_class_id;                 //团购2级分类id
@property(copy,nonatomic)NSString *groupbuy_image;             //团购图片
@property(copy,nonatomic)NSString *groupbuy_image1;            //团购图片1  缩略图 小图
@property(copy,nonatomic)NSString *remark;                     //备注
@property(copy,nonatomic)NSString *is_vr;                      //是否虚拟团购 1是0否
@property(copy,nonatomic)NSString *vr_city_id;                 //虚拟团购城市id
@property(copy,nonatomic)NSString *vr_area_id;                 //虚拟团购区域id
@property(copy,nonatomic)NSString *vr_mall_id;                 //虚拟团购大分类id
@property(copy,nonatomic)NSString *vr_class_id;                //虚拟团购小分类id
@property(copy,nonatomic)NSString *vr_s_class_id;
@property(copy,nonatomic)NSString *start_time_text;
@property(copy,nonatomic)NSString *end_time_text;
@property(copy,nonatomic)NSString *groupbuy_state_text;
@property(copy,nonatomic)NSString *reviewable;
@property(copy,nonatomic)NSString *cancelable;
@property(copy,nonatomic)NSString *state_flag;
@property(copy,nonatomic)NSString *button_text;
@property(copy,nonatomic)NSString *count_down_text;
@property(copy,nonatomic)NSString *count_down;

@end

