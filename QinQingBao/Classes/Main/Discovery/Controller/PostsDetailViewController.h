//
//  PostsDetailViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsModel.h"

@interface PostsDetailViewController : UIViewController

@property (nonatomic, retain) PostsModel *itemdata;

@property (strong, nonatomic) void(^deletePostsSuccessBlock)(void);

@end
