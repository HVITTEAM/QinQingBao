//
//  CardCell.m
//  QinQingBao
//
//  Created by shi on 16/9/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CardCell.h"
#define kMargin 10
#define kPhotoPadding 10

@interface CardCell ()
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

/** 照片视图数组 */
@property (strong, nonatomic) NSMutableArray *photos;

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

@implementation CardCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cardCellId = @"cardCell";
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellId];
    if (!cell) {
        cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardCellId];
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
    self.lineView.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
}

#pragma mark - 设置cell数据
-(void)setItemdata:(PostsModel *)itemdata
{
    _itemdata = itemdata;
    
    //设置用户信息
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.itemdata.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    self.timeLb.text = self.itemdata.dateline;
    self.nameLb.text = self.itemdata.author;
    self.headTagLb.text = @"超凡大师";

    //设置标题与内容
    NSString *tagName = @"re_icon";;
    [self setTitle:self.itemdata.subject content:self.itemdata.messages titleTag:tagName];
    
    //设置图片
    self.photoNum = self.itemdata.picture.count;
    for (int i = 0; i < self.itemdata.picture.count; i++) {
        UIImageView *img = self.photos[i];
        [img sd_setImageWithURL:[NSURL URLWithString:self.itemdata.picture[i]] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    }

    //设置底部按钮栏
    NSString *yd = itemdata.views && [itemdata.views integerValue] != 0?itemdata.views:@"阅读";
    [self.ydBtn setTitle:yd forState:UIControlStateNormal];
    
    NSString *dz = itemdata.views && [itemdata.replies integerValue] != 0?itemdata.replies:@"点赞";
    [self.dzBtn setTitle:dz forState:UIControlStateNormal];
    
    NSString *pl = itemdata.views && [itemdata.recommend_add integerValue] != 0?itemdata.recommend_add:@"评论";
    [self.plBtn setTitle:pl forState:UIControlStateNormal];
    
    [self.barTagBtn setTitle:@"健康专题" forState:UIControlStateNormal];
    
    [self layoutCell];
}

-(void)setSectionListPosts:(SectionListPosts *)sectionListPosts
{
    _sectionListPosts = sectionListPosts;
    
    //设置用户信息
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:sectionListPosts.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    self.timeLb.text = sectionListPosts.dateline;
    self.nameLb.text = sectionListPosts.author;
    self.headTagLb.text = @"超凡大师";
    
    //设置标题与内容
    NSString *tagName = nil;
    if (sectionListPosts.is_hot) {
        tagName = @"re_icon";
    }else if (self.sectionListPosts.is_digest){
        tagName = @"jing_icon";
    }

    [self setTitle:sectionListPosts.subjects content:sectionListPosts.messages titleTag:tagName];
    
    //设置图片
    //...............临时这样做..........
    if ([sectionListPosts.attachmentpicture isKindOfClass:[NSString class]]) {
        self.photoNum = 0;
    }else{
        self.photoNum = sectionListPosts.attachmentpicture.count;
    }
    
    for (int i = 0; i < self.photoNum; i++) {
        UIImageView *img = self.photos[i];
        [img sd_setImageWithURL:[NSURL URLWithString:sectionListPosts.attachmentpicture[i]] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    }
    
    //设置底部按钮栏
    NSString *yd = sectionListPosts.views && [sectionListPosts.views integerValue] != 0?sectionListPosts.views:@"阅读";
    [self.ydBtn setTitle:yd forState:UIControlStateNormal];
    
    NSString *dz = sectionListPosts.views && [sectionListPosts.replies integerValue] != 0?sectionListPosts.replies:@"点赞";
    [self.dzBtn setTitle:dz forState:UIControlStateNormal];
    
    NSString *pl = sectionListPosts.views && [sectionListPosts.recommend_add integerValue] != 0?sectionListPosts.recommend_add:@"评论";
    [self.plBtn setTitle:pl forState:UIControlStateNormal];
    
    [self.barTagBtn setTitle:sectionListPosts.forum_name forState:UIControlStateNormal];
    
    [self layoutCell];
}

/**
 *  设置标题与内容 
 * titleStr:标题 .
 * contentStr:内容 .
 * imageName:标题的小标志,没有传nil
 */
- (void)setTitle:(NSString *)titleStr content:(NSString *)contentStr titleTag:(NSString *)imageName
{
    if (titleStr) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 5;
        NSDictionary *attrDict = @{
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                   NSForegroundColorAttributeName:HMColor(54, 54, 54),
                                   NSParagraphStyleAttributeName:paragraph
                                   };
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",titleStr] attributes:attrDict];
        
        if (imageName) {
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:imageName];
            attachment.bounds = CGRectMake(0, -3, 18, 17);
            
            NSAttributedString *hotIcon = [NSAttributedString attributedStringWithAttachment:attachment];
            [attrStr insertAttributedString:hotIcon atIndex:0];
//            [attrStr setAttributes:attrDict range:NSMakeRange(1, attrStr.length - 1)];
        }
        
        self.titleLb.attributedText = attrStr;
    }
    
    if (contentStr) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 4;
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:HMColor(102, 102, 102),
                                    NSParagraphStyleAttributeName:paragraph
                                    };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:contentStr attributes:attrDict1];
        self.contentLb.attributedText = attrStr;
    }
}

#pragma mark - 设置cell子视图的位置
/**
 *  设置cell子视图位置
 */
- (void)layoutCell
{
    [self layoutUserInfoView];
    
    [self layoutTextInfoView];
    
    [self layoutPhotosView];
    
    [self layoutBottomBarView];
}

/**
 *  设置用户信息部分的位置
 */
- (void)layoutUserInfoView
{
    self.userInfoView.frame = CGRectMake(kMargin, 12, MTScreenW - 2 * kMargin, 40);
    
    self.portraitView.frame = CGRectMake(0, 0, 40, 40);
    
    [self.nameLb sizeToFit];
    self.nameLb.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame) + 10, 2, CGRectGetWidth(self.nameLb.frame), CGRectGetHeight(self.nameLb.frame));
    
    [self.timeLb sizeToFit];
    self.timeLb.frame = CGRectMake(CGRectGetMinX(self.nameLb.frame), CGRectGetMaxY(self.nameLb.frame) + 7, CGRectGetWidth(self.timeLb.frame), CGRectGetHeight(self.timeLb.frame));
    
    
    [self.headTagLb sizeToFit];
    self.headTagLb.frame = CGRectMake(CGRectGetMaxX(self.nameLb.frame) + 10, 2, CGRectGetWidth(self.headTagLb.frame) + 8, CGRectGetHeight(self.headTagLb.frame)+4);
    
    self.attentionBtn.frame = CGRectMake(CGRectGetWidth(self.userInfoView.frame) - 50, 5, 50, 30);
}

/**
 *  设置文本内容部分的位置
 */
- (void)layoutTextInfoView
{
    CGSize titleSize = [self.titleLb sizeThatFits:CGSizeMake(MTScreenW - 2 * kMargin, MAXFLOAT)];
    self.titleLb.frame = CGRectMake(0, 0, MTScreenW - 2 * kMargin, titleSize.height);
    
    CGSize size = [self.contentLb sizeThatFits:CGSizeMake(MTScreenW - 2 * kMargin, MAXFLOAT)];
    if (self.contentLb.attributedText) {
        self.contentLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame) + 12, size.width, size.height);
    }else{
        self.contentLb.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
    self.textInfoView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.userInfoView.frame) + 12, MTScreenW - 2 * kMargin, CGRectGetMaxY(self.contentLb.frame));
}

/**
 *  设置图片部分的位置
 */
- (void)layoutPhotosView
{
    CGFloat photoWidth = floor((MTScreenW - 2 * kMargin - 2 *kPhotoPadding) / 3);
    CGFloat photoHeight = photoWidth;
    for (int i = 0; i < 3; i++) {
        UIImageView *v = self.photos[i];
        if (i < self.photoNum) {
            v.frame = CGRectMake((photoWidth + kPhotoPadding) * i, 0, photoWidth, photoHeight);
            v.hidden = NO;
        }else{
            v.hidden = YES;
            v.image = nil;
        }
    }
    
    if (self.photoNum != 0) {
        self.photosView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.textInfoView.frame) + 12, MTScreenW - 2 * kMargin, photoHeight);
    }else{
        self.photosView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.textInfoView.frame), MTScreenW - 2 * kMargin, 0);
    }
}

/**
 *  设置底部工具条部分的位置
 */
- (void)layoutBottomBarView
{
    self.bottomBarView.frame = CGRectMake(kMargin, CGRectGetMaxY(self.photosView.frame) + 12, MTScreenW - 2 * kMargin, 30);
    
    [self.barTagBtn sizeToFit];
    self.barTagBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.barTagBtn.frame) + 15, 30);
    
    [self.plBtn sizeToFit];
    self.plBtn.frame = CGRectMake(MTScreenW - 2 * kMargin -(CGRectGetWidth(self.plBtn.frame) + 10), 0, CGRectGetWidth(self.plBtn.frame) + 10, 30);
    
    [self.dzBtn sizeToFit];
    self.dzBtn.frame = CGRectMake(CGRectGetMinX(self.plBtn.frame) - 10 - (CGRectGetWidth(self.dzBtn.frame) + 10), 0, CGRectGetWidth(self.dzBtn.frame) + 10, 30);
    
    [self.ydBtn sizeToFit];
    self.ydBtn.frame = CGRectMake(CGRectGetMinX(self.dzBtn.frame) - 10 - (CGRectGetWidth(self.ydBtn.frame) + 10), 0, CGRectGetWidth(self.ydBtn.frame) + 10, 30);
    
    self.height = CGRectGetMaxY(self.bottomBarView.frame) + 12;
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
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    attentionBtn.layer.borderWidth = 1.0f;
    attentionBtn.layer.borderColor = HMColor(247, 147, 30).CGColor;
    [attentionBtn setTitleColor:HMColor(247, 147, 30) forState:UIControlStateNormal];
    [infoView addSubview:attentionBtn];
    self.attentionBtn = attentionBtn;
    
    [self.attentionBtn addTarget:self action:@selector(tapAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  创建文本内容部分的视图
 */
- (void)setupTextInfoView
{
    UIView *textInfoView = [[UIView alloc] init];
    [self.contentView addSubview:textInfoView];
    self.textInfoView = textInfoView;
    
    //文章标题
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.numberOfLines = 0;
    [textInfoView addSubview:titleLb];
    self.titleLb = titleLb;
    
    //文章内容
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
    
    self.photos = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.backgroundColor = HMColor(230, 230, 230);
        [self.photosView addSubview:imgV];
        [self.photos addObject:imgV];
    }
}

/**
 *  创建底部工具条部分的视图
 */
- (void)setupBottomBarView
{
    UIView *bottomBarView = [[UIView alloc] init];
    [self.contentView addSubview:bottomBarView];
    self.bottomBarView = bottomBarView;
    
    self.ydBtn = [self createBtnWithTitle:self.itemdata.views image:@"yd_icon"];
    self.dzBtn = [self createBtnWithTitle:self.itemdata.recommend_add image:@"dz_icon"];
    self.plBtn = [self createBtnWithTitle:self.itemdata.replies image:@"pl_icon"];
    
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
    [btn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.bottomBarView addSubview:btn];
    return btn;
}

- (void)tapAttentionBtn:(UIButton *)sender
{
    //操作动作，add或del，add是加关注，del是取消关注
    NSDictionary *params = @{
                             @"action":@"add",
                             @"uid": @"123",
                             @"rel":@"321",
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_attention_do parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

@end
