//
//  EvaluationModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>


//"wid": "90010",           工单id
//"oldname": "曹阿乔",      评论人姓名
//"dis_con": "还行",        评论内容
//"wpjtime": null,          评论时间
//"wgrade": "4"             分数
@interface EvaluationModel : NSObject

/**工单id**/
@property (nonatomic, copy) NSString *wid;
/**评论人姓名 **/
@property (nonatomic, copy) NSString *member_name;
/**评论内容**/
@property (nonatomic, copy) NSString *dis_con;
/**评论时间**/
@property (nonatomic, copy) NSString *wpjtime;
/**分数**/
@property (nonatomic, copy) NSString *wgrade;
@end
