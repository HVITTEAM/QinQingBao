//
//  NewsDetailViewControler.h
//  QinQingBao
//
//  Created by 董徐维 on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

@interface NewsDetailViewControler : MTProgressWebViewController

@property (nonatomic, retain) ArticleModel *articleItem;
@end
