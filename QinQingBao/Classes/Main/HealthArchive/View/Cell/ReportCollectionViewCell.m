//
//  ReportCollectionViewCell.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportCollectionViewCell.h"

@implementation ReportCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
    recognizer.numberOfTapsRequired = 2;
}

- (IBAction)deleteImage:(id)sender
{
    if (self.deleteImageBlock) {
        self.deleteImageBlock(self.idxPath);
    }
}

@end
