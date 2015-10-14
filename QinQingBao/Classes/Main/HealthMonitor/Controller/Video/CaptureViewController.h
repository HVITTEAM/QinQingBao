//
//  CaptureViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/14.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"


@interface CaptureViewController : UITableViewController<MWPhotoBrowserDelegate>


@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@end
