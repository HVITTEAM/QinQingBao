//
//  EditInfoTableViewController.h
//  QinQingBao
//
//  Created by shi on 16/2/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMCommonTextfieldItem;

@interface EditInfoTableViewController : UITableViewController

@property(copy,nonatomic)NSString *placeholderStr;   //文本框的 placeholder 字符串

@property(copy,nonatomic)NSString *titleStr;         //cell 标题

@property(copy,nonatomic)NSString *contentStr;       //文本框中的内容

@property(copy,nonatomic)void(^finishUpdateOperation)(NSString *,NSString *,NSString *);  //完成编辑后的回调block  参数分别为title,content,placeholder

@end