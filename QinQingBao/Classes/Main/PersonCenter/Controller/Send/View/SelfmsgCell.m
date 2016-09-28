//
//  SelfmsgCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SelfmsgCell.h"

#define textMaxWidth MTScreenW*0.6

// 文本内容上下左右边距
#define textPadding 10


@interface SelfmsgCell ()
{
    CALayer      *_contentLayer;
    CAShapeLayer *_maskLayer;
}
@end

@implementation SelfmsgCell

+ (SelfmsgCell*) selfmsgCell
{
    SelfmsgCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SelfmsgCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = HMGlobalBg;
    return cell;
}


-(void)initWithContent:(NSString *)content icon:(NSString *)icon
{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 头像
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(MTScreenW  -50, 5, 40, 40)];
    [headImg sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"head"]];
    [self addSubview:headImg];
    
    // 文本
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, 100, 40)];
    NSString *str = content.length > 0?content:@"";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    
    textView.userInteractionEnabled  = NO;
    textView.textColor = [UIColor colorWithRGB:@"666666"];
    textView.backgroundColor = [UIColor clearColor];
    
    // 如果宽度大于60%的屏幕就需要换行
    CGSize size = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    
    if (size.width > textMaxWidth)
    {
        CGRect tmpRect = [textView.text boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        textView.frame = CGRectMake(MTScreenW - CGRectGetWidth(headImg.frame) - 30 - textMaxWidth, 8, textMaxWidth + textPadding, tmpRect.size.height + textPadding + 5);
    }
    else
    {
        textView.frame = CGRectMake(MTScreenW - CGRectGetWidth(headImg.frame) - 30 - size.width, 8, size.width + textPadding, 33);
    }
    [self addSubview:textView];
    
    // 文本背景颜色
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(textView.x - 10, textView.y, textView.width + 20, textView.height + 10)];
//    bgView.image = [UIImage imageWithColor:[UIColor orangeColor]];
    
    bgView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];

    bgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bgView.layer.borderWidth  = 0.0f;
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self insertSubview:bgView belowSubview:textView];
    
    self.height = CGRectGetMaxY(bgView.frame) + 5;
}

- (void)awakeFromNib
{
    //    bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
}

- (void)setup
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
