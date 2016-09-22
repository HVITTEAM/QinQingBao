//
//  BBSRelationCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BBSRelationCell.h"

@interface BBSRelationCell ()<UIActionSheetDelegate>

@end

@implementation BBSRelationCell

+(BBSRelationCell *)BBSRelationCell
{
    BBSRelationCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"BBSRelationCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImg.layer.cornerRadius = self.headImg.width/2;
    self.headImg.layer.masksToBounds = YES;
    
    self.groupTitleLab.backgroundColor = [UIColor colorWithRGB:@"70a426"];
    self.groupTitleLab.textColor = [UIColor whiteColor];
    self.groupTitleLab.layer.cornerRadius = 2;
    self.groupTitleLab.layer.masksToBounds = YES;
    
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.btn.layer.borderWidth = 0.5f;
}

-(void)setItem:(BBSRelationModel *)item
{
    _item = item;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.avatar]];
    [self.headImg sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.nameLab.text = item.name;
    self.groupTitleLab.text = [NSString stringWithFormat:@" %@ ",item.grouptitle];
    
    // 如果是我的粉丝
    if (item.fans_id && [item.fans_id integerValue] > 0)
    {
        // 是否我也关注了他
        if([item.is_fans integerValue] == 0)
        {
            [self.btn setTitle:@"+ 关注" forState:UIControlStateNormal];
            [self.btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            self.btn.layer.borderColor = [[UIColor orangeColor] CGColor];
        }
    }
}

- (IBAction)clickHandler:(id)sender
{
    if (self.relationChangeBlock)
    {
        if ([self.btn.titleLabel.text isEqualToString:@"+ 关注"])
            self.relationChangeBlock(self.item.fans_id,1);
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定不再关注此人？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
            [actionSheet showInView:self.window];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if (self.item.fans_id && [self.item.fans_id integerValue] > 0)
            self.relationChangeBlock(self.item.fans_id ,0);
        else
            self.relationChangeBlock(self.item.attention_id ,0);
    }
}

@end
