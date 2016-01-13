//
//  InvoiceInfoCell.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *invoice; //发票

+ (InvoiceInfoCell *)invoiceInfoCell;

@end
