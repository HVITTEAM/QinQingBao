//
//  SiglePicCardCell.m
//  QinQingBao
//
//  Created by shi on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SiglePicCardCell.h"

#define kMargin 10
#define kPhotoPadding 10

@interface SiglePicCardCell ()

/** 用户信息模块 */
@property (strong, nonatomic) UIView *userInfoView;

/** 文本内容模块 */
@property (strong, nonatomic) UIView *textInfoView;

/** 照片模块 */
@property (strong, nonatomic) UIView *photosView;

/** 底部工具条模块 */
@property (strong, nonatomic) UIView *bottomBarView;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 头像 */
@property (strong, nonatomic) UIImageView *portraitView;

/** 头像加V */
@property (strong, nonatomic) UIImageView *markView;

/** 时间 */
@property (strong, nonatomic) UILabel *timeLb;

/** 姓名 */
@property (strong, nonatomic) UILabel *nameLb;

/** 用户信息标签 */
@property (strong, nonatomic) UILabel *headTagLb;

/** 关注按钮 */
@property (strong, nonatomic) UIButton *attentionBtn;

/** 文章标题 */
@property (strong, nonatomic) UILabel *titleLb;

/** 文章内容 */
@property (strong, nonatomic) UILabel *contentLb;

/** 照片 */
@property (strong, nonatomic) UIImageView *picImageView;

/** 阅读按钮 */
@property (strong, nonatomic) UIButton *ydBtn;

/** 点赞按钮 */
@property (strong, nonatomic) UIButton *dzBtn;

/** 评论按钮 */
@property (strong, nonatomic) UIButton *plBtn;

/** 底部标签 */
@property (strong, nonatomic) UIButton *barTagBtn;

@property (assign)NSInteger photoNum;

@end

@implementation SiglePicCardCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *siglePicCardCellId = @"siglePicCardCell";
    SiglePicCardCell *cell = [tableView dequeueReusableCellWithIdentifier:siglePicCardCellId];
    if (!cell) {
        cell = [[SiglePicCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:siglePicCardCellId];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUserInfoView];
        [self setupTextInfoView];
        [self setupPhotosView];
        [self setupBottomBarView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = HMColor(235, 235, 235);
        [self.contentView addSubview:self.lineView];
        
        self.separatorInset = UIEdgeInsetsMake(0, MTScreenW, 0, 0.5);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

-(void)setItemdata:(PostsModel *)itemdata
{
    _itemdata = itemdata;

    // 自己发的帖子不显示关注按钮
    if ([SharedAppUtil defaultCommonUtil].bbsVO && [[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id isEqualToString:self.itemdata.authorid])
    {
        itemdata.is_myposts = @"1";
        [self.attentionBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = [UIColor colorWithRGB:@"C69666"].CGColor;
        [self.attentionBtn setTitleColor:[UIColor colorWithRGB:@"C69666"] forState:UIControlStateNormal];
    }
    else if ([itemdata.is_home_friend integerValue] != 0) {  //设置是否关注
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = [UIColor colorWithRGB:@"B3B3B3"].CGColor;
        [self.attentionBtn setTitleColor:[UIColor colorWithRGB:@"B3B3B3"] forState:UIControlStateNormal];
    }else{
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = [UIColor colorWithRGB:@"f7931e"].CGColor;
        [self.attentionBtn setTitleColor:[UIColor colorWithRGB:@"f7931e"] forState:UIControlStateNormal];
    }
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.itemdata.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];

    // 设置是否加V
    self.markView.hidden = itemdata.grouptitle.length>0 ? NO : YES;

    self.timeLb.text = [self.itemdata.dateline substringWithRange:NSMakeRange(5, 11)];
    self.nameLb.text = self.itemdata.author;
    self.headTagLb.text = self.itemdata.grouptitle;
    
    //设置文字内容
    [self setTitle:self.itemdata.subject content:self.itemdata.message];
    
    //设置底部工具栏
    [self.ydBtn setTitle:itemdata.views forState:UIControlStateNormal];
    [self.dzBtn setTitle:itemdata.recommend_add forState:UIControlStateNormal];
    [self.plBtn setTitle:itemdata.replies  forState:UIControlStateNormal];
    
    [self.barTagBtn setTitle:itemdata.forum_name forState:UIControlStateNormal];

    // 设置图片
    self.photoNum = itemdata.attachmentpicture_bigthumb.count;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[itemdata.attachmentpicture_bigthumb firstObject]] placeholderImage:[UIImage imageNamed:@"placeholderDetail"]];
    
    //设置位置
    [self layoutCell];
}

/**
 *  设置标题与内容
 * titleStr:标题 .
 * contentStr:内容 .
 */
- (void)setTitle:(NSString *)titleStr content:(NSString *)contentStr
{
    if (titleStr.length > 0) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 2;
        NSDictionary *attrDict = @{
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                   NSForegroundColorAttributeName:HMColor(54, 54, 54),
                                   NSParagraphStyleAttributeName:paragraph
                                   };
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:attrDict];
        self.titleLb.attributedText = attrStr;
    }else{
        self.titleLb.attributedText = nil;
    }
    
    if (contentStr.length > 0) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 4;
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:HMColor(102, 102, 102),
                                    NSParagraphStyleAttributeName:paragraph
                                    };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:contentStr attributes:attrDict1];
        self.contentLb.attributedText = attrStr;
    }else{
        self.contentLb.attributedText = nil;
    }
}


#pragma mark - 设置cell子视图的位置
/**
 *  设置cell子视图位置
 */
- (void)layoutCell
{
    [self layoutUserInfoView];
    [self layoutPhotosView];
    [self layoutTextInfoView];
    [self layoutBottomBarView];
}

/**
 *  设置用户信息部分的位置
 */
- (void)layoutUserInfoView
{
    self.userInfoView.frame = CGRectMake(kMargin, 12, MTScreenW - 2 * kMargin, 40);
    
    self.portraitView.frame = CGRectMake(0, 2, 36, 36);
    self.portraitView.layer.cornerRadius = self.portraitView.width/2;
    self.portraitView.layer.masksToBounds = YES;

    self.markView.frame = CGRectMake(23, 23, 15, 15);

    [self.nameLb sizeToFit];
    self.nameLb.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame) + 10, 2, CGRectGetWidth(self.nameLb.frame), CGRectGetHeight(self.nameLb.frame));
    
    [self.timeLb sizeToFit];
    self.timeLb.frame = CGRectMake(CGRectGetMinX(self.nameLb.frame), CGRectGetMaxY(self.nameLb.frame) + 7, CGRectGetWidth(self.timeLb.frame), CGRectGetHeight(self.timeLb.frame));
    
    
    if (self.headTagLb.text.length == 0)
    {
        self.headTagLb.frame = CGRectMake(CGRectGetMaxX(self.nameLb.frame) + 10, 2,0, 0);
    }
    else
    {
        [self.headTagLb sizeToFit];
        [self.headTagLb sizeToFit];
        self.headTagLb.frame = CGRectMake(CGRectGetMaxX(self.nameLb.frame) + 10, 2, CGRectGetWidth(self.headTagLb.frame) + 8, CGRectGetHeight(self.headTagLb.frame)+4);
    }
    
    self.attentionBtn.frame = CGRectMake(CGRectGetWidth(self.userInfoView.frame) - 50, 5, 50, 30);
    self.attentionBtn.hidden = YES;
}

/**
 *  设置图片部分的位置
 */
- (void)layoutPhotosView
{
    CGFloat photoWidth = MTScreenW - 2 * kMargin;
    CGFloat photoheight = (int)(photoWidth * 312 / 720 + 0.5);
    
    if (self.photoNum != 0) {
        self.photosView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.userInfoView.frame) + 10,photoWidth, photoheight);
        self.picImageView.hidden = NO;
    }else{
        self.photosView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.userInfoView.frame), photoWidth, 0);
        self.picImageView.hidden = YES;
        self.picImageView.image = nil;
    }
    self.picImageView.frame = self.photosView.bounds;
}

/**
 *  设置文本内容部分的位置
 */
- (void)layoutTextInfoView
{
    CGSize titleSize = [self.titleLb sizeThatFits:CGSizeMake(MTScreenW - 2 * kMargin, MAXFLOAT)];
    self.titleLb.frame = CGRectMake(0, 0, MTScreenW - 2 * kMargin, titleSize.height);
    
    CGSize size = [self.contentLb sizeThatFits:CGSizeMake(MTScreenW - 2 * kMargin, MAXFLOAT)];
    if (self.contentLb.attributedText && self.titleLb.attributedText) {
        self.contentLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame) + 10, size.width, size.height);
    }else if (self.contentLb.attributedText && self.titleLb.attributedText == nil){
        self.contentLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame), size.width, size.height);
    }else{
        self.contentLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame), size.width, 0);
    }
    
    if (self.titleLb.attributedText.length <= 0 && self.contentLb.attributedText.length <= 0) {
        self.textInfoView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.photosView.frame), MTScreenW - 2 * kMargin, 0);
    }else{
        self.textInfoView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.photosView.frame) + 10, MTScreenW - 2 * kMargin, CGRectGetMaxY(self.contentLb.frame));
    }
}

/**
 *  设置底部工具条部分的位置
 */
- (void)layoutBottomBarView
{
    self.bottomBarView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.textInfoView.frame) + 10, MTScreenW - 2 * kMargin, 30);
    
    [self.barTagBtn sizeToFit];
    self.barTagBtn.frame = CGRectMake(0, 2, CGRectGetWidth(self.barTagBtn.frame) + 15, 25);
    
    [self.plBtn sizeToFit];
    self.plBtn.frame = CGRectMake(MTScreenW - 2 * kMargin -(CGRectGetWidth(self.plBtn.frame) + 10), 0, CGRectGetWidth(self.plBtn.frame) + 10, 30);
    
    [self.dzBtn sizeToFit];
    self.dzBtn.frame = CGRectMake(CGRectGetMinX(self.plBtn.frame) - 10 - (CGRectGetWidth(self.dzBtn.frame) + 10), 0, CGRectGetWidth(self.dzBtn.frame) + 10, 30);
    
    [self.ydBtn sizeToFit];
    self.ydBtn.frame = CGRectMake(CGRectGetMinX(self.dzBtn.frame) - 10 - (CGRectGetWidth(self.ydBtn.frame) + 10), 0, CGRectGetWidth(self.ydBtn.frame) + 10, 30);
    
    self.height = CGRectGetMaxY(self.bottomBarView.frame) + 10;

}

#pragma mark - 创建cell子视图
/**
 *  创建用户信息部分的视图
 */
- (void)setupUserInfoView
{
    UIView *infoView = [[UIView alloc] init];
    [self.contentView addSubview:infoView];
    self.userInfoView = infoView;
    
    //头像
    UIImageView *portraitView = [[UIImageView alloc] init];
    portraitView.backgroundColor = HMColor(230, 230, 230);
    self.portraitView = portraitView;
    [infoView addSubview:portraitView];
    self.portraitView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.portraitView addGestureRecognizer:singleTap];

    //加v
    UIImageView *markView = [[UIImageView alloc] init];
    markView.image = [UIImage imageNamed:@"v.png"];
    self.markView = markView;
    [infoView addSubview:markView];
    
    //姓名
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.textColor = HMColor(53, 53, 53);
    nameLb.font = [UIFont systemFontOfSize:14];
    [infoView addSubview:nameLb];
    self.nameLb = nameLb;
    
    //时间
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.textColor = HMColor(153, 153, 153);
    timeLb.font = [UIFont systemFontOfSize:10];
    [infoView addSubview:timeLb];
    self.timeLb = timeLb;
    
    //标签
    UILabel *headTagLb = [[UILabel alloc] init];
    headTagLb.textAlignment = NSTextAlignmentCenter;
    headTagLb.font = [UIFont systemFontOfSize:10];
    headTagLb.textColor = [UIColor whiteColor];
    headTagLb.backgroundColor = HMColor(148, 191, 54);
    headTagLb.layer.cornerRadius = 4;
    headTagLb.layer.masksToBounds = YES;
    [infoView addSubview:headTagLb];
    self.headTagLb = headTagLb;
    
    //关注
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionBtn.backgroundColor = [UIColor whiteColor];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    attentionBtn.layer.cornerRadius = 5;
    [attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    attentionBtn.layer.borderWidth = 1.0f;
    attentionBtn.layer.borderColor = HMColor(247, 147, 30).CGColor;
    [attentionBtn setTitleColor:HMColor(247, 147, 30) forState:UIControlStateNormal];
    [infoView addSubview:attentionBtn];
    self.attentionBtn = attentionBtn;
}

/**
 *  创建文本内容部分的视图
 */
- (void)setupTextInfoView
{
    UIView *textInfoView = [[UIView alloc] init];
    [self.contentView addSubview:textInfoView];
    self.textInfoView = textInfoView;
//    textInfoView.backgroundColor = [UIColor redColor];
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.numberOfLines = 0;
    [textInfoView addSubview:titleLb];
    self.titleLb = titleLb;
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.numberOfLines = 0;
    [textInfoView addSubview:contentLb];
    self.contentLb = contentLb;
}

/**
 *  创建图片部分的视图
 */
- (void)setupPhotosView
{
    UIView *photosView = [[UIView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
//    photosView.backgroundColor = [UIColor brownColor];
    
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.backgroundColor = HMColor(230, 230, 230);
    [self.photosView addSubview:imgV];
    self.picImageView = imgV;
}

/**
 *  创建底部工具条部分的视图
 */
- (void)setupBottomBarView
{
    UIView *bottomBarView = [[UIView alloc] init];
    [self.contentView addSubview:bottomBarView];
    self.bottomBarView = bottomBarView;
//    bottomBarView.backgroundColor = [UIColor brownColor];
    
    self.ydBtn = [self createBtnWithTitle:@"阅读" image:@"yd_icon"];
    self.dzBtn = [self createBtnWithTitle:@"点赞" image:@"dz_icon"];
    self.plBtn = [self createBtnWithTitle:@"评论" image:@"pl_icon"];
    
    self.barTagBtn = [self createBtnWithTitle:@"健康专题" image:@"qz_icon"];
    [self.barTagBtn setTitleColor:HMColor(98, 50, 02) forState:UIControlStateNormal];
    self.barTagBtn.backgroundColor = HMColor(251, 248, 245);
    self.barTagBtn.layer.cornerRadius = 5;
    self.barTagBtn.layer.borderColor = HMColor(240, 234, 229).CGColor;
    self.barTagBtn.layer.borderWidth = 0.5f;
}

- (UIButton *)createBtnWithTitle:(NSString *)title image:(NSString *)imageName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.enabled = NO;
    [btn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.bottomBarView addSubview:btn];
    return btn;
}

// 个人头像点击事件
-(void)onClickImage
{
    if(self.portraitClick)
        self.portraitClick(self.itemdata);
}

@end
