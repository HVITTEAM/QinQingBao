//
//  GoodsDescriptionViewController.m
//  QinQingBao
//
//  Created by shi on 16/1/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsDescriptionViewController.h"
#import "PictureCell.h"

@interface GoodsDescriptionViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIControl *detailBtn;                 //详情按钮

@property (weak, nonatomic) IBOutlet UITableView *pictureTableView;          //显示图片的UITableView

@property(assign,nonatomic)BOOL isdrag;           //当前是否正在拖动

@end

@implementation GoodsDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initsubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //释放缓存
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark -- getter 方法 --
-(NSArray *)imageUrlArray
{
    if (!_imageUrlArray) {
        _imageUrlArray = [[NSArray alloc] init];
    }
    return _imageUrlArray;
}

#pragma mark -- 初始化子视图方法 --
/**
 *  设置子视图属性
 */
-(void)initsubViews
{
    self.detailBtn.layer.cornerRadius = self.detailBtn.bounds.size.width/2;
    self.detailBtn.layer.masksToBounds = YES;
    
    self.pictureTableView.dataSource = self;
    self.pictureTableView.delegate = self;
}

#pragma mark -- 协议方法 --
#pragma mark Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageUrlArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pictureCellId = @"pictureCell";
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:pictureCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //从缓存中获取图片，如果没有找到，看tableView是否在减速状态，减速状态不下载图片,其它状态正常下载图片
    NSString *urlStr = self.imageUrlArray[indexPath.row];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (!image) {
        image = [UIImage imageNamed:@"ic_logo"];
        if (!self.isdrag && tableView.decelerating) {   //减速状态不下载
        }else{
            //下载图片
            [self loadImageWithIndexpath:indexPath url:urlStr];
        }
    }
    
    cell.imageViewOfCell.image = image;
    
    return cell;
}

#pragma mark  UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从缓存中获取图片，如果没有找到就用默认的图片
    NSString *urlStr = self.imageUrlArray[indexPath.row];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (!image) {
        image = [UIImage imageNamed:@"ic_logo"];
    }
    
    //根据图片计算cell 高度
    CGFloat scale = image.size.width / image.size.height;
    CGFloat cellHeight = MTScreenW / scale;
    
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //使用图片浏览器查看图片
    SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc]
                                                   initPhotoBrowserWithImageURls:self.imageUrlArray
                                                   currentIndex:indexPath.row placeholderImageNmae:nil];
    
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark  UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isdrag = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isdrag = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImageForVisibleCells];
}

#pragma mark -- 事件方法 --
- (IBAction)enterGoodsDetail:(id)sender
{
    [NoticeHelper AlertShow:@"你已经进入商品详情了" view:self.view];
}

#pragma mark -- 内部方法 --
/**
 *  为所有可见 cell 加载图片(防止有的cell没加载图片)
 */
- (void)loadImageForVisibleCells
{
    //获得所有可见 cell 的indexPath
    NSArray *visiableIndexPaths = [self.pictureTableView indexPathsForVisibleRows];
    
    for(NSIndexPath *indexpath in visiableIndexPaths)
    {
        //下载图片
        NSString *urlStr = self.imageUrlArray[indexpath.row];
        [self loadImageWithIndexpath:indexpath url:urlStr];
    }
}

/**
 *  为指定的 Cell 下载图片
 */
-(void)loadImageWithIndexpath:(NSIndexPath *)idx url:(NSString *)urlStr
{
    NSURL *imageurl = [[NSURL alloc] initWithString:urlStr];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageurl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            //下载成功进行缓存
            [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr toDisk:YES];
            //刷新 tableView
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pictureTableView reloadData];
            });
        }else{
            NSLog(@"%d=========%@",(int)idx.row,@"图片下载失败");
        }
    }];
}

@end
