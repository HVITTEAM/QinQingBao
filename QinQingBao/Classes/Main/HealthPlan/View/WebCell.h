//
//  WebCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/12/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebCell : UITableViewCell
+ (WebCell*) webCell;

@property (nonatomic, copy) NSString *URLStr;

/**
 webview加载完毕回调
 */
@property (nonatomic, copy) void (^loadCompleteBlock)(CGFloat height);

@end
