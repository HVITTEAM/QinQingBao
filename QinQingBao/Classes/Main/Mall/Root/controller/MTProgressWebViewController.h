//
//  MTProgressWebViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"


@interface MTProgressWebViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic, copy) NSString *url;

@end
