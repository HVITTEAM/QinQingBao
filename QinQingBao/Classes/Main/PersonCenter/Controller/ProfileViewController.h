//
//  SystemViewController.h
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"


@interface ProfileViewController : HMCommonViewController<UIActionSheetDelegate>
{
    UIImageView * _zoomImageview;
    UIImageView * _circleImageview;
    UIImageView * _iconImageview;
    UIButton * _backBtn;
    UILabel *_label;
}

@end
